section .data
    ; res = (a + b)^2 - (c - d)^2 / (a + e^3 - c)
    res dq 0
    a  dd 10         ; 32-битное знаковое число
    b  dw 20         ; 16-битное знаковое число
    c  dd 17         ; 32-битное знаковое число
    d  dw 15         ; 16-битное знаковое число
    e  dd 3          ; 32-битное знаковое число

section .text
global _start

_start:
    movsx r8, dword [a]
	movsx r9, word [b]
	movsx r10, dword [c]
	movsx r11, word [d]
	movsx r12, word [e]

    ; Вычисление (a - b)
    add r8, r9

    ; Вычисление (c + d)
    sub r10, r11

    ; Вычисление (a - b)^2
    mov rax, r8
    imul r8
    mov	esi, eax ;кладем младшую часть от умножения в esi
	sal	rdx, 32  ;передвигаем старшие 32 бита в младшие 32 
	or	rsi, rdx 
    mov r9, rsi

    ; Вычисление (a - b)^2
    mov rax, r10
    imul r10
    mov	esi, eax ;кладем младшую часть от умножения в esi
	sal	rdx, 32  ;передвигаем старшие 32 бита в младшие 32 
	or	rsi, rdx 
    mov r11, rsi

    ; Вычисоение (a + b)^2 - (c - d)^2
    sub r9, r11

    ; Вычисление e^2
    mov rax, r12
    imul r12
    mov	esi, eax ;кладем младшую часть от умножения в esi
	sal	rdx, 32  ;передвигаем старшие 32 бита в младшие 32 
	or	rsi, rdx 

    mov rax, rsi
    imul r12
    mov	esi, eax ;кладем младшую часть от умножения в esi
	sal	rdx, 32  ;передвигаем старшие 32 бита в младшие 32 
	or	rsi, rdx 
     mov r12, rsi

    ;Вычисление (a + e^3 - c)
    movsx r8, dword [a]
	movsx r10, dword [c]
    add r8, r12
    sub r8, r10

    ;Проверка на 0
    or	r8, r8
	jz	err

    ;Вычисление (a + b)^2 - (c - d)^2 / (a + e^3 - c)
    mov rax, r9
    cqo
    idiv r8

    mov [res], rax

    mov eax, 60
	mov	edi, 0
	syscall

err:
    mov	eax, 60
    mov	edi, 1
    syscall
