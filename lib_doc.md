# Library Documentation

## Index
* [chmod](#chmod)
* [chomp](#chomp)
* [close](#close)
* [debug_exit](#debug_exit)
* [dump_memory](#dump)
* [dump_register](#dump)
* [dump_stack](#dump)
* [exit](#exit)
* [fgets](#fgets)
* [open](#open)
* [print](#print)
* [print_char](#print_char)
* [print_flush](#print_flush)
* [print_int_b](#print_int)
* [print_int_d](#print_int)
* [print_int_o](#print_int)
* [print_int_u](#print_int)
* [print_int_x](#print_int)
* [print_str](#print_str)
* [read](#read)
* [strlen](#strlen)
* [strtoi_b](#strtoi)
* [strtoi_d](#strtoi)
* [strtoi_o](#strtoi)
* [strtoi_x](#strtoi)
* [swap](#swap)
* [term_init](#term)
* [term_orig](#term)
* [term_raw](#term)
* [unlink](#unlink)
* [utf8encode](#utf8encode)
* [utf8getbyte](#utf8getbyte)
* [write](#write)

<br>

<h2 id="chmod">chmod</h2>

### Name
chmod - change permissions of a file

### Synopsis
int**{rax}** chmod(char _\*pathname_**{rdi}**, long _mode_**{rsi}**);

### Description
See `chmod(2)`.

<br>

<h2 id="chomp">chomp</h2>

### Name
chomp - remove a newline character in the string

### Synopsis
void chomp(char _\*str_**{rdi}**);

### Description
`chomp()` removes the __first__ appeared newline character in _str_.

<br>

<h2 id="close">close</h2>

### Name
close - close a file descriptor

### Synopsis
int**{rax}** close(int _fd_**{rdi}**);

### Description
See `close(2)`.

<br>

<h2 id="debug_exit">debug_exit</h2>

### Name
debug\_exit - exit for debugging purpose

### Synopsis
debug\_exit _status_

### Description
Made to distinguish from exit call in a real code.

<br>

<h2 id="dump">dump</h2>

### Name
dump\_register, dump\_memory, dump\_stack - print the information for debugging

### Synopsis
typedef void func\_p(int _fd_, long _num_);    //print\_int\_??  
void dump\_register(int _fd_**{[rsp+8]}**, func\_p _func_**{[rsp+16]}**);  
void dump\_memory(int _fd_**{rdi}**, void \*_p_**{rsi}**, size\_t _n_**{rdx}**,
func\_p _func_**{rcx}**);  
void dump\_stack(int _fd_**{rdi}**, int _num_**{rsi}**, func\_p _func_**{rdx}**);

### Description
`dump_register()` prints registers(rax~r15) to _fd_ using _func_.
Before calling, push _func_ first, and then push _fd_ into the stack.

`dump_memory()` prints each bytes from _p_ up to _p_+_n_-1 using _func_ to _fd_.

`dump_stack()` prints the stack from **rsp** up to **rsp**+(8\*_num_)
to _fd_ using _func_p_.

<br>

<h2 id="exit">exit</h2>

### Name
exit - terminate the process

### Synopsis
\_Noreturn void exit(_status_**{dil}**);

### Description
See `exit(2)`.
Use `jmp` instead of `call` for this function.

<br>

<h2 id="fgets">fgets</h2>

### Name
fgets - input the string

### Synopsis
void fgets(int _fd_**{rdi}**, char _\*buf_**{rsi}**, size_t _len_**{rdx}**);

### Description
See `fgets(3)`. This function doesn't return any value.

<br>

<h2 id="open">open</h2>

### Name
open - open a file descriptor

### Synopsis
int**{rax}** open(char _\*pathname_**{rdi}**, int _flags_**{rsi}**,
/\* long _mode_**{rdx}** \*/);

### Description
See `open(2)`.

<br>

<h2 id="print">print</h2>

### Name
print - print out the string

### Synopsis
void print(int _fd_**{rdi}**, char _\*str_**{rsi}**, size\_t _len_**{rdx}**);

### Description
Set these things before using

1. Define the value **\_PRINT\_BUF\_SIZE**(around 4096).
2. Append **print.BUF** label at the end of the code.
3. Add the value of **_PRINT\_BUF\_SIZE** to **EXTRA\_MEMORY\_SIZE**.
4. (Optional)Align **print.BUF**.

Flush the buffer with `print_flush()` before you exit or
switching _fd_ to the other value.

<br>

<h2 id="print_char">print_char</h2>

### Name
print\_char - print a single character

### Synopsis
void print\_char(int _fd_**{rdi}**, byte _enum_**{sil}**);

### Description
`print_char()` prints a single character to _fd_.

_enum_ list

* PRINT\_CHAR\_NEWLINE ;Same as 0
* PRINT\_CHAR\_SPACE
* PRINT\_CHAR\_TAB

<br>

<h2 id="print_flush">print_flush</h2>

### Name
print\_flush - flush a buffer

### Synopsis
void print\_flush(int _fd_**{rdi}**);

### Description
`print_flush` flushes the buffer(**print.BUF**) to _fd_.
Note: Buffer will not be empty using this function.

<br>

<h2 id="print_int">print_int</h2>

### Name
print\_int\_b, print\_int\_o, print\_int\_d, print\_int\_u, print\_int\_x -
print the integer number

### Synopsis
void print\_int\_b(int _fd_**{rdi}**, long _num_**{rsi}**);
void print\_int\_o(int _fd_**{rdi}**, long _num_**{rsi}**);
void print\_int\_d(int _fd_**{rdi}**, long _num_**{rsi}**);
void print\_int\_u(int _fd_**{rdi}**, long _num_**{rsi}**);
void print\_int\_x(int _fd_**{rdi}**, long _num_**{rsi}**);

### Description
Prints _num_ in a binary/octal/signed decimal/unsigned decimal/hexadecimal format.

<br>

<h2 id="read">read</h2>

### Name
read - read from a file descriptor

### Synopsis
long**{rax}** read(int _fd_**{rdi}**, void _\*buf_**{rsi}**,
size\_t _cnt_**{rdx}**);

### Description
See `read(2)`.

<br>

<h2 id="strlen">strlen</h2>

### Name
strlen - get the length of a string

### Synopsis
long**{rax}** strlen(char _\*str_**{rdi}**);

### Description
See `strlen(3)`.

<br>

<h2 id="strtoi">strtoi</h2>

### Name
strtoi\_b, strtoi\_o, strtoi\_d, strtoi\_x - convert a string to an integer

### Synopsis
long**{rax}** strtoi\_b(char _\*str_**{rdi}**);  
long**{rax}** strtoi\_o(char _\*str_**{rdi}**);  
long**{rax}** strtoi\_d(char _\*str_**{rdi}**);  
long**{rax}** strtoi\_x(char _\*str_**{rdi}**);

### Description
`strtoi()` gets the integer value from a string.
The string should have a following format:

* strtoi\_b: ^0b[01]+
* strtoi\_o: ^0o[0-7]+
* strtoi\_d: ^-?[0-9]+
* strtoi\_x: ^0x[0-9a-fA-F]+

<br>

<h2 id="swap">swap</h2>

### Name
swap - swap the values of two registers

### Synopsis
swap _reg1_ _reg2_

### Description
Same as

```
xor reg1, reg2
xor reg2, reg1
xor reg1, reg2
```

<br>

<h2 id="term">term</h2>

### Name
term\_init, term\_orig, term\_raw - change the terminal mode
using terminal attributes

### Synopsis
void term\_init(void);  
void term\_orig(void);  
void term\_raw(void);

### Description
`term_init()` reads the terminal attributes of `stdin` file descriptor and
store the attributes for original and raw mode.

`term_orig()` recovers the original terminal attributes.

`term_raw()` sets **raw mode**(See `termios(3)` for more detail).

`term_init()` must be called before using `term_orig()` or `term_raw()`.

### See Also
`termios(3)`

<br>

<h2 id="unlink">unlink</h2>

### Name
unlink - delete a file

### Synopsis
int**{rax}** unlink(char _\*pathname_**{rdi}**);

### Description
See `unlink(2)`.

<br>

<h2 id="utf8encode">utf8encode</h2>

### Name
utf8encode - encode a unicode character to a utf8 format

### Synopsis
long**{rax}** utf8encode(int _code_**{edi}**);

### Description
`utf8encode()` converts 4 byte unicode character _code_ to utf8 format.

It returns 0 if _code_ is not valid unicode character.

### See Also
`utf8(7)`

### TODO
endian

<br>

<h2 id="utf8getbyte">utf8getbyte</h2>

### Name
utf8getbyte - count utf8 characters of a unicode character

### Synopsis
byte**{al}** utf8getbyte(int _code_**{edi}**);

### Description
`utf8getbyte()` returns the number of bytes that needs for utf8 format.

### See Also
`utf8(7)`

<br>

<h2 id="write">write</h2>

### Name
write - write to a file descriptor

### Synopsis
long**{rax}** write(int _fd_**{rdi}**, void _\*buf_**{rsi}**,
size\_t _cnt_**{rdx}**);

### Description
See `write(2)`.
