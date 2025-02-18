%ifndef FUNC_PRINT_INT_D
%define FUNC_PRINT_INT_D

%include "lib/io/print.asm"

print_int_d:
; print the signed decimal number from 'num' to 'fd'
; rdi: fd
; rsi: original dividend([rbp]) -> divisor(10)
; rax: dividend
; rdx: remainder
; rbp: stack pointer
	; push rdi
	push rax
	push rdx
	push rbp
	push rsi		; [rbp]
	mov rbp, rsp

	mov rax, rsi
	mov rsi, 10

	test rax, rax
	jns .loop
	neg rax			; non-negative

align 16
.loop:
	xor rdx, rdx	; it's necessary
	div rsi			; remainder->dl
	or dl, 0x30		; 0~9->'0'~'9'
	dec rsp
	mov byte [rsp], dl
	test rax, rax
	jnz .loop

.sign:
; rax now has the original number
	mov rax, [rbp]
	test rax, rax
	jns .print
	dec rsp			; non-negative
	mov byte [rsp], '-'

.print:
; rdi: fd
; rsi: str
; rdx: len
	mov rsi, rsp
	mov rdx, rbp
	sub rdx, rsp
	call print

	mov rsp, rbp
	add rsp, 8
	mov rsi, rax	; pop rsi
	pop rbp
	pop rdx
	pop rax
	; pop rdi
	ret

%endif
