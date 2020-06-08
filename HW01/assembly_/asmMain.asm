INCLUDE Irvine32.inc
includelib legacy_stdio_definitions.lib

isPrime PROTO C,		
	factor:DWORD

.data
input BYTE "%d",0				;	scanf
n DWORD 0						;	scanf 
output BYTE "%d",0dh,0ah,0		;	printf

.code
;------------start asmMain------------------- 
asmMain PROC C
;--------read input using scanf function-----------
INVOKE scanf, ADDR input,ADDR n		
;-------------for loop---------------------------
mov ebx, 1
L1:
	cmp ebx, n					;compare factor and input
	jge end_loop				;when factor >= input end loop
	inc ebx						;factor + 1
	INVOKE isPrime, ebx			; call isPrime
	cmp eax, 1					;compare return value and 1
	je prime					;	if isPrime's return value==1, jump to prime
	jmp L1						;	if factor is not prime, jump to L1 
;-----------if facter is a prime -----------------------
prime:
	INVOKE printf, ADDR output,ebx	;print prime number
	jmp L1							;jump to L1

end_loop:
		ret
asmMain ENDP

END