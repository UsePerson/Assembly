.386
.model flat, stdcall

arr_size EQU [ebp + 8]
arr EQU [ebp + 12]
arr_index EQU SDWORD PTR[ebp - 4]
arr_sizeof EQU SDWORD PTR[ebp - 8]

INCLUDELIB legacy_stdio_definitions.lib
scanf PROTO C, format:PTR BYTE, args:VARARG
.data
	input BYTE "%d",0
.code
	readInput PROC										;	[ebp + 8] == arr_size , [ebp + 12] == arr
		push ebp
		mov ebp, esp									
		sub esp, 4										;	[ebp - 4] == arr_index , [ebp - 8] == arr_sizeof
		mov esi, arr_size								;	esi = arr_size
		INVOKE scanf, ADDR input, ADDR [esi]			;	read arr_size
		cmp SDWORD PTR[esi], 1						
		jl end_											;	if arr_size <= 0, jump to end_
		mov eax, [esi]
		mov ecx, 4
		imul ecx
		mov arr_sizeof, eax								;	set arr_sizeof ( arr_size * 4 )
		sub arr_sizeof, 4								;	arr_size : 0 ~ arr_size - 1 => arr_sizeof = arr_size*4 - 1
		mov arr_index, 0								;	set arr_index = 0
		mov ecx, arr_index
		mov ebx, arr_sizeof
		mov esi, arr									;	esi = arr
	read_value:
		INVOKE scanf, ADDR input, ADDR [esi +  ecx]		;	read arr value
		add arr_index, 4
		mov ecx, arr_index
		cmp ecx, ebx			
		jle read_value									;	if esi <= arr_sizeof, jump to read_value
	end_:
		mov esp,ebp
		pop ebp
		ret	
		readInput ENDP
		END