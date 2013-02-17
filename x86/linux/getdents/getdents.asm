BITS 32
GLOBAL _start
_start:
    jmp get_eip
 
run:
    xor eax, eax
    xor edi, edi
    inc edi
    inc edi
    inc edi
    inc edi

    ; fd = sys_open(".", 0, 0)
    add eax, edi  ; sys_open
    inc eax
    pop ebx       ; filename
    xor ecx, ecx  ; flags = 0
    xor edx, edx  ; mode = 0
    int 0x80

    test eax,eax  ; file exists?
    jz error

    mov ebx, eax  ; fd

    ; getdents(fd,esp,0x1337)
    mov edx, 0x1337 ;size
    sub esp, edx    ;make room on the stack
    mov ecx, esp    ;buffer
    mov eax, 0x8d   ;sys_getdents
    int 0x80

    mov edx, eax    ;size

    ; close(fd)
    mov eax, edi ; 4 + 2
    inc eax
    inc eax
    int 0x80 ; fd in ebx
 
    ; sys_write
    mov    ecx, esp ; buffer
    mov    ebx, edi ; fd 4
    mov    eax, edi ; sys_write
    int    0x80     ; size in edx

    add esp, edx    ; free up stack

error:
    ; sys_exit
    xor eax, eax
    inc eax
    xor ebx,ebx
    int 0x80

get_eip:
    call run
 
filename:
    db '.', 0x0
