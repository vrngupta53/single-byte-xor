SYS_EXIT equ 1     ;system call codes for eax 
SYS_READ equ 3     ;system call codes for eax 
SYS_WRITE equ 4    ;system call codes for eax

STDIN equ 0        ;file descriptors for ebx
STDOUT equ 1       ;file descriptors for ebx

section .data
    text_msg db 'Enter text to xor:',0xa ;Ask user to input string to xor
    text_msg_len equ $-text_msg
    char_msg db 'Enter character to xor with:',0xa ;Ask user to input  character to xor with
    char_msg_len equ $-char_msg
    

section .bss
    text resb 100   ;reserve 100 bytes memory for text input
    char resb 1     ;reserve 1 byte memory for key input
    counter resb 1  ;reserve 1 byte memory for counter loop variable

section .text
    GLOBAL _start

_start:
    ;prompt user for text input
    mov eax , SYS_WRITE
    mov ebx , STDOUT
    mov ecx , text_msg
    mov edx , text_msg_len
    int 0x80

    ;store user input in buffer text
    mov eax , SYS_READ
    mov ebx , STDIN
    mov ecx , text
    mov edx , 100
    int 0x80

    ;store number of bytes read in counter
    mov [counter] , al

    ;prompt user for character key input
    mov eax , SYS_WRITE
    mov ebx , STDOUT
    mov ecx , char_msg
    mov edx , char_msg_len
    int 0x80

    ;store user input in buffer char
    mov eax , SYS_READ
    mov ebx , STDIN
    mov ecx , char
    mov edx , 1
    int 0x80

    call single_byte_xor

    ;print xored text

    mov eax , SYS_WRITE
    mov ebx , STDOUT
    mov ecx , text
    mov edx , 100
    int 0x80

    ;exit program
    mov eax , SYS_EXIT
    mov ebx , 0
    int  0x80

single_byte_xor:
    mov al , [char]
    mov ecx , [counter] ;put loop variable in ecx register
    mov ebx , text      
    l:
    xor byte [ebx] , al ;xor byte at address in ebx
    add ebx , 1         ;increment address in ebx by 1 to get to next byte
    loop l
    ret

