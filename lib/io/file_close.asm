%ifndef FUNC_FILE_CLOSE
%define FUNC_FILE_CLOSE

%include "lib/sys/syscalls.asm"

file_close: ; int{rax} file_close(int fd{rdi})
	SYS_PUSH_SYSCALL_CLOBBERED_REGISTERS

	mov rax, SYS_CLOSE
	syscall

	SYS_POP_SYSCALL_CLOBBERED_REGISTERS

	ret

%endif
