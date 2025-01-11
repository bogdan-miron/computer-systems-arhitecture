bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, fopen, fscanf, fread               
import exit msvcrt.dll    
import printf msvcrt.dll
import fopen msvcrt.dll
import fscanf msvcrt.dll
import fread msvcrt.dll
                          

; our data is declared here (the variables needed by our program)
; se da un sir de 10 numere in fisierul input.txt, sa se determine cifra minima din fiecare si sa se afiseze pe ecran
segment data use32 class=data
    input_filename db 'input.txt', 0
    access_mode_read db 'r', 0
    format db '%d', 0
    fd dd 0
    format_read db '%d', 0
    
    sir times 10 db 0
    lensir equ $-sir

; our code starts here
segment code use32 class=code
    cif_min:
        ; luam numarul de pe stiva
        mov AL, byte [ESP + 4] ; numarul curent
        mov BL, 10 ; cifra minima result
    repeat_functie:
        cmp AL, 0
        jz peste_functie
        mov AH, 0 ; AX = AL
        mov DL, 10
        div byte DL ; AL = AX / 10, AH = AX % 10
        cmp AH, BL
        jae mai_mare
        mov BL, AH ; am updatat noua valoare de rezultat
        
    mai_mare:
        jmp repeat_functie
    
    peste_functie:
        mov EAX, 0
        mov AL, BL ; cifra minima din numar este in AL
        ret 1 * 4
    
    start:
        
        ; deschidem fisierul si luam fd
        push access_mode_read
        push input_filename
        call [fopen]
        mov [fd], EAX
        add ESP, 2 * 4
        
        ; citim cele 10 numere din fisierul input.txt
        mov ESI, sir ; indexul curent
        mov ECX, 10 ; contor, 10 elemente, 0 -> 9 elemente 
        jecxz peste ; nu se va executa niciodata, dar e good practice
   repeat_label:
        ; citim sir[ESI]
        push ECX
        push dword ESI
        push dword format_read
        push dword [fd]
        call [fscanf]
        add ESP, 3 * 4
        inc ESI
        
        pop ECX
        
        loop repeat_label ; dec ECX, jnz repeat_label
        
   peste:
        ; in sir sunt salvate numerele
        ; pentru fiecare numar, se determina cifra minima si sa afiseze cifra minima
        ; iteram prin sir
        mov ESI, sir
        mov ECX, lensir
        jecxz stop_label
   repeat_final:
        mov EBX, 0
        mov BL, [ESI] ; EBX = BL
        inc ESI
        ; printam cifra minima din BL
        push EBX
        call cif_min
        ; EAX = AL = cif_min
        ; trebuie sa printam AL pe ecran
        push ECX
        push EAX
        push dword format
        call [printf]
        add esp, 8
        pop ECX
        loop repeat_final
   
   stop_label:
        
        
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
