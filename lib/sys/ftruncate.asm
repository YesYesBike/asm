%ifndef FUNC_FTRUNCATE
%define FUNC_FTRUNCATE

%include "lib/sys/syscalls.asm"

ftruncate:
	SYS_PUSH_SYSCALL_CLOBBERED_REGISTERS

	mov rax, SYS_FTRUNCATE
	syscall

	SYS_POP_SYSCALL_CLOBBERED_REGISTERS

	ret

%endif
