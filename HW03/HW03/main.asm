.386
.model flat,stdcall
.stack 4096
includelib Irvine32.lib

ReadInt PROTO
WriteInt PROTO
Crlf PROTO
gcd PROTO, a:DWORD,b:DWORD


.data
	former DWORD 0
	latter DWORD 0
	g DWORD 0								; gcd
.code
;--------------------start main----------------------------
	main PROC
	start:
		CALL ReadInt	
		cmp eax,0			
		jl end_								;	if eax < 0, jump to end_
		mov former,eax						;	former = eax( first_input )
		CALL ReadInt
		mov latter, eax						;	latter = eax( second_input )
		INVOKE gcd, former, latter
		Call WriteInt						;	print gcd
	LCM:
		mov g, eax							;	g = retunrn value( gcd )
		mov edx, 0
		mov eax, former
		imul latter							;	eax = eax( former ) * latter 
		mov edx, 0		
		div g								;	eax = eax / g( retunrn value ) 
		Call WriteInt						;	print LCM
		Call Crlf							
		jmp start
	end_:	
	main ENDP
;------------------end main----------------------------------

;------------------start gcd---------------------------------
	gcd PROC, a:DWORD, b:DWORD
		L1:
			mov eax, b						
			cmp a, eax						
			jge divide						;	if	a >= b , jump to divid
			mov ebx, a						;	if	a < b
			mov b, ebx
			mov a, eax						;	let a > b
		divide:
			mov edx, 0						;	initial edx
			mov eax , a
			idiv b							;	( edx:eax ) / b
			cmp edx, 0						
			je print_						;	if	edx( remainder ) == 0, jump to print
			mov a, edx						;	a = remainder 
			jmp L1							;	back to L1
		print_:	
			mov eax, b
			ret
		gcd ENDP
END main