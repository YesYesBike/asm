%ifndef FUNC_PRINT
%define FUNC_PRINT

; Before Use It
; 1. Define the value: _PRINT_BUF_SIZE (4096,0x1000)
; 2. Append print.BUF end of the code
; 3. Add the value of _PRINT_BUF_SIZE to EXTRA_MEMORY_SIZE
; 4. (Optional)Align print.BUF

; Before You Exit
; Flush the buffer using 'print_flush'

%include "lib/io/print_flush.asm"

align 16, db 0
print: ; void print(int fd{rdi}, char *str{rsi}, size_t len{rdx})
; rax: current buffer position
; r8: buffer endpoint
; rdx: string endpoint
; cl: temp character
	push rax
	push rcx
	push rdx
	push rsi
	push r8

	mov rax, .BUF
	add rax, [.IDX]

	mov r8, .BUF
	add r8, _PRINT_BUF_SIZE

	add rdx, rsi

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
