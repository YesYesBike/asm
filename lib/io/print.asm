%ifndef FUNC_PRINT
%define FUNC_PRINT

; Befor Use it
; 1. Define the value: _PRINT_BUF_SIZE (4096,0x1000)
; 2. Append 'print.BUF' end of code
; 3. Change the segment size of memory in PROGRAM_HEADER
;		CODE_SIZE -> CODE_SIZE+_PRINT_BUF_SIZE
%include "lib/io/print_flush.asm"

align 16, db 0
print: ; void print(int fd{rdi}, char *str{rsi}, size_t len{rdx})
	push rax
	push rcx
	push rdx
	push rsi
	push r8

	mov rax, .BUF
	add rax, [.IDX]		; rax: cur buf pos

	mov r8, .BUF
	add r8, _PRINT_BUF_SIZE		; r8: buf endpoint

	add rdx, rsi	; rdx: str endpoint

.loop:
	cmp rsi, rdx		; if str reached end
	je .loop_end		; then break

	mov cl, byte [rsi]
	mov byte [rax], cl
	inc rsi
	inc rax				; *rax++ = *rsi++

	cmp rax, r8			; if buf is not full
	jne .loop			; then continue

	call print_flush
	mov rax, .BUF		; reset buf

	jmp .loop

.loop_end:
	sub rax, .BUF
	mov [.IDX], rax

.ret:
	pop r8
	pop rsi
	pop rdx
	pop rcx
	pop rax
	ret
.IDX:		; current buffer index
	dq 0
; .BUF:
; 	times _PRINT_BUF_SIZE db 0

%endif
