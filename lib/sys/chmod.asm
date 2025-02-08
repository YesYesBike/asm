%ifndef FUNC_CHMOD
%define FUNC_CHMOD

%include "lib/sys/syscalls.asm"

chmod: ; int{rax} chmod(char *file{rdi}, long perm{rsi})
	SYS_PUSH_SYSCALL_CLOBBERED_REGISTERS

	mov rax, SYS_CHMOD
	syscall

	SYS_POP_SYSCALL_CLOBBERED_REGISTERS

	ret

%endif
