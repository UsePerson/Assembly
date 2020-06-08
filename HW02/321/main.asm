.386
.model flat,stdcall
.stack 4096
option casemap : none

INCLUDELIB legacy_stdio_definitions.lib
INCLUDELIB ucrt.lib

ExitProcess PROTO,
	dwExitCode:DWORD
printf PROTO C,
	format:PTR BYTE,args:VARARG
scanf PROTO C,
	format:PTR BYTE,args:VARARG
.data
input BYTE "%d",0										;	scanf
n DWORD 0												;	scanf
read_input SDWORD 0										;	scanf
output_max BYTE " max = %d",0dh,0ah,0					;	printf
output_min BYTE " min = %d",0dh,0ah,0					;	printf		
max SDWORD 0											
min SDWORD 0											

.code
;-----------------------main start--------------------------------------------------------
main PROC 
	INVOKE scanf, ADDR input, ADDR n					;	read n (loop)
	INVOKE scanf, ADDR input, ADDR read_input			;	read first input
	sub n, 1											;	loop - 1
	mov eax, read_input									
	mov min, eax										;	set min
	mov max, eax										;	set max
	L1:
		cmp n, 0										
		je end_loop										;	if n == 0, jump to end_loop
		INVOKE scanf, ADDR input, ADDR read_input		;	read next input
		sub n, 1										;	loop - 1
		mov eax, read_input								
		cmp min, eax	
		jg min_											;	if min > input, jump to min_
		cmp max, eax
		jl max_											;	if max < input, jump to min_
		jmp L1											;	
	min_:
		mov min, eax
		jmp L1
	max_:
		mov max, eax									
		jmp L1
	end_loop:
		INVOKE printf, ADDR output_max, max				;	print max
		INVOKE printf, ADDR output_min, min				;	print min 
	INVOKE ExitProcess,0
	main ENDP
END main