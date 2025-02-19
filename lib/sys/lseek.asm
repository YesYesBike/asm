%ifndef FUNC_LSEEK
%define FUNC_LSEEK

%include "lib/sys/syscalls.asm"

lseek:
	SYS_PUSH_SYSCALL_CLOBBERED_REGISTERS

	mov rax, SYS_LSEEK
	syscall

	SYS_POP_SYSCALL_CLOBBERED_REGISTERS

	ret

%endif
