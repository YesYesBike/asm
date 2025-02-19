;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;DEFINITION;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%define LOAD_ADDRESS		0x00020000
%define CODE_SIZE			(END - (LOAD_ADDRESS+0x78))
%define BUFSIZE				4096
%define EXTRA_MEMORY_SIZE	BUFSIZE

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
%include "lib/sys/open.asm"
%include "lib/sys/read.asm"
%include "lib/sys/write.asm"
%include "lib/sys/close.asm"

%include "lib/etc/err_exit.asm"

; %include "lib/debug/dump_register.asm"
; %include "lib/io/print_int_x.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;INSTRUCTION;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

[map all mem.map]

START:
	mov rax, qword [SYS_ARGC_START_POINTER]
	test rax, ~3
	jnz .argc_fail

	mov rdi, qword [SYS_ARGC_START_POINTER+16]
	mov rsi, SYS_READ_ONLY
	call open
	test rax, rax
	js .open_fail_src
	mov r8, rax			; r8: fd_src

	mov rdi, qword [SYS_ARGC_START_POINTER+24]
	mov rsi, (SYS_WRITE_ONLY|SYS_CREATE_FILE|SYS_TRUNCATE)
	mov rdx, SYS_DEFAULT_PERMISSIONS
	call open
	test rax, rax
	js .open_fail_dst
	mov r9, rax			; r9: fd_dst

align 16
.loop:
	mov rdi, r8
	mov rsi, BUF
	mov rdx, BUFSIZE
	call read
	test rax, rax
	js .read_fail
	jz .copy_done

	mov rdi, r9
	mov rdx, rax
	call write
	cmp rax, rdx
	jnz .write_fail

	jmp .loop

.copy_done:
	mov rdi, r8
	call close
	test rax, rax
	jnz .close_fail_src

	mov rdi, r9
	call close
	test rax, rax
	jnz .close_fail_dst

	xor dil, dil
	jmp exit

.argc_fail:
	mov rdi, .MSG_ERR_ARGC
	jmp err_exit

.open_fail_src:
	mov rdi, .MSG_ERR_OPEN_SRC
	jmp err_exit

.open_fail_dst:
	mov rdi, .MSG_ERR_OPEN_DST
	jmp err_exit

.read_fail:
	mov rdi, .MSG_ERR_READ
	jmp err_exit

.write_fail:
	mov rdi, .MSG_ERR_WRITE
	jmp err_exit

.close_fail_src:
	mov rdi, .MSG_ERR_CLOSE_SRC
	jmp err_exit

.close_fail_dst:
	mov rdi, .MSG_ERR_CLOSE_DST
	jmp err_exit


.MSG_ERR_ARGC:
	db `Usage: ./copy src dest\n`, 0
.MSG_ERR_OPEN_SRC:
	db `src open failed\n`, 0
.MSG_ERR_OPEN_DST:
	db `dst open failed\n`, 0
.MSG_ERR_READ:
	db `read failed\n`, 0
.MSG_ERR_WRITE:
	db `write failed\n`, 0
.MSG_ERR_CLOSE_SRC:
	db `src close failed\n`, 0
.MSG_ERR_CLOSE_DST:
	db `dst close failed\n`, 0

align 16, db 0
END:

BUF:
