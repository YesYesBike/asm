%ifndef FUNC_STRLEN
%define FUNC_STRLEN

strlen: ; long{rax} strlen(char *str{rdi})
; sil: temp
	push rsi
	mov rax, rdi

align 16
.loop:
	mov sil, byte [rax]
	test sil, sil
	jz .ret
	inc rax
	jmp .loop

.ret:
	sub rax, rdi
	pop rsi
	ret

%endif
