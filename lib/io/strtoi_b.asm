%ifndef FUNC_STRTOI_B
%define FUNC_STRTOI_B

strtoi_b:
; get the integer number from null-terminated string 'str' with a binary format
; format: "0b..."
; it doesn't check any kind of error... so don't give it a garbage...
; it doesn't check overflow...

; rax: return number / free to use
; rdi: string / need to push
; rsi: temp / need to push
	push rdi
	push rsi

	xor rax, rax	; reset
	add rdi, 2		; start of the actual number
	movzx rsi, byte [rdi]	; rsi = '0'~'1'

align 16
.loop:
	and rsi, ~0x30		; rsi = 0~1
	or al, sil			; al+=sil
	inc rdi
	movzx rsi, byte [rdi]
	test rsi, rsi		; if *rdi == '\0'
	jz .loop_end		; then break
	shl rax, 1
	jmp .loop

.loop_end:
	pop rsi
	pop rdi
	ret

%endif
