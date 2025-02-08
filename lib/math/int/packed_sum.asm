%ifndef FUNC_PACKED_SUM
%define FUNC_PACKED_SUM

packed_sum: long{rax} packed_sum(long *arr{rdi}, long n{rsi})
; computes the sum of {rsi} packed signed longs starting at {rdi}

	push rdi	; save registers
	push rsi

	xor rax,rax	; init running sum to zero
	cmp rdi,1	; check for at least 1 number to add
	jb .done	; if less than 1 number, don't bother

.loop:
	add rax,[rsi]	; add the value at the address in {rsi} to running sum
	add rsi,8	; move the {rsi} pointer ahead by 8 bytes
	dec rdi		; decrement {rdi} to track the number of numbers left
	jnz .loop	; if {rdi} is not yet zero, repeat the loop

.done:
	pop rsi		; restore registers
	pop rdi
	ret		; return

%endif
