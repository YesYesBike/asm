%ifndef FUNC_STRTOI_X
%define FUNC_STRTOI_X

strtoi_x:
	push rdi
	push rsi
	xor rax, rax
	add rdi, 2

.loop:
	mov sil, byte [rdi]
	test sil, sil
	jz .loop_end

	inc rdi
	test sil, 0b01000000
	jz .loop_digit

.loop_alpha:
	and rsi, ~0b01100000
	add rsi, 9
	shl rax, 4
	or rax, rsi

	jmp .loop

.loop_digit:
	and rsi, ~0x30
	shl rax, 4
	or rax, rsi
	jmp .loop

.loop_end:
	pop rdi
	pop rsi
	ret

%endif
