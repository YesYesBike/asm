%ifndef FUNC_PREAD
%define FUNC_PREAD

%include "lib/sys/syscalls.asm"

pread:
	SYS_PUSH_SYSCALL_CLOBBERED_REGISTERS

	mov rax, SYS_PREAD
	syscall

	SYS_POP_SYSCALL_CLOBBERED_REGISTERS

	ret

%endif
