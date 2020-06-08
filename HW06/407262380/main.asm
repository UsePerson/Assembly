.386
.model flat, stdcall
.stack 4096
option casemap:none

includelib irvine32.lib
includelib legacy_stdio_definitions.lib
includelib ucrt.lib
printf PROTO C, outform:PTR BYTE, args:VARARG
scanf PROTO C, inform:PTR BYTE, args:VARARG

distance PROTO
heron PROTO
edge PROTO

Pont2D STRUCT
	x REAL8 0.0
	y REAL8 0.0
Pont2D ENDS

Triangle STRUCT
	i REAL8 0.0
	j REAL8 0.0
	k REAL8 0.0
	area REAL8 0.0
Triangle ENDS

.data
	input1 BYTE "%lf","%lf","%lf","%lf","%lf","%lf",0
	output1 BYTE "%.3lf",0dh,0ah,0
	output_tri BYTE "%.3lf ","%.3lf ","%.3lf",0dh,0ah,0
	tri Triangle <>
	vertex1 Pont2D <>
	vertex2 Pont2D <>
	vertex3 Pont2D <>
	temp1 REAL8 0.0
	temp2 REAL8 0.0
	max REAL8 0.0 
.code 
main PROC
	
L1:
	finit
	fld1
	fld1
	fadd
	fstp tri.area
	invoke scanf, addr input1, addr vertex1.x, addr vertex1.y, addr vertex2.x, addr vertex2.y, addr vertex3.x, addr  vertex3.y
	cmp eax, -1
	je end_
	invoke distance
	invoke heron
	invoke edge
	invoke printf, addr output1, tri.area
	invoke printf, addr output_tri, tri.i, tri.j, tri.k
	jmp L1
end_:
	ret
main ENDP

distance PROC
;------------------------vertex1.x	vertex2.x	vertex1.y	vertex2.y--------------------
	fld vertex2.x				;	ST(0) == vertex2.x
	fld vertex1.x				;	ST(0) == vertex1.x  ST(1) == vertex2.x
	fcom
	fnstsw ax
	sahf
	jae x12_dis					;	if ST(0) >= ST(1), jump to x12_dis	
	fstp temp1					
	fstp temp2
	fld temp1
	fld temp2
x12_dis:
	fsub						;	ST(0) == ( vertex1.x - vertex2.x) 
	fmul ST(0), ST(0)			;	ST(0) == ( vertex1.x - vertex2.x) * ( vertex1.x - vertex2.x) 
	fld vertex2.y				;	ST(1) == ( vertex1.x - vertex2.x) * ( vertex1.x - vertex2.x)  ST(0) == vertex2.y
	fld vertex1.y				;	ST(2) == ( vertex1.x - vertex2.x) * ( vertex1.x - vertex2.x)  ST(1) == vertex2.y ST(0) == vertex1.y
	fcom
	fnstsw ax
	sahf
	jae y12_dis					;	if ST(0) >= ST(1), jump to y12_dis
	fstp temp1					
	fstp temp2
	fld temp1
	fld temp2
y12_dis:
	fsub						;	ST(1) == (vertex1.x - vertex2.x) * (vertex1.x - vertex2.x)  ST(0) == (vertex1.y - vertex2.y)     
	fmul ST(0), ST(0)			;	ST(1) == (vertex1.x - vertex2.x) * (vertex1.x - vertex2.x)  ST(0) == (vertex1.y - vertex2.y) * (vertex1.y - vertex2.y) 
	fadd ST(0), ST(1)
	fsqrt
	fstp tri.i
;------------------------vertex1.x	vertex3.x	vertex1.y	vertex3.y--------------------
	fld vertex3.x				;	ST(0) == vertex3.x
	fld vertex1.x				;	ST(0) == vertex1.x  ST(1) == vertex3.x
	fcom
	fnstsw ax
	sahf
	jae x13_dis					;	if ST(0) >= ST(1), jump to x13_dis		
	fstp temp1					
	fstp temp2
	fld temp1
	fld temp2
x13_dis:
	fsub						;	ST(0) == ( vertex1.x - vertex3.x) 
	fmul ST(0), ST(0)			;	ST(0) == ( vertex1.x - vertex3.x) * ( vertex1.x - vertex3.x) 
	fld vertex3.y				;	ST(1) == ( vertex1.x - vertex3.x) * ( vertex1.x - vertex3.x)  ST(0) == vertex3.y
	fld vertex1.y				;	ST(2) == ( vertex1.x - vertex3.x) * ( vertex1.x - vertex3.x)  ST(1) == vertex3.y ST(0) == vertex1.y
	fcom
	fnstsw ax
	sahf
	jae y13_dis					;	if ST(0) >= ST(1), jump to y13_dis
	fstp temp1					
	fstp temp2
	fld temp1
	fld temp2
y13_dis:
	fsub						;	ST(1) == (vertex1.x - vertex3.x) * (vertex1.x - vertex3.x)  ST(0) == (vertex1.y - vertex3.y)     
	fmul ST(0), ST(0)			;	ST(1) == (vertex1.x - vertex3.x) * (vertex1.x - vertex3.x)  ST(0) == (vertex1.y - vertex3.y) * (vertex1.y - vertex3.y) 
	fadd ST(0), ST(1)
	fsqrt
	fstp tri.j
;------------------------vertex2.x	vertex3.x	vertex2.y	vertex3.y--------------------
	fld vertex3.x				;	ST(0) == vertex3.x
	fld vertex2.x				;	ST(0) == vertex2.x  ST(1) == vertex3.x
	fcom
	fnstsw ax
	sahf
	jae x23_dis					;	if ST(0) >= ST(1), jump to x23_dis	
	fstp temp1					
	fstp temp2
	fld temp1
	fld temp2
x23_dis:
	fsub						;	ST(0) == ( vertex2.x - vertex3.x) 
	fmul ST(0), ST(0)			;	ST(0) == ( vertex2.x - vertex3.x) * ( vertex2.x - vertex3.x) 
	fld vertex3.y				;	ST(1) == ( vertex2.x - vertex3.x) * ( vertex2.x - vertex3.x)  ST(0) == vertex3.y
	fld vertex2.y				;	ST(2) == ( vertex2.x - vertex3.x) * ( vertex2.x - vertex3.x)  ST(1) == vertex3.y ST(0) == vertex2.y
	fcom
	fnstsw ax
	sahf
	jae y23_dis					;	if ST(0) >= ST(1), jump to y23_dis
	fstp temp1					
	fstp temp2
	fld temp1
	fld temp2
y23_dis:
	fsub						;	ST(1) == (vertex2.x - vertex3.x) * (vertex2.x - vertex3.x)  ST(0) == (vertex2.y - vertex3.y)     
	fmul ST(0), ST(0)			;	ST(1) == (vertex2.x - vertex3.x) * (vertex2.x - vertex3.x)  ST(0) == (vertex2.y - vertex3.y) * (vertex2.y - vertex3.y) 		 
	fadd ST(0), ST(1)
	fsqrt
	fstp tri.k
	ret
distance ENDP
;------------------------distance	end	-------------------------------------------------
;------------------------heron	    start------------------------------------------------
heron PROC
	fld tri.i					;	ST(0) == tri.i
	fadd tri.j					;	ST(0) == tri.i + tri.j
	fadd tri.k					;	ST(0) == tri.i + tri.j + tri.k
	fdiv tri.area				;	ST(0) == ( tri.i + tri.j + tri.k ) / 2
	fst tri.area				;	tri.area == ST(0)
	fsub tri.i					;	ST(0) == tri.area - tri.i
	fld tri.area				;	ST(1) == tri.area - tri.i  ST(0) == tri.area
	fsub tri.j					;	ST(1) == tri.area - tri.i  ST(0) == tri.area - tri.j	
	fmul						;	ST(0) == ( tri.area - tri.i ) * ( tri.area - tri.j )
	fld tri.area				;	ST(1) == ( tri.area - tri.i ) * ( tri.area - tri.j )  ST(0) == tri.area
	fsub tri.k					;	ST(1) == ( tri.area - tri.i ) * ( tri.area - tri.j )  ST(0) == tri.area - tri.k  
	fmul						;	ST(0) == ( tri.area - tri.i ) * ( tri.area - tri.j ) * ( tri.area - tri.k   )
	fmul tri.area				;	ST(0) == ( tri.area - tri.i ) * ( tri.area - tri.j ) * ( tri.area - tri.k   ) * tri.area
	fsqrt		
	fstp tri.area
	ret
heron ENDP

edge PROC			;	tri.i   >   tri.j   >   tri.k
	fld tri.j					;	ST(0) == tri.j
	fld tri.i					;	ST(1) == tri.j  ST(0) == tri.i
	fcom
	fnstsw ax
	sahf
	jae L2						;	if ST(0) >=  ST(1),jump to L2
	fstp tri.j
	fstp tri.i
	fld tri.j
	fld tri.i
L2:
	fld tri.k					;	ST(2) == tri.j  ST(1) == tri.i  ST(0) == tri.k
	fcom
	fnstsw ax
	sahf
	jae L3						;	if ST(0) >= ST(1), jump to L3
	fstp tri.k
	fstp tri.i
	fld tri.k
	fld tri.i
L3:
	fstp tri.i					;	tri.i is biggest
	fcom 
	fnstsw ax
	sahf
	jae L4						;	if ST(0) >= ST(1), jump to L4
	fstp tri.k
	fstp tri.j
	fld tri.k
	fld tri.j
L4:
	fstp tri.j
	fstp tri.k					;	tri.k is smallest
	ret
edge ENDP
END main


