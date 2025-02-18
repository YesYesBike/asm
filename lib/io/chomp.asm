%ifndef FUNC_CHOMP
%define FUNC_CHOMP

chomp:
	push rdi
	push rsi

.loop:
	mov sil, byte [rdi]
	test sil, sil
	jz .loop_end
	test sil, ~`\n`
	jz .newline
	inc rdi
	jmp .loop

.newline:
	mov byte [rdi], 0

.loop_end:
	pop rsi
	pop rdi
	ret

%endif
