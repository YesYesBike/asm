%ifndef FUNC_PRINT_INT_O
%define FUNC_PRINT_INT_O

%include "lib/io/print.asm"

print_int_o: ; void print_int_o(int fd{rdi}, long num{rsi})
; print the octal number from 'num' to 'fd'
; rbp: stores the original stack pointer
; rsp: points to the string
; dil: temp num/digit storage
	push rdx
	push rbp
	push rsi
	push rdi		; fd: [rbp]
	mov rbp, rsp

align 16
.loop:
	test rsi, rsi
	jz .prefix

	mov dil, sil
	and dil, 7
	or dil, 0x30			; 0~9 -> '0'~'9'

	dec rsp
	mov byte [rsp], dil		; push the digit

	shr rsi, 3
	jmp .loop

.prefix:
	dec rsp
	mov byte [rsp], '0'

.print:
; rdi: fd([rbp])
; rsi: str(rsp)
; rdx: len(rbp-rsp)
	mov rdi, [rbp]
	mov rsi, rsp
	mov rdx, rbp
	sub rdx, rsp

	call print

.ret:
	mov rsp, rbp
	add rsp, 8		; pop rdi
	pop rsi
	pop rbp
	pop rdx
	ret

%endif
