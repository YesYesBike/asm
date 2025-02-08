;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;DEFINITION;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%define LOAD_ADDRESS		0x00020000
%define CODE_SIZE			(END - (LOAD_ADDRESS+0x78))
%define EXTRA_MEMORY_SIZE	_PRINT_BUF_SIZE
%define _PRINT_BUF_SIZE		4096

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
%include "lib/io/print.asm"
%include "lib/math/int/print_int_x.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;INSTRUCTION;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

[map all mem.map]

START:
	mov rdi, 0x1234
	call print_int_x

	mov rdi, 1
	mov rsi, .NEWLINE
	mov rdx, 1
	call print

	mov rdi, 0x0
	call print_int_x

	mov rdi, 1
	mov rsi, .NEWLINE
	mov rdx, 1
	call print

	mov rdi, SYS_STDOUT
	call print_flush

	xor rdi, rdi
	jmp exit

.NEWLINE:
	db `\n`

align 16, db 0
END:
print.BUF:
