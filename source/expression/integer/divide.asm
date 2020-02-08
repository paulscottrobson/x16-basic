; *****************************************************************************
; *****************************************************************************
;
;		Name :		divide.asm
;		Purpose :	16x16 Divide and Modulus
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		8th February 2020
;
; *****************************************************************************
; *****************************************************************************

Divide16x16: 	;; / 
		typederef 	FPDivide
		jsr 	IntegerDivide
		rts

Modulus16x16:	;; mod
		typederef 	FPModulus
		jsr 	IntegerDivide
		lda 	zTemp1
		sta 	xsIntLow,x
		lda 	zTemp1+1
		sta 	xsIntHigh,x
		rts
;
;		This is used for integer -> string conversion.
;
UnsignedIntegerDivide:		
		stz 	SignCount 					; Count of signs.
		bra 	DivideMain

;
;		Divide 1st by 2nd. Note this *must* put the remainder in zTemp1. toString uses it.
;
IntegerDivide:
		lda 	xsIntLow+1,x 				; check for division by zero.
		ora 	xsIntHigh+1,x
		bne 	_BFDOkay
		berror	"Division by Zero"
		;
		;		Reset the interim values
		;
_BFDOkay:
		stz 	SignCount 					; Count of signs.
		;
		;		Remove and count signs from the integers.
		;
;		jsr 	CheckIntegerNegate 			; negate 1st (and bump sign count)
;		inx
;		jsr 	CheckIntegerNegate 			; negate 2nd (and bump sign count)
;		dex
DivideMain:
		stz 	zTemp1 						; Q/Dividend/Left in +0
		stz 	zTemp1+1 					; M/Divisor/Right in +1
		phy 								; Y is the counter, save position
		;
		;		Main division loop
		;
		ldy 	#16 						; 16 iterations of the loop.
_BFDLoop:
		asl 	xsIntLow,x 					; shift AQ left.
		rol 	xsIntHigh,x
		rol 	zTemp1
		rol 	zTemp1+1
		;
		sec
		lda 	zTemp1+0 					; Calculate A-M on stack.
		sbc 	xsIntLow+1,x
		pha
		lda 	zTemp1+1
		sbc 	xsIntHigh+1,x
		bcc 	_BFDNoAdd
		;
		sta 	zTemp1+1
		pla
		sta 	zTemp1+0
		;
		lda 	xsIntLow,x 					; set Q bit 1.
		ora 	#1
		sta 	xsIntLow,x
		bra 	_BFDNext
_BFDNoAdd:
		pla 								; Throw away the intermediate calculations
_BFDNext:									; do 32 times.
		dey
		bne 	_BFDLoop
		ply 								; restore Y
		;
		lsr 	SignCount 					; if sign count odd,
		bcc 	_BFDUnsigned 				; then the result is signed
		jsr		IntegerNegate 				; negate the result
_BFDUnsigned:		
		rts

; *******************************************************************************************
;
;				Check / Negate integer 2nd on stack, counting negations
;
; *******************************************************************************************

CheckIntegerNegate:
		lda 	xsIntHigh,x 				; is it -ve = MSB set ?
		bmi 	IntegerNegate 				; if so negate it
		rts
IntegerNegate:
		inc 	SignCount 					; bump the count of signs
		sec 								; negate
		lda 	#0
		sbc 	xsIntLow,x
		sta 	xsIntLow,x
		lda 	#0
		sbc 	xsIntHigh,x
		sta 	xsIntHigh,x
		rts

