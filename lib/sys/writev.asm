%ifndef FUNC_WRITEV
%define FUNC_WRITEV

%include "lib/sys/syscalls.asm"

writev:
	SYS_PUSH_SYSCALL_CLOBBERED_REGISTERS

	mov rax, SYS_WRITEV
	syscall

	SYS_POP_SYSCALL_CLOBBERED_REGISTERS

	ret

%endif
