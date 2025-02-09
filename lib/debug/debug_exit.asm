%ifndef FUNC_DEBUG_EXIT
%define FUNC_DEBUG_EXIT

%include "lib/sys/exit.asm"

debug_exit: ; _Noreturn void debug_exit(void)
; made to distinguish from the normal exit code
	xor rdi, rdi
	jmp exit

%endif
