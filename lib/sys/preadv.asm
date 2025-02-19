%ifndef FUNC_PREADV
%define FUNC_PREADV

%include "lib/sys/syscalls.asm"

preadv:
	SYS_PUSH_SYSCALL_CLOBBERED_REGISTERS

	mov rax, SYS_PREADV
	syscall

	SYS_POP_SYSCALL_CLOBBERED_REGISTERS

	ret

%endif
