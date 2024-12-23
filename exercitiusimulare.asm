bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fread, fprintf             
import exit msvcrt.dll    
import fopen msvcrt.dll
import fread msvcrt.dll
import fprintf msvcrt.dll
                          

; our data is declared here (the variables needed by our program)

; Se da un sir de caractere . Se se afiseze numarul de bytes din fisier, o noua linie, numarul de spatii albe din fisier, caracterele mici sa devine caractere mari. Denumirea fisierului de intrare este input_simulare.txt. Denumirea fisierului de output este output_simulare.txt

segment data use32 class=data
    input_filename db 'input_simulare.txt', 0
    output_filename db 'output_simulare.txt', 0
    s times 100 db 0
    access_mode_read db 'r', 0
    access_mode_write db 'w', 0
    
    format_output_one db '%d', 0
    format_output_two db '%s', 0
    format_output_three db '%d', 0
    format_output_four db '%s', 0
    
    fd_input dd 0
    fd_output dd 0
    
    bytes_count dd 0
    space_count dd 0
    
    nl dd 10, 0

; our code starts here
segment code use32 class=code
    start:
        ; opening the input file
        push access_mode_read
        push input_filename
        call [fopen]
        mov [fd_input], EAX
        add ESP, 2 * 4
        
        ; opening the output file
        push access_mode_write
        push output_filename
        call [fopen]
        mov [fd_output], EAX
        add ESP, 2 * 4
        
        ; reading the string from the file into the variable 's'
        push dword [fd_input]
        push dword 100
        push dword 1
        push s
        call [fread]
        add ESP, 4 * 4
        
        ; calculating the number of bytes from the file.
        mov [bytes_count], EAX
        
        ; print number of bytes from file
        push dword [bytes_count]
        push format_output_one
        push dword [fd_output]
        call [fprintf]
        add ESP, 3 * 4
        
        ; print a newline
        push nl
        push format_output_two
        push dword [fd_output]
        call [fprintf]
        add ESP, 3 * 4
        
        ; print a newline
        push nl
        push format_output_two
        push dword [fd_output]
        call [fprintf]
        add ESP, 3 * 4
        
        ; count the number of white spaces in the file
        mov ESI, s
        mov EDX, 0
        
    repeat_label:
        cmp [ESI], byte 0
        je afara
        cmp [ESI], byte " "
        jne peste
        inc EDX
        
    peste:
        inc ESI
        jmp repeat_label
        
    afara:
    
        ; print the space count
        push dword EDX
        push format_output_three
        push dword [fd_output]
        call [fprintf]
        add ESP, 3 * 4
        
        ; print a newline
        push nl
        push format_output_two
        push dword [fd_output]
        call [fprintf]
        add ESP, 3 * 4
        
        ; make all small characters uppercase
        mov ESI, s
        
    repeat_label_two:
        cmp [ESI], byte 0
        je end_program
        cmp [ESI], byte ' '
        je nu_respecta
        cmp [ESI], byte 'a'
        jnae nu_respecta
        cmp [ESI], byte 'z'
        jnbe nu_respecta
        sub [ESI], byte ('a' - 'A')
        
    nu_respecta:
        inc ESI
        jmp repeat_label_two
        
    end_program:
        ; print the new string s
        push s
        push format_output_four
        push dword [fd_output]
        call [fprintf]
        add ESP, 3 * 4
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
