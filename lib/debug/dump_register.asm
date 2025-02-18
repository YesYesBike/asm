%ifndef FUNC_DUMP_REGISTER
%define FUNC_DUMP_REGISTER

%include "lib/io/print.asm"

dump_register:
; rax: start of the stack loop (~rbp)
; rcx: register name string pointer
; rdx: string length per register
; rbx: 'func_p'
; rbp: original rsp(before call) -> return address(end of the loop)
; rsi: second argument for 'func_p' and 'print'
; rdi: 'fd'
; .RETADDR: points to the return address

	mov [.RETADDR], rsp
	push r15
	push r14
	push r13
	push r12
	push r11
	push r10
	push r9
	push r8
	push rdi
	push rsi
	push rbp
	mov rbp, [.RETADDR]
	add rbp, 8		; rbp: original rsp value before call(points 'fd' as well)
	push rbp		; rsp
	push rbx
	push rdx
	push rcx
	push rax

	mov rax, rsp

	mov rcx, rbp	; rcx: temp
	mov rdi, [rcx]	; rdi: fd
	add rcx, 8
	mov rbx, [rcx]	; rbx: func_p

	mov rcx, .REG_NAMES
	mov rdx, (.REG_NAMES_END-.REG_NAMES)/16

	sub rbp, 8		; now rbp has the return address

align 16
.loop:
	mov rsi, rcx	; rsi: str
	call print
	add rcx, rdx

	mov rsi, [rax]	; rsi: old register value from stack
	call rbx		; print_int_?

	add rax, 8
	cmp rax, rbp	; if rax reached rbp
	jnz .loop		; then break

.end:
	mov rsi, .REG_NAMES
	mov rdx, 1
	call print		; print newline character

.ret:
	pop rax			; that alpahbet order
	pop rcx
	pop rdx
	pop rbx
	add rsp, 8		; discard original rsp value
	pop rbp
	pop rsi
	pop rdi
	pop r8
	pop r9
	pop r10
	pop r11
	pop r12
	pop r13
	pop r14
	pop r15
	mov rsp, [.RETADDR]
	ret

.RETADDR:
	dq 0
.REG_NAMES:
	db `\nrax: `
	db `\nrcx: `
	db `\nrdx: `
	db `\nrbx: `
	db `\nrsp: `
	db `\nrbp: `
	db `\nrsi: `
	db `\nrdi: `
	db `\nr8:  `
	db `\nr9:  `
	db `\nr10: `
	db `\nr11: `
	db `\nr12: `
	db `\nr13: `
	db `\nr14: `
	db `\nr15: `
.REG_NAMES_END:

%endif
