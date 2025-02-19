%ifndef FUNC_DUP3
%define FUNC_DUP3

%include "lib/sys/syscalls.asm"

dup3:
	SYS_PUSH_SYSCALL_CLOBBERED_REGISTERS

	mov rax, SYS_DUP3
	syscall

	SYS_POP_SYSCALL_CLOBBERED_REGISTERS

	ret

%endif
