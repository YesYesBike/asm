%ifndef FUNC_READV
%define FUNC_READV

%include "lib/sys/syscalls.asm"

readv:
	SYS_PUSH_SYSCALL_CLOBBERED_REGISTERS

	mov rax, SYS_READV
	syscall

	SYS_POP_SYSCALL_CLOBBERED_REGISTERS

	ret

%endif
