%ifndef FUNC_OPEN
%define FUNC_OPEN

%include "lib/sys/syscalls.asm"

open:
	SYS_PUSH_SYSCALL_CLOBBERED_REGISTERS

	mov rax, SYS_OPEN
	syscall

	SYS_POP_SYSCALL_CLOBBERED_REGISTERS

	ret

%endif
