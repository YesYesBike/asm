%ifndef FUNC_CHMOD
%define FUNC_CHMOD

%include "lib/sys/syscalls.asm"

chmod:
	SYS_PUSH_SYSCALL_CLOBBERED_REGISTERS

	mov rax, SYS_CHMOD
	syscall

	SYS_POP_SYSCALL_CLOBBERED_REGISTERS

	ret

%endif
