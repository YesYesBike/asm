%ifndef MACRO_SWAP
%define MACRO_SWAP

%macro swap 2
	xor %1, %2
	xor %2, %1
	xor %1, %2
%endmacro

%endif
