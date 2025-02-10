%ifndef FUNC_FILE_READ
%define FUNC_FILE_READ

%include "lib/sys/syscalls.asm"

file_read:
	SYS_PUSH_SYSCALL_CLOBBERED_REGISTERS

	mov rax, SYS_READ
	syscall

	SYS_POP_SYSCALL_CLOBBERED_REGISTERS

	ret

%endif
