%ifndef FUNC_EXIT
%define FUNC_EXIT

%include "lib/sys/syscalls.asm"

exit:	; _Noreturn void exit(status{dil})
	mov rax, SYS_EXIT
	syscall

%endif
