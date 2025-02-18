%ifndef FUNC_PRINT_CHAR
%define FUNC_PRINT_CHAR

%define PRINT_CHAR_NEWLINE		0
%define PRINT_CHAR_SPACE		1
%define PRINT_CHAR_TAB			2

%include "lib/io/print.asm"

print_char:
	push rsi
	push rdx

	add rsi, .CHAR
	mov rdx, 1
	call print

	pop rdx
	pop rsi
	ret

.CHAR:
	db `\n \t`

%endif
