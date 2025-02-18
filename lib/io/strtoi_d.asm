%ifndef FUNC_STRTOI_D
%define FUNC_STRTOI_D

strtoi_d: ; long{rax} strtoi_d(char *str{rdi})
; get the integer number from null-terminated string 'str' with a decimal format
; format: -?[0-9]+
; it doesn't check any kind of error... so don't give it a garbage...
; it doesn't check overflow...

; rax: return number / free to use
; rdi: string / need to push
; rsi: temp / need to push
	push rsi
	push rdi
	xor rax, rax

	test byte [rdi], ~'-'
	jnz .loop
	inc rdi

.neg_loop:
	movzx rsi, byte [rdi]
	test rsi, rsi
	jz .neg_loop_end

	inc rdi
	and rsi, ~0x30
	imul rax, 10
	add rax, rsi
	jmp .neg_loop

.loop:
	movzx rsi, byte [rdi]
	test rsi, rsi
	jz .loop_end

	inc rdi
	and rsi, ~0x30
	imul rax, 10
	add rax, rsi
	jmp .loop

.neg_loop_end:
	neg rax
.loop_end:
	pop rdi
	pop rsi
	ret

%endif
