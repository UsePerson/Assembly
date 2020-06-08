.386
.model flat, stdcall
.stack 4096
option casemap:none

INCLUDELIB Irvine32.lib
INCLUDELIB ucrt.lib
INCLUDE sort.inc
scanf PROTO C, format:PTR BYTE, args:VARARG
ExitProcess PROTO, A:DWORD

.data
	arr_size SDWORD 0
	arr SDWORD 1000 DUP(?)
.code 
	main PROC 
	start_:
		push offset arr
		push offset arr_size
		CALL readInput				;	call readInput
		
		cmp arr_size, 0
		jle end_					;	if arr_size <= 0, jump to end_

		push OFFSET arr
		push arr_size
		CALL insertion_sort	

		push OFFSET arr
		push arr_size
		CALL printArray
		jmp start_
	end_:
		INVOKE ExitProcess,0
		main ENDP
		END main

