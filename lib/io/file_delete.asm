%ifndef FUNC_FILE_DELETE
%define FUNC_FILE_DELETE

%include "lib/sys/syscalls.asm"

file_delete:
	SYS_PUSH_SYSCALL_CLOBBERED_REGISTERS

	mov rax, SYS_UNLINK
	syscall

	SYS_POP_SYSCALL_CLOBBERED_REGISTERS

	ret

%endif
