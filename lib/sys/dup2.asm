%ifndef FUNC_DUP2
%define FUNC_DUP2

%include "lib/sys/syscalls.asm"

dup2:
	SYS_PUSH_SYSCALL_CLOBBERED_REGISTERS

	mov rax, SYS_DUP2
	syscall

	SYS_POP_SYSCALL_CLOBBERED_REGISTERS

	ret

%endif
