%ifndef FUNC_PWRITE
%define FUNC_PWRITE

%include "lib/sys/syscalls.asm"

pwrite:
	SYS_PUSH_SYSCALL_CLOBBERED_REGISTERS

	mov rax, SYS_PWRITE
	syscall

	SYS_POP_SYSCALL_CLOBBERED_REGISTERS

	ret

%endif
