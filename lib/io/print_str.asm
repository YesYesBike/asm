%ifndef FUNC_PRINT_STR
%define FUNC_PRINT_STR

%include "lib/io/print.asm"
%include "lib/io/strlen.asm"
%include "lib/etc/swap.asm"

print_str: ; void print_str(int fd{rdi}, char *str{rsi})
	push rax
	push rdx

	swap rdi, rsi
	call strlen
	swap rdi, rsi
	mov rdx, rax

	call print

	pop rdx
	pop rax
	ret

%endif
