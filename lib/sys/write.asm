%ifndef FUNC_WRITE
%define FUNC_WRITE

%include "lib/sys/syscalls.asm"

write:
	SYS_PUSH_SYSCALL_CLOBBERED_REGISTERS

	mov rax, SYS_WRITE
	syscall

	SYS_POP_SYSCALL_CLOBBERED_REGISTERS

	ret

%endif
