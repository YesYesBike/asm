%ifndef FUNC_PRINT_INT_X
%define FUNC_PRINT_INT_X

%include "lib/io/print.asm"

print_int_x: ; void print_int_x(int fd{rdi}, long num{rsi})
; print the hexadecimal number from 'num' to 'fd'
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
	mov dil, sil
	and rdi, 0xf
	add rdi, .LOOKUP
	mov dil, byte [rdi]		; mov the hex digit to dil

	dec rsp
	mov byte [rsp], dil		; push the digit

	shr rsi, 4
	test rsi, rsi
	jnz .loop

.prefix:
	dec rsp
	dec rsp
	mov word [rsp], '0x'

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

align 16, db 0
.LOOKUP:
	db '0', '1', '2', '3', '4', '5', '6', '7',
	db '8', '9', 'a', 'b', 'c', 'd', 'e', 'f',

%endif
