%ifndef FUNC_PRINT_FLUSH
%define FUNC_PRINT_FLUSH

%include "lib/sys/syscalls.asm"

print_flush:
	SYS_PUSH_SYSCALL_CLOBBERED_REGISTERS
	push rax
	push rsi
	push rdx

	mov rsi, print.BUF
	mov rdx, [print.IDX]
	mov rax, SYS_WRITE
	syscall

	mov	qword [print.IDX], 0

	pop rdx
	pop rsi
	pop rax
	SYS_POP_SYSCALL_CLOBBERED_REGISTERS
	ret

%endif
