.386
.model flat, stdcall

arr_size EQU SDWORD PTR[ebp + 8]
arr EQU [ebp + 12]
arr_sizeof EQU SDWORD PTR[ebp + 16]
arr_index EQU SDWORD PTR[ebp - 4]

INCLUDELIB Irvine32.lib
WriteInt PROTO
WriteChar PROTO
Crlf PROTO
.data
	output DWORD " ",0	
.code
	printArray PROC
	push ebp
	mov ebp, esp										;	[ebp + 8] == arr_size , [ebp + 12] == arr 
	sub esp, 4											;	[ebp - 4] == arr_index , [ebp - 8] == arr_sizeof
	mov arr_index, 0									;	set arr_index = 0
	mov esi, arr
	mov eax, arr_size
	mov ecx, 4
	imul ecx
	mov arr_sizeof, eax									
	sub arr_sizeof, 4									;	arr_size : 0 ~ arr_size - 1 => arr_sizeof = arr_size*4 - 1
	print_:
		mov eax, arr_index
		cmp eax, arr_sizeof								;	cmp arr_index, arr_sizeof	
		jg print_newline								;	if arr_index > arr_sizeof, jmp to print_newline
		mov eax, arr_index
		mov eax, [esi + eax]
		push eax
		CALL WriteInt									;	print [ esi ]
		push output
		pop eax
		CALL WriteChar									;	print " "
		pop eax
		add arr_index, 4
		jmp print_
	print_newline:
		CALL Crlf										;	print "\n"
		mov esp,ebp
		pop ebp
		ret	
		printArray ENDP
		END