%ifndef FUNC_EXIT_FLUSH
%define FUNC_EXIT_FLUSH

%include "lib/sys/exit.asm"
%include "lib/io/print_flush.asm"

exit_flush: ; _Noreturn void exit_flush(int fd{rdi}, byte ret{sil})
; exit with flushing print.BUF to 'fd'. exit code is 'ret'
	call print_flush
	mov dil, sil
	jmp exit

%endif
