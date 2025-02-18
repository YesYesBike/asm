%ifndef FUNC_PRINT
%define FUNC_PRINT

%include "lib/io/print_flush.asm"

align 16, db 0
print:
; rax: current buffer position
; r8: buffer endpoint
; rdx: string endpoint
; cl: temp character
	push rax
	push rcx
	push rdx
	push rsi
	push r8

	mov rax, .BUF
	add rax, [.IDX]

	mov r8, .BUF
	add r8, _PRINT_BUF_SIZE

	add rdx, rsi

align 16
.loop:
	cmp rsi, rdx		; if str reached end
	je .loop_end		; then break

	mov cl, byte [rsi]
	mov byte [rax], cl
	inc rsi
	inc rax				; *rax++ = *rsi++

	cmp rax, r8			; if buf is not full
	jne .loop			; then continue

	call print_flush
	mov rax, .BUF		; reset buf

	jmp .loop

.loop_end:
	sub rax, .BUF
	mov [.IDX], rax

.ret:
	pop r8
	pop rsi
	pop rdx
	pop rcx
	pop rax
	ret
.IDX:		; current buffer index
	dq 0
; .BUF:
; 	times _PRINT_BUF_SIZE db 0

%endif
