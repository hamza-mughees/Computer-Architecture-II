.686                                ; create 32 bit code
.model flat, C                      ; 32 bit memory model
option casemap:none                 ; case sensitive

.data
.code

;; Program 1

public poly
poly:
    push ebp                ; push frame pointer
    mov ebp, esp            ; update ebp

    push 2                  ; second parameter of pow subroutine
    push [ebp+8]            ; first parameter of pow subroutine
    call pow                ; call pow subroutine
    add esp, 8              ; remove parameters of pow subroutine from stack
    add eax, [ebp+8]        ; res += arg
    inc eax                 ; res += 1

    mov esp, ebp            ; restore esp
    pop ebp                 ; restore ebp
    ret 0

public pow
pow:
    push ebp                ; push frame pointer
    mov ebp, esp            ; update ebp
    push ebx                ; save non-volatile registers

    mov eax, 1              ; result = 1
    mov ebx, 1              ; i = 1
loop1:
    imul eax, [ebp+8]       ; result *= arg0
    inc ebx                 ; i++
    cmp ebx, [ebp+12]
    jle loop1               ; i <= arg1

    pop ebx                 ; restore non-volatile registers
    mov esp, ebp            ; restore esp
    pop ebp                 ; restore ebp
    ret 0

;; Program 2

public multiple_k_asm
multiple_k_asm:
    push ebp                ; push frame pointer
    mov ebp, esp            ; update ebp
    push si                 ; save ESI (start of array)
    push bx                 ; save non-volatile registers

    mov bx, 0               ; i = 0
    mov cx, [ebp+12]        ; cx = K
    mov esi, [ebp+16]       ; esi = array
loop2:
    mov dx, 0               
    mov [esi], dx           ; initialise array[i] = 0 (not incremented i)
    inc bx                  ; ++i (now this is going to act as i+1 with previous i)
    add esi, 2              ; increment array pointer by 2
    cmp bx, [ebp+8]         ; i < N       
    jg loop2e
    mov ax, bx              ; ax = i (incremented i)
    xor dx, dx              ; clear dx
    div cx                  ; storing mod result in dx
    cmp dx, 0               ; dx == 0
    jne loop2
    mov dx, 1               ; dx = 1
    mov [esi-2], dx         ; change array[i-1] = 0 (incremented i)
    jmp loop2
loop2e:

    pop bx                  ; retreive non-volatile registers
    pop si                  ; retreive ESI
    mov esp, ebp            ; restore esp
    pop ebp                 ; restore ebp
    ret

;; Program 3

public factorial
factorial:
    push ebp                ; push frame pointer
    mov ebp, esp            ; update ebp

    mov eax, [ebp+8]        ; N
    cmp eax, 0              ; N == 0
    je cond1m               ; Finish recursion
    sub eax, 1              ; N--
    push eax                ; 
    call factorial          ; factorial(N)

    cmp eax, 0              ; 
    je cond1
    imul eax, [ebp+8]       ; eax will always contain the
                            ; factorial of the value at [ebp+8]
    jmp cond1e
cond1:
    mov eax, [ebp+8]
    jmp cond1e
cond1m:
    mov eax, 1              ; handle input 0
cond1e:
    
    mov esp, ebp            ; restore esp
    pop ebp                 ; restore ebp
    ret 0

end