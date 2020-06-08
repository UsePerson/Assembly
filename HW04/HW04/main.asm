.386
.model flat, stdcall
.stack 4096
option casemap:none

includelib ucrt.lib
includelib legacy_stdio_definitions.lib
ExitProcess PROTO, dwExitCode:DWORD
printf PROTO C, format:PTR BYTE, args:VARARG
scanf PROTO C, format:PTR BYTE, args:VARARG
.data
	input BYTE "%d",0
	countEqualOne BYTE "%d",0
	printMul BYTE " * ",0
	printNewline BYTE 0dh,0ah,0
	countAboveOne BYTE "%d^%d",0
	divStartTwo DWORD 2
	count DWORD 0
	a DWORD 0
	input1 SDWORD 0
.code
	main PROC
	L1:
		INVOKE scanf, ADDR input,ADDR input1
		cmp input1, 0			
		jle end_												;	if input1 < 0, jump to end_
		cmp input1, 1
		je print_newline										;	if input1 == 0, jump to print_newline
		mov eax, input1											;	eax = input1
		mov a, eax												;	a = eax
	Factorization:
		mov edx, 0	
		mov eax, a
		div divStartTwo											;	edx:eax / modStartTwo
		cmp edx, 0
		jnz cmp_count											;	if edx != 0, jump to cmp_count
		mov a, eax												;	if edx == 0, a = eax
		add count, 1											;	count ++
		jmp Factorization											
	cmp_count:
		cmp count, 1	
		jb set_													;	if count < 1, jump to set_
		ja print_countAboveOne									;	if count > 1, jump to print_countAboveOne
		INVOKE printf, ADDR	countEqualOne, divStartTwo			;	if count == 1, print "%d" 
		cmp a, 1												
		je print_newline										;	if a == 1, jump to print_newline
		INVOKE printf, ADDR	printMul							;	print " * "
		jmp set_
	print_countAboveOne:
		INVOKE printf, ADDR	countAboveOne, divStartTwo, count	;	count > 1, print "%d^%d" 
		cmp a, 1												
		je print_newline										;	if a == 1, jump to print_newline
		INVOKE printf, ADDR	printMul							;	print " * "
	set_:
		add divStartTwo, 1										;	divStartTwo += 1
		mov count, 0											;	count = 0
		jmp Factorization
	print_newline:
		INVOKE printf, ADDR	printNewline
		mov divStartTwo, 2
		mov count, 0
		jmp L1		
	end_:
		INVOKE ExitProcess, 0
	main ENDP
END main