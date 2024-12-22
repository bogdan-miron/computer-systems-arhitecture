bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,fopen,fprintf,fread,fclose
import fopen msvcrt.dll
import fprintf msvcrt.dll
import fread msvcrt.dll               
import exit msvcrt.dll
import fclose msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    input_file db "input.txt",0
    output_file db "output.txt",0
    finput dd 0
    foutput dd 0
    s times 201 db 0
    access_mode_read db 'r',0
    access_mode_write db 'w',0
    input_format db "%s",0
    output_line_one db "%d",0
    output_line_four db "%s",0
    nr_de_bytes dd 0
    nl db 10,0
    ; ...

; our code starts here
segment code use32 class=code
    start:
        ; ...
        push access_mode_read
        push input_file
        call [fopen]
        MOV [finput],EAX
        ADD ESP,4*2
        
        push dword [finput]
        push dword 200
        push dword 1
        push s
        call [fread]
        ADD ESP,4*4
        
        ; nr de bytes cititi is in EAX
        MOV [nr_de_bytes],EAX
        
        push access_mode_write
        push output_file
        call [fopen]
        MOV [foutput],EAX
        ADD ESP,4*2
        
        ; nr bytes din fisier    
        push dword[nr_de_bytes]
        push output_line_one
        push dword[foutput]
        call [fprintf]
        ADD ESP,4*3
        
        ; print newline
        push nl
        push dword[foutput]
        call [fprintf]
        ADD ESP,4*2
        
        ; print newline
        push nl
        push dword[foutput]
        call [fprintf]
        ADD ESP,4*2
        
        ; nr de spatii
        MOV EDX,0
        MOV ESI,s
        repeta:
        cmp [ESI], byte 0
        je afara
        cmp [ESI], byte " "
        jne peste
        INC EDX
        peste:
        INC ESI
        jmp repeta
        afara:
        
        push EDX
        push output_line_one
        push dword[foutput]
        call [fprintf]
        ADD ESP,4*3
        
        ; print newline
        push nl
        push dword[foutput]
        call [fprintf]
        ADD ESP,4*2
        
        ; uppercase all
        
        MOV ESI,s
        repetaa:
        cmp [ESI],byte 0
        je outside
        cmp [ESI], byte " "
        je pass
        cmp [ESI],byte'Z'
        jb pass
        SUB [ESI],byte('a'-'A')
        pass:
        INC ESI
        jmp repetaa
        outside:
        
        push s
        push output_line_four
        push dword[foutput]
        call [fprintf]
        ADD ESP,4*3
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
