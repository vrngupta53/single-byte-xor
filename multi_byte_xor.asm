SYS_EXIT equ 1     ;system call codes for eax 
SYS_READ equ 3     ;system call codes for eax 
SYS_WRITE equ 4    ;system call codes for eax

STDIN equ 0        ;file descriptors for ebx
STDOUT equ 1       ;file descriptors for ebx

section .data
    text_msg db 'Enter text to xor:',0xa ;Ask user to input string to xor
    text_msg_len equ $-text_msg
    key_msg db 'Enter key to xor with:',0xa ;Ask user to input key to xor with
    key_msg_len equ $-key_msg

section .bss
    text resb 100     ;reserve 100 bytes memory for text input
    key resb 100      ;reserve 100 byte memory for key input
    text_len resb 1   ;reserve 1 byte for length of input string 
    key_len resb 2    ;reserve 1 byte for length of key

section  .text
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

    ;store length of input string in text_len
    mov [text_len] , al

    ;prompt user for key input
    mov eax , SYS_WRITE
    mov ebx , STDOUT
    mov ecx , key_msg
    mov edx , key_msg_len
    int 0x80

    ;store user input in buffer key
    mov eax , SYS_READ
    mov ebx , STDIN
    mov ecx , key
    mov edx , 100
    int 0x80

    ;store length of input key in key_len
    mov [key_len] , ax

    call multi_byte_xor

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

multi_byte_xor:
    mov eax , key
    xor rcx , rcx
    mov cl , byte [text_len]            ;put loop variable in ecx register
    mov ebx , text  
    xor rsi , rsi    
    l:
    mov dl , byte [eax]
    xor byte [ebx] , dl             ;xor byte at address in ebx
    add ebx , 1                     ;increment address in ebx by 1 to get to next byte
    add eax , 1                     ;increment address in eax by 1 to get to next byte
    add si , 1
    cmp si , [key_len]
    jne key_end
    xor si , si 
    mov eax , key
    key_end:
    loop l
    ret

