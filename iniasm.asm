org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

section .data
    hello_msg db 'Welcome to Ailen Anjelita OS!', ENDL, 0
    input_msg db 'system@ailen:~$: ', 0
    input_buffer times 64 db 0

section .text
    global start
    extern puts, keyboard_handler

start:
    jmp main

puts:
    pusha
.loop:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    mov bh, 0
    int 0x10
    jmp .loop
.done:
    popa
    ret

keyboard_handler:
    pusha
    in al, 0x60
    mov ah, 0x0E
    int 0x10
    movzx eax, al
    push eax
    push ebx
    mov ebx, input_buffer
    movzx edx, byte [ebx]
    mov [ebx + edx], al
    inc edx
    mov byte [ebx], dl
    pop ebx
    pop eax
    popa
    iret

main:
    mov ax, 0
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    mov si, hello_msg
    call puts

    mov si, input_msg
    call puts

    cli
    mov ah, 0
    mov al, 0x09
    mov di, keyboard_handler
    int 0x21
    sti

.text_input_loop:
    hlt
    jmp .text_input_loop

halt:
    jmp .halt

times 510-($-$$) db 0
dw 0xAA55
