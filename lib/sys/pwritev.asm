%ifndef FUNC_PWRITEV
%define FUNC_PWRITEV

%include "lib/sys/syscalls.asm"

pwritev:
	SYS_PUSH_SYSCALL_CLOBBERED_REGISTERS

	mov rax, SYS_PWRITEV
	syscall

	SYS_POP_SYSCALL_CLOBBERED_REGISTERS

	ret

%endif
