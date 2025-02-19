%ifndef FUNC_TRUNCATE
%define FUNC_TRUNCATE

%include "lib/sys/syscalls.asm"

truncate:
	SYS_PUSH_SYSCALL_CLOBBERED_REGISTERS

	mov rax, SYS_TRUNCATE
	syscall

	SYS_POP_SYSCALL_CLOBBERED_REGISTERS

	ret

%endif
