%ifndef FUNC_UTF8ENCODE
%define FUNC_UTF8ENCODE

%include "lib/io/utf8getbyte.asm"

utf8encode: ; long{rax} utf8encode(int code{edi})
; returns the encoded charset of 'code'
; if fails, returns zero
; most significant byte indicates the number of bytes
	call utf8getbyte	; al = 0~6
	test al, al			; 'code' can not be presented
	jz .fail
	test al, ~1			; one byte
	jz .ret_one

	push rbx
	push rcx
	push rdx

	push rax			; pushing byte count
	mov rcx, 7
	sub rcx, rax
	mov rax, 0b11111110
	shl al, cl			; al: 0b110XXXXX~0b1111110X

	pop rcx				; byte count
	dec rcx
	mov rbx, rcx
	imul ecx, 6
	shl ebx, 3			; *8
	mov edx, edi
	shr edx, cl
	or al, cl
	swap rcx, rbx
	shl rax, cl

.loop:
	swap rbx, rcx
	sub rcx, 6
	sub rbx, 8
	mov edx, edi
	shr edx, cl

	and edx, 0b111111
	or edx, 0b10000000
	swap rbx, rcx
	shl edx, cl
	or rax, rdx

	test rcx, rcx
	jnz .loop

.ret:
	pop rdx
	pop rcx
	pop rbx
.fail:
	ret

.ret_one:
	mov rax, rdi
	ret

%endif
