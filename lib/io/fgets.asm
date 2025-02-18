%ifndef FUNC_FGETS
%define FUNC_FGETS

%include "lib/sys/read.asm"

fgets:
; no need to push
	dec rdx
	call read

	add rsi, rdx
	mov byte [rsi], 0
	sub rsi, rdx
	inc rdx

	ret

%endif
