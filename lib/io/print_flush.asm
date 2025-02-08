%ifndef FUNC_PRINT_FLUSH
%define FUNC_PRINT_FLUSH

print_flush: ; void print_flush(int fd{rdi})
	SYS_PUSH_SYSCALL_CLOBBERED_REGISTERS
	push rax
	push rsi
	push rdx

	mov rsi, print.BUF
	mov rdx, [print.IDX]
	mov rax, SYS_WRITE
	syscall

	xor rax, rax
	mov [print.IDX], rax

	pop rdx
	pop rsi
	pop rax
	SYS_POP_SYSCALL_CLOBBERED_REGISTERS
	ret

%endif
