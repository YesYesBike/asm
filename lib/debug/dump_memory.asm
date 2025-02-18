%ifndef FUNC_DUMP_MEMORY
%define FUNC_DUMP_MEMORY

%include "lib/io/print.asm"
%include "lib/io/print_int_x.asm"

dump_memory:

; rax: 'p'+'n', loop endpoint
; rbx: 'p', loop
; rdi: fd, already initialized, maybe not needed to push
; rsi: function arg(print, func_p)
; rdx: function arg(print)
; rcx: func_p, already initialized, maybe not needed to push
; r8: eight indicator, init 0

	push rax
	push rdx
	push rbx
	push rsi
	push r8

	mov rbx, rsi	; rbx init
	mov rax, rsi
	add rax, rdx	; rax init
	xor r8, r8		; r8 init

.loop_out: ; print the memory address
	mov rsi, rbx
	call print_int_x

	mov rsi, .CHAR		; prints `: `
	mov rdx, 2
	call print

align 16
.loop_in: ; print bytes
	movzx rsi, byte [rbx]
	call rcx

	mov rsi, .CHAR+1	; prints ` `
	mov rdx, 1
	call print

	inc rbx
	cmp rbx, rax		; if ++rbx==rax
	je .loop_out_end	; then break

	inc r8
	and r8, 7			; if ++r8%7==0
	jnz .loop_in		; then break

.loop_in_end: ; print newline
	mov rsi, .CHAR+2
	call print	; rdx is 1
	jmp .loop_out

.loop_out_end:
	mov rsi, .CHAR+2
	call print	; rdx is 1

	pop r8
	pop rsi
	pop rbx
	pop rdx
	pop rax
	ret

.CHAR:
	db `: \n`

%endif
