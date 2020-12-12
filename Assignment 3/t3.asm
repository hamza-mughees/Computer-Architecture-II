; Question 1 (max)

; r26 contains a
; r27 contains b
; r28 contains c
public max
max:
	  add r0, r26, r1			    ; v = a
	  jle max_0			          ; if v < b
    sub r27, r1, r0, {C}
    add r0, r27, r1 		    ; v = b
max_0:
	  jle max_1			          ; if v < c
    sub r28, r1, r0, {C}
    add r0, r28, r1		      ; v = c
max_1:
    ret r31, r0
    xor r0, r0, r0          ; NOPS

; Question 1 (max5)

    mov r0, #4, r2          ; inp_int = 4

; r26 contains i
; r27 contains j
; r28 contains k
; r29 contains l
public max5
max5:
    add r0, r2, r10         ; r10 = inp_int
    add r0, r26, r11        ; r11 = i
    callr r15, max          ; call max (return address in r15)
    add r0, r27, r12        ; r12 = j

    add r0, r1, r10         ; r10 = max(inp_int, i, j)
    add r0, r28, r11        ; r11 = k
    callr max, r15          ; call max (return address in r15)
    add r0, r29, r12        ; r12 = l

    ret r31, r0             ; return
    xor r0, r0, r0          ; NOPS

; Question 2

; r26 contains a
; r27 contains b
public fun
fun:
    jne fun_1
    sub r27, r0, r0, {C}    ; if b == 0
    ret r1, r0              ; return 0
    add r0, r0, r1
fun_1:
    add r0, r27, r11        ; r11 = b
    callr r15, modulus      ; modulus(b, 2)
    add r0, #2, r12         ; r12 = 2
    
    callr divide, r15       ; b/2
    add r0, r1, r16         ; r16 = modulus(b, 2) (for saving r1)

    add r26, r26, r11       ; r11 = a + a
    callr r15, fun          ; r1 = fun(a+a, b/2)
    add r0, r1, r12         ; r12 = b/2

    jne fun_2
    sub r16, r0, r0, {C}    ; if modulus(b, 2) == 0
    ret r1, r0              ; return fun(a+a, b/2)
    xor r0, r0, r0          ; NOPS
fun_2:
    ret r31, r0             ; return fun(a+a, b/2) + a
    add r1, r26, r1         ; r1 = fun(a+a, b/2) + a
