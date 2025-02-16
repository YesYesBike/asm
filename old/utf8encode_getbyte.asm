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
%include "lib/io/print_int_x.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;INSTRUCTION;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

[map all mem.map]

utf8encode: ; long{rax} utf8encode(int code{edi})
; return the encoded charset of 'code'
	call utf8encode_getbyte

utf8encode_getbyte: ; byte{al} utf8encode_getbyte(int code{edi})
; return the number of bytes of the 'code' needed in utf8 format
; return 0 if code is out of range
	xor rax, rax
	test edi, (1<<31)		; not defined
	jnz .fail
	test edi, (0x7c<<24)
	jnz .ret_6
	test edi, (0x3e<<20)
	jnz .ret_5
	test edi, (0x1f<<16)
	jnz .ret_4
	test edi, (0xf8<<8)
	jnz .ret_3
	test edi, (0x78<<4)
	jnz .ret_2
	jmp .ret_1

.ret_6:
	inc al
.ret_5:
	inc al
.ret_4:
	inc al
.ret_3:
	inc al
.ret_2:
	inc al
.ret_1:
	inc al
.fail:
	ret

START:
.test1:
	call utf8encode_getbyte
	cmp al, 1
	jnz .fail
	inc rdi
	cmp rdi, 0x7f
	jbe .test1

.test2:
	call utf8encode_getbyte
	cmp al, 2
	jnz .fail
	inc rdi
	cmp rdi, 0x7ff
	jbe .test2

.test3:
	call utf8encode_getbyte
	cmp al, 3
	jnz .fail
	inc rdi
	cmp rdi, 0xffff
	jbe .test3

.test4:
	call utf8encode_getbyte
	cmp al, 4
	jnz .fail
	inc rdi
	cmp rdi, 0x1fffff
	jbe .test4

.test5:
	call utf8encode_getbyte
	cmp al, 5
	jnz .fail
	inc rdi
	cmp rdi, 0x3ffffff
	jbe .test5

.test6:
	call utf8encode_getbyte
	cmp al, 6
	jnz .fail
	inc rdi
	cmp rdi, 0x7fffffff
	jbe .test6


	mov rcx, 0xffffffff			; can't compare 64bit immediate value
.test0:
	call utf8encode_getbyte
	test al, al
	jnz .fail
	inc rdi
	cmp rdi, rcx
	jbe .test0

.success:
	xor dil, dil
	jmp exit

.fail:
	mov rsi, rdi
	mov rdi, SYS_STDOUT
	call print_int_x

	call print_flush

	mov dil, 1
	jmp exit

END:

align 16, db 0
print.BUF:
