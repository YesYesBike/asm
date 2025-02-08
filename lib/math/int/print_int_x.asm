print_int_x: ; void print_int_x(long num{rdi})
; print the hexadecimal number from 'num'
	push rax
	push rdx
	push rsi
	push rdi

	mov rsi, rsp

.loop:	; pushing digit into stack
; rdi: num -> 0
; rsi: begin of the string
; rax: stores the address of lookup table
; dl: stores the character
	test rdi, rdi
	jz .prefix

	mov al, dil
	and rax, 0xf
	add rax, .LOOKUP
	mov dl, [rax]
	dec rsi
	mov byte [rsi], dl	; first digit
	shr rdi, 4

	mov al, dil
	and rax, 0xf
	add rax, .LOOKUP
	mov dl, [rax]
	dec rsi
	mov byte [rsi], dl	; second digit
	shr rdi, 4

	jmp .loop

.prefix: ; 0x
	cmp rsp, rsi		; push '0' if 'num' is zero
	jnz .prefix_nonzero
	dec rsi
	mov word [rsi], '0'

.prefix_nonzero:
	dec rsi
	dec rsi
	mov word [rsi], '0x'

.print:
; rdi: file descriptor
; rsi: string
; rdx: length
	mov rdi, SYS_STDOUT
	mov rdx, rsp
	sub rdx, rsi

	mov rax, rsp
	mov rsp, rsi	; prevent overwriting data by 'call' inst
	call print
	mov rsp, rax

	pop rdi
	pop rsi
	pop rdx
	pop rax
	ret

align 16, db 0
.LOOKUP:
	db '0', '1', '2', '3', '4', '5', '6', '7',
	db '8', '9', 'a', 'b', 'c', 'd', 'e', 'f',
