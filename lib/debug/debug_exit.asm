%ifndef FUNC_DEBUG_EXIT
%define FUNC_DEBUG_EXIT

%include "lib/sys/exit.asm"

%macro debug_exit 1
; %1: exit code
	mov dil, %1
	jmp exit
%endmacro

%endif
