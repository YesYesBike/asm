%ifndef FUNC_PRINT_INT_B
%define FUNC_PRINT_INT_B

%include "lib/io/print.asm"

print_int_b: ; void print_int_b(int fd{rdi}, long num{rsi})
; print the binary number from 'num' to 'fd'
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
	shl dil, 2				; multiply offset by 4
	add rdi, .LOOKUP
	mov edx, dword [rdi]	; mov the bin digit to dil

	sub rsp, 4
	mov dword [rsp], edx	; push the digit

	shr rsi, 4
	test rsi, rsi
	jnz .loop

.prefix:
	dec rsp
	dec rsp
	mov word [rsp], '0b'

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
	db '0000', '0001', '0010', '0011', '0100', '0101', '0110', '0111',
	db '1000', '1001', '1010', '1011', '1100', '1101', '1110', '1111',

%endif
