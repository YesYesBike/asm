%ifndef FUNC_TERM_RAW
%define FUNC_TERM_RAW

%include "lib/io/term_init.asm"

term_raw:
	SYS_PUSH_SYSCALL_CLOBBERED_REGISTERS
	push rdi
	push rsi
	push rdx
	push rax

	mov rax, SYS_IOCTL
	mov rdi, SYS_STDIN
	mov rsi, SYS_TCSETA
	mov rdx, term_init.raw
	syscall

	pop rax
	pop rdx
	pop rsi
	pop rdi
	SYS_POP_SYSCALL_CLOBBERED_REGISTERS
	ret

%endif
