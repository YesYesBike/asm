%ifndef FUNC_TERM_INIT
%define FUNC_TERM_INIT

%include "lib/sys/syscalls.asm"

term_init:
	SYS_PUSH_SYSCALL_CLOBBERED_REGISTERS
	push rdi
	push rsi
	push rdx
	push rax

	mov rax, SYS_IOCTL
	mov rdi, SYS_STDIN
	mov rsi, SYS_TCGETA
	mov rdx, .orig
	syscall

	; TODO
	mov rax, SYS_IOCTL
	mov rdx, .raw
	syscall

	; TODO
	and dword [.raw],~(SYS_IGNBRK+SYS_BRKINT+SYS_PARMRK+SYS_ISTRIP+SYS_INLCR+SYS_IGNCR+SYS_ICRNL+SYS_IXON)
	and dword [.raw+4],~SYS_OPOST
	and dword [.raw+8],~(SYS_CSIZE+SYS_PARENB)
	or dword [.raw+8],SYS_CS8
	and dword [.raw+12],~(SYS_ICANON+SYS_ECHO+SYS_ECHONL+SYS_ISIG+SYS_IEXTEN)

	pop rax
	pop rdx
	pop rsi
	pop rdi
	SYS_POP_SYSCALL_CLOBBERED_REGISTERS
	ret

align 16, db 0
.orig:
	times 48 db 0

.raw:
	times 48 db 0

%endif
