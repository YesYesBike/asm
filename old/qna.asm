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
	db 0x02							; 0x1: ANS_LEN, 0x2: 64
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
%include "lib/sys/read.asm"
%include "lib/io/print.asm"
%include "lib/io/print_str.asm"
%include "lib/io/fgets.asm"
%include "lib/io/chomp.asm"
%include "lib/io/print_char.asm"
%include "lib/io/strtoi_d.asm"
%include "lib/io/print_int_d.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;INSTRUCTION;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

[map all mem.map]

START:
%define ANS_LEN	32
	; Q1
	mov rdi, SYS_STDOUT
	mov rsi, .Q1
	mov rdx, (.Q2-.Q1)
	call print
	mov rsi, .Q_PROMPT
	mov rdx, (.Q1-.Q_PROMPT)
	call print
	call print_flush

	; A1
	mov rdi, SYS_STDIN
	mov rsi, .A1
	mov rdx, ANS_LEN
	call fgets


	; Q2
	mov rdi, SYS_STDOUT
	mov rsi, .Q2
	mov rdx, (.Q_END-.Q2)
	call print
	mov rsi, .Q_PROMPT
	mov rdx, (.Q1-.Q_PROMPT)
	call print
	call print_flush

	; A2
	mov rdi, SYS_STDIN
	mov rsi, .A2
	mov rdx, ANS_LEN
	call fgets

	; chomp
	mov rdi, .A1
	call chomp
	mov rdi, .A2
	call chomp

	; Age
	call strtoi_d
	inc rax

	; Print
	mov rdi, SYS_STDOUT

	; A1
	mov rsi, .M1
	mov rdx, (.M2-.M1)
	call print
	mov rsi, .A1
	call print_str
	xor rsi, rsi	; PRINT_CHAR_NEWLINE
	call print_char

	; A2
	mov rsi, .M2
	mov rdx, (.M_END-.M2)
	call print
	mov rsi, rax
	call print_int_d
	xor rsi, rsi	; PRINT_CHAR_NEWLINE
	call print_char

	call print_flush

	xor dil, dil
	jmp exit

.Q_PROMPT:
	db `\n> `
.Q1:
	db `Name?`
.Q2:
	db `Age?`
.Q_END:

.A1:
	times ANS_LEN db 0
.A2:
	times ANS_LEN db 0
.A_END:

.M1:
	db `Your name: `
.M2:
	db `Your age: `
.M_END:

align 16, db 0
END:

print.BUF:
