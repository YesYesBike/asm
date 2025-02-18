%ifndef FUNC_CLOSE
%define FUNC_CLOSE

%include "lib/sys/syscalls.asm"

close:
	SYS_PUSH_SYSCALL_CLOBBERED_REGISTERS

	mov rax, SYS_CLOSE
	syscall

	SYS_POP_SYSCALL_CLOBBERED_REGISTERS

	ret

%endif
