bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit
extern fopen
extern fread
extern fprintf 
extern printf    
extern scanf     
extern fscanf     
import exit msvcrt.dll
import fopen msvcrt.dll
import fread msvcrt.dll
import fprintf msvcrt.dll
import printf msvcrt.dll    
import scanf msvcrt.dll
import fscanf msvcrt.dll
                          

; our data is declared here (the variables needed by our program)
;22. read two numbers from input_lab9.txt and output the sum to output_lab9.txt, also specify filenames 
segment data use32 class=data
    msg1 db 'Please enter input filename: ', 0
    msg2 db 'Please enter output filename: ', 0
    format_msg db '%s', 0
    format_read db '%d %d', 0
    format_write db '%d', 0
    
    input_filename times 100 db 0
    output_filename times 100 db 0
    
    fd_input dd 0 ; file descriptor for the input file
    fd_output dd 0 ; file descriptor for the output file
    
    access_mode_read db 'r', 0
    access_mode_write db 'w', 0
    
    a db 0
    b db 0

; our code starts here
segment code use32 class=code
    start:
        ; print the first message
        push dword msg1
        push dword format_msg
        call [printf]
        add ESP, 2 * 4
        
        ; get input filename from user
        push dword input_filename
        push dword format_msg
        call [scanf]
        add ESP, 2 * 4
        
        ; print the second message
        push dword msg2
        push dword format_msg
        call [printf]
        add ESP, 2 * 4
        
        ; get output filename from user
        push dword output_filename
        push dword format_msg
        call [scanf]
        add ESP, 2 * 4
        
        ; move the file descriptor for input file in fd_input
        push access_mode_read
        push input_filename
        call [fopen]
        mov [fd_input], EAX
        add ESP, 2 * 4
        
        
        ; move the file descriptor for the output file in fd_output
        push access_mode_write
        push output_filename
        call [fopen]
        mov [fd_output], EAX
        add ESP, 2 * 4
        
        ; read variables from file
        push dword b
        push dword a
        push dword format_read
        push dword [fd_input]
        call [fscanf]
        add ESP, 4 * 4
        
        ; do the actual addition
        mov EAX, 0
        mov AL, [a]
        add AL, [b]
        
        push EAX
        push dword format_write
        push dword [fd_output]
        call [fprintf]
        add ESP, 3 * 4
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
