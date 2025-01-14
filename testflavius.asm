bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, fopen, fscanf, fread, fprintf, fclose
import exit msvcrt.dll    
import printf msvcrt.dll
import fopen msvcrt.dll
import fscanf msvcrt.dll
import fread msvcrt.dll  
import fprintf msvcrt.dll 
import fclose msvcrt.dll
                          


segment data use32 class=data
    input_filename db 'input.txt', 0
    output_filename db 'output.txt', 0
    s times 100 db 0
    access_mode_read db 'r', 0
    access_mode_write db 'w', 0
    
    fd_input dd 0
    fd_output dd 0
    
    bytes_count dd 0
    space_count dd 0
    
    nl dd 10, 0
    
    format_output_one db '%d', 0
    format_output_two db '%s', 0
    format_output_three db '%c', 0
    format_output_four db '%d', 0
    
    mascul dd 'M', 0
    femeie dd 'F', 0
    
    caracter dd 0

; our code starts here
segment code use32 class=code
    start:
        ; XLAT
        ; opening the input file
        push access_mode_read
        push input_filename
        call [fopen]
        mov [fd_input], EAX
        add ESP, 2 * 4
        
        
        ;opening the output file
        push access_mode_write
        push output_filename
        call [fopen]
        mov [fd_output], EAX
        add ESP, 2 * 4
        
        ; reading the string from the file into a variable 's'
        push dword [fd_input]
        push dword 100
        push dword 1
        push s
        call [fread]
        add ESP, 4 * 4
        
        mov [bytes_count], EAX
        
        ; print the number of bytes from the file
        push dword [bytes_count]
        push format_output_one
        push dword [fd_output]
        call [fprintf]
        add ESP, 3 * 4
        
        ; print a new line
        push nl
        push format_output_two
        push dword [fd_output]
        call [fprintf]
        add ESP, 3 * 4
        
        ; print the first word until space character
        mov ESI, s
        
    repeat_label:
        cmp [ESI], byte ' '
        je peste
        ; print the byte
        mov EDX, [ESI]
        push EDX
        push format_output_three
        push dword [fd_output]
        call [fprintf]
        add ESP, 3 * 4
        
        inc ESI
        jmp repeat_label
    
    peste:
        inc ESI ; trecem peste spatiul gol
    
    repeat_label_two:
        cmp [ESI], byte ' '
        je peste_doi
        inc ESI
        jmp repeat_label_two
    
    
    peste_doi:
        inc ESI ; am sarit peste spatiul gol, acuma suntem la cifra
        mov EAX, 0
        mov AL, [ESI]
        sub AL, byte '0' ; acum avem in al numarul efectiv
        add AL, 10
        
        push EAX
        
        push nl
        push format_output_two
        push dword [fd_output]
        call [fprintf]
        add ESP, 3 * 4
        
        pop EAX
        
        

        ; printam AL
        push dword EAX
        push format_output_four
        push dword [fd_output]
        call [fprintf]
        add ESP, 3 * 4
        
        ; print a new line
        push nl
        push format_output_two
        push dword [fd_output]
        call [fprintf]
        add ESP, 3 * 4
        
        
        
        ; vedem daca numele se termina in a sau nu
        mov ESI, s
    repeat_label_final:
        cmp [ESI], byte ' '
        je pana_mea
        inc ESI
        jmp repeat_label_final
    
    
    pana_mea:
        dec ESI
        ; in [ESI] avem ultima cifra din numele
        cmp [ESI], byte 'a'
        je femela
        ; print M
        push mascul
        push format_output_two
        push dword [fd_output]
        call [fprintf]
        add ESP, 3 * 4
        jmp over_final
        
    femela:
        push femeie
        push format_output_two
        push dword [fd_output]
        call [fprintf]
        add ESP, 3 * 4
        jmp over_final
    
    over_final:
        
        
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
