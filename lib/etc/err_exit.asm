%ifndef FUNC_ERR_EXIT
%define FUNC_ERR_EXIT

%include "lib/sys/syscalls.asm"
%include "lib/io/strlen.asm"
%include "lib/sys/write.asm"

err_exit:
	call strlen

	mov rsi, rdi
	mov rdi, SYS_STDERR
	mov rdx, rax
	call write

	mov dil, 1
	jmp exit

%endif
