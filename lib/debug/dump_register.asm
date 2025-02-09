%ifndef FUNC_DUMP_REGISTER
%define FUNC_DUMP_REGISTER

%include "lib/io/print.asm"

dump_register: ; void dump_register(int fd{[rsp+8]}, func_p{[rsp+16]})
; void func_p(int fd{rdi}, long num{rsi}) / ex)print_int_x

; dump registers(rax~r15) to 'fd' using 'func_p'
; NOTE: 'fd' and 'func_p' affects to rsp. So subtract 16 from rsp to get
;       the right rsp value
; NOTE2: push 'func_p' first and 'fd' next (so confusing)

; rax: start of the stack loop (~rbp)
; rcx: register name string pointer
; rdx: string length per register
; rbx: 'func_p'
; rbp: original rsp
; rsi: second argument for 'func_p' and 'print'
; rdi: 'fd'

	mov [.RSP_ORIG], rsp
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
	mov rbp, [.RSP_ORIG]	; now rbp has the original rsp value
	push rbp				; rsp
	push rbx
	push rdx
	push rcx
	push rax

	mov rax, rsp

	mov rcx, rbp	; rcx: temp
	add rcx, 8
	mov rdi, [rcx]	; rdi: fd
	add rcx, 8
	mov rbx, [rcx]	; rbx: func_p

	mov rcx, .REG_NAMES
	mov rdx, (.REG_NAMES_END-.REG_NAMES)/16

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
	mov rsp, [.RSP_ORIG]
	ret

.RSP_ORIG:
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
