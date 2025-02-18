%ifndef FUNC_TERM_ORIG
%define FUNC_TERM_ORIG

%include "lib/io/term_init.asm"

term_orig:
	SYS_PUSH_SYSCALL_CLOBBERED_REGISTERS
	push rdi
	push rsi
	push rdx
	push rax

	mov rax, SYS_IOCTL
	mov rdi, SYS_STDIN
	mov rsi, SYS_TCSETA
	mov rdx, term_init.orig
	syscall

	pop rax
	pop rdx
	pop rsi
	pop rdi
	SYS_POP_SYSCALL_CLOBBERED_REGISTERS
	ret

%endif
