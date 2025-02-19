%ifndef FUNC_DUP
%define FUNC_DUP

%include "lib/sys/syscalls.asm"

dup:
	SYS_PUSH_SYSCALL_CLOBBERED_REGISTERS

	mov rax, SYS_DUP
	syscall

	SYS_POP_SYSCALL_CLOBBERED_REGISTERS

	ret

%endif
