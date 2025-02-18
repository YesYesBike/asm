%ifndef FUNC_UNLINK
%define FUNC_UNLINK

%include "lib/sys/syscalls.asm"

unlink:
	SYS_PUSH_SYSCALL_CLOBBERED_REGISTERS

	mov rax, SYS_UNLINK
	syscall

	SYS_POP_SYSCALL_CLOBBERED_REGISTERS

	ret

%endif
