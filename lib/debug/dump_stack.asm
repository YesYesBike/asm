%ifndef FUNC_DUMP_STACK
%define FUNC_DUMP_STACK

%include "lib/io/print.asm"
%include "lib/io/print_int_d.asm"

dump_stack:
; rdi: fd
; rsi: func arg
; rdx: print length
; rbp: original rsp value
; rax: rsp+(8*'num')
; rcx: offset that prints
; rbx: function pointer
	mov [.RSP_ORIG], rsp
	push rax
	push rcx
	push rdx
	push rbx
	push rbp
	push rdi
	push rsi

	mov rbp, [.RSP_ORIG]	; rbp init
	add rbp, 8				; exclude return address of this fuction
	mov rax, rsi			; rsi free
	shl rax, 3
	mov rcx, rax			; rcx init
	add rax, rbp			; rax init
	mov rbx, rdx			; rbx init

align 16
.loop:
	mov rsi, .FORMAT		; \n[rsp+
	mov rdx, 6
	call print

	mov rsi, rcx
	call print_int_d

	mov rsi, (.FORMAT+6)	; ]:\t
	mov rdx, 3
	call print

	mov rsi, [rax]
	call rbx

	sub rax, 8
	sub rcx, 8

	cmp rax, rbp	; if rax >= rbp
	jge .loop		; then continue

.loop_end:
	mov rsi, .FORMAT	; newline
	mov rdx, 1
	call print

.ret:
	pop rsi
	pop rdi
	pop rbp
	pop rbx
	pop rdx
	pop rcx
	pop rax
	ret

.FORMAT:
	db `\n[rsp+]:\t`

.RSP_ORIG:	; store the original rsp value
	dq 0

%endif
