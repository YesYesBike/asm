%ifndef FUNC_PRINT_INT_U
%define FUNC_PRINT_INT_U

%include "lib/io/print.asm"

print_int_u:
; print the unsigned decimal number from 'num' to 'fd'
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

align 16
.loop:
	xor rdx, rdx	; it's necessary
	div rsi			; remainder->dl
	or dl, 0x30		; 0~9->'0'~'9'
	dec rsp
	mov byte [rsp], dl
	test rax, rax
	jnz .loop

.print:
; rdi: fd
; rsi: str
; rdx: len
	mov rsi, rsp
	mov rdx, rbp
	sub rdx, rsp
	call print

	mov rsp, rbp
	pop rsi
	pop rbp
	pop rdx
	pop rax
	; pop rdi
	ret

%endif
