%ifndef FUNC_STRTOI_O
%define FUNC_STRTOI_O

strtoi_o: ; long{rax} strtoi_o(char *str{rdi})
; get the integer number from null-terminated string 'str' with a binary format
; format: "0o..."
; it doesn't check any kind of error... so don't give it a garbage...
; it doesn't check overflow...

; rax: return number / free to use
; rdi: string / need to push
; rsi: temp / need to push
	push rdi
	push rsi

	xor rax, rax	; reset
	add rdi, 2		; start of the actual number
	movzx rsi, byte [rdi]	; rsi = '0'~'7'

align 16
.loop:
	and rsi, ~0x30		; rsi = 0~7
	or al, sil			; al+=sil
	inc rdi
	movzx rsi, byte [rdi]
	test rsi, rsi		; if *rdi == '\0'
	jz .loop_end		; then break
	shl rax, 3
	jmp .loop

.loop_end:
	pop rsi
	pop rdi
	ret

%endif
