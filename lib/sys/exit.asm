%ifndef FUNC_EXIT
%define FUNC_EXIT

%include "lib/sys/syscalls.asm"

exit:
	mov rax, SYS_EXIT
	syscall

%endif
