%ifndef FUNC_UTF8GETBYTE
%define FUNC_UTF8GETBYTE

utf8getbyte: ; byte{al} utf8encode_getbyte(int code{edi})
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

%endif
