;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;DEFINITION;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%define LOAD_ADDRESS		0x00020000
%define CODE_SIZE			(END - (LOAD_ADDRESS+0x78))
%define _PRINT_BUF_SIZE		4096
%define EXTRA_MEMORY_SIZE	_PRINT_BUF_SIZE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;HEADER;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BITS 64
org LOAD_ADDRESS
ELF_HEADER:
	db 0x7F, "ELF"
	db 0x02							; 0x1: 32, 0x2: 64
	db 0x01							; 0x1: Little, 0x2: Big
	db 0x01							; ELF Version
	db 0x03							; Linux
	db 0x00							; ABI Version
	times 7 db 0x00					; padding
	dw 0x0002						; Executable
	dw 0x003E						; AMD x86-64
	dd 0x00000001					; version 1
	dq START						; Entry Point
	dq 0x0000000000000040			; 0x40 offset from ELF_HEADER to PROGRAM_HEADER
	dq 0x0000000000000000			; section header offset
	dd 0x00000000					; unused
	dw 0x0040						; sizeof ELF_HEADER
	dw 0x0038						; sizeof PROGRAM_HEADER
	dw 0x0001						; number of program header entries: ONE
	dw 0x0000						; sizeof each section header entries
	dw 0x0000						; number of each section header entries
	dw 0x0000						; index of section header tables
PROGRAM_HEADER:
	dd 0x00000001					; 0x1: Loadable Segment
	dd 0x00000007					; rwx
	dq 0x0000000000000078			; offset of code start in file (0x40+0x38)
	dq LOAD_ADDRESS+0x78			; virtual address of segment in memory
	dq 0x0000000000000000			; physical address(ignored?)
	dq CODE_SIZE					; sizeof segment in file image(disk)
	dq CODE_SIZE+EXTRA_MEMORY_SIZE	; sizeof segment in memory
	dq 0x0000000000000000			; alignment (doesn't matter, only 1 segment)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;INCLUDES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%include "lib/sys/exit.asm"
%include "lib/debug/debug_exit.asm"
%include "lib/etc/swap.asm"
%include "lib/io/print_int_x.asm"
%include "lib/io/utf8getbyte.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;INSTRUCTION;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

[map all mem.map]

; dependency
; utf8getbyte
utf8encode: ; long{rax} utf8encode(int code{edi})
; returns the encoded charset of 'code'
; if fails, returns zero
; most significant byte indicates the number of bytes
	call utf8getbyte	; al = 0~6
	test al, al			; 'code' can not be presented
	jz .fail
	test al, ~1			; one byte
	jz .ret_one

	push rbx
	push rcx
	push rdx

	push rax			; pushing byte count
	mov rcx, 7
	sub rcx, rax
	mov rax, 0b11111110
	shl al, cl			; al: 0b110XXXXX~0b1111110X

	pop rcx				; byte count
	dec rcx
	mov rbx, rcx
	imul ecx, 6
	shl ebx, 3
	mov edx, edi
	shr edx, cl
	or al, cl
	swap rcx, rbx
	shl rax, cl

.loop:
	swap rbx, rcx
	sub rcx, 6
	sub rbx, 8
	mov edx, edi
	shr edx, cl

	and edx, 0b111111
	or edx, 0b10000000
	swap rbx, rcx
	shl edx, cl
	or rax, rdx

	test rcx, rcx
	jnz .loop

.ret:
	pop rdx
	pop rcx
	pop rbx
.fail:
	ret

.ret_one:
	mov rax, rdi
	ret

START:
	mov rdi, 0xAC00
	call utf8encode

	mov rdi, SYS_STDOUT
	mov rsi, rax
	call print_int_x

	call print_flush

	xor dil, dil
	jmp exit

END:

align 16, db 0
print.BUF:
