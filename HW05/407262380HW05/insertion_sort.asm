.386
.model flat, stdcall

arr_size EQU SDWORD PTR [ebp + 8]
arr EQU [ebp + 12]
i EQU SDWORD PTR [ebp - 4]
j EQU SDWORD PTR [ebp - 8]
temp EQU SDWORD PTR [ebp - 12]

.code
	insertion_sort PROC						;	[ebp + 8] == arr_size    [ebp + 12] == arr
	push ebp
	mov ebp, esp
	sub esp, 12								;	[ebp - 4] == i   [ebp - 8] == j   [ebp - 12] == temp
	mov i, 1								;	i = 1
	mov esi, arr							;	esi =  arr
	L1:
		mov eax, i							;	eax = i
		cmp eax, arr_size					;	cmp eax ( i ), arr_size 
		jge end_							;	if eax ( i ) >= arr_size, jump to end_ 
		sub eax, 1												
		mov j, eax							;	j = i-1
		mov eax, i
		mov ecx, 4
		imul ecx
		mov eax, [esi + eax]				;	eax = arr[ i ]
		mov temp, eax						;	temp = arr[ i ]
	L2:
		mov eax, j							;	eax = j
		mov ecx, 4
		imul ecx
		mov ebx, [esi + eax]				
		cmp temp, ebx						;	cmp temp, arr[ j ]
		jge L3								;	if temp >= arr[ j ], jmp to L3	
		cmp j, 0							;	cmp j,0
		jl L3								;	if j < 0, jmp to L3
		mov eax, j							;	eax = j+1
		add eax, 1
		mov ecx, 4												
		imul ecx
		mov [esi + eax], ebx				;	arr[j + 1] = arr[ j ]
		dec j								;	j --
		jmp L2
	L3:
		mov eax, j							
		add eax, 1							;	eax = j+1
		mov ecx, 4												
		imul ecx
		mov ebx, temp
		mov [esi +eax], ebx					;	arr[j+1] = x ( arr [ i ] )
		inc i								;	i++
		jmp L1
	end_:
		mov esp,ebp
		pop ebp
		ret									
	insertion_sort ENDP
	END