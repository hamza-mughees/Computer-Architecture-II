includelib legacy_stdio_definitions.lib
extrn printf:near
extrn scanf:near

.data
	print_string1 BYTE "Please enter an integer: ", 00h
	print_string2 BYTE "The sum of proc. and user inputs (%lld, %lld, %lld, %lld): %lld", 0Ah, 00h
	scan_string BYTE "%lld", 00h
	public inp_int
	inp_int QWORD 0
.code

;; Program 1

; rcx contains fin
public fibX64
fibX64:
	cmp rcx, 0				; if fin == 0
	jg fin_0
	mov rax, rcx			; return fin
	ret
fin_0:
	cmp rcx, 1				; if fin == 1
	jne fin_1
	mov rax, 1				; return 1
	ret
fin_1:						; otherwise
	sub rsp, 32				; allocate shadow space

	dec rcx					; fin - 1
	call fibX64				; fib(fin-1)
	mov [rsp+48], rax		; preserve sum in shadow space

	dec rcx					; fin - 2
	call fibX64				; fib(fin-2)
	add rcx, 2				; fin, for higher level of recursion
	add rax, [rsp+48]		; add sum to 

	add rsp, 32				; deallocate shadow space
	ret

;; Program 2

; rcx contains a
; rdx contains b
; r8 contains c
public use_scanf
use_scanf:
	lea rax, [rcx+rdx]
	add rax, r8				; a+b+c (sum)

	mov [rsp+32], rax		; preserve sum
	mov [rsp+24], rcx		; preserve a
	mov [rsp+16], rdx		; preserve b
	mov [rsp+8], r8			; preserve c

	sub rsp, 48				; create shadow space
	lea rcx, print_string1	; 1st argument: print_string
	call printf				; call printf function

	lea rdx, inp_int
	lea rcx, scan_string	; 1st argument: scan_string
	call scanf				; call scanf function

	mov rax, [rsp+80]		; retreive sum
	add rax, inp_int		; add inp_int (final sum)
	mov [rsp+80], rax		; saved final sum (to return)

	mov [rsp+40], rax		; 6th argument: final sum
	mov rax, inp_int		; moving inp_int into register
	mov [rsp+32], rax		; 5th argument: inp_int
	mov r9, [rsp+56]		; 4th argument: c
	mov r8, [rsp+64]		; 3rd argument: b
	mov rdx, [rsp+72]		; 2nd argument: a
	lea rcx, print_string2	; 1st argument: string
	call printf				; call the print function

	mov rax, [rsp+80]		; retreive final sum (to return)

	add rsp, 48
	ret

;; Program 3

; rcx contains a
; rdx contains b
; r8 contains c
public max
max:
	mov rax, rcx			; v = a
	cmp rdx, rax			; if b > v
	jle max_0
	mov rax, rdx			; v = b
max_0:
	cmp r8, rax				; if c > v
	jle max_1
	mov rax, r8				; v = c
max_1:
	ret

; rcx contains i
; rdx contains j
; r8 contains k
; r9 contains l
public max5
max5:
	mov [rsp+24], r8		; k

	sub rsp, 32				; allocate shadow space

	mov r8, rdx				; 3rd argument: j
	mov rdx, rcx			; 2nd argument: i
	mov rcx, inp_int		; 1st argument: inp_int
	call max				; call max function

	mov r8, r9				; 3rd argument: l
	mov rdx, [rsp+56]		; 2nd argument: k
	mov rcx, rax			; 1st argument: max(inp_int, i, j)
	call max				; call max function

	add rsp, 32				; deallocate shadow space
	ret

end
