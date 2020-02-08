; *****************************************************************************
; *****************************************************************************
;
;		Name :		multiply.asm
;		Purpose :	16x16 Multiply
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		8th February 2020
;
; *****************************************************************************
; *****************************************************************************

Multiply16x16:	;; 	* 
		typederef 	FPMultiply
		lda 	xsIntLow,x 					; 1st value to zTemp1
		sta 	zTemp2
		lda		xsIntHigh,x
		sta 	zTemp2+1
		stz 	xsIntLow,x 					; zero 1st on stack
		stz 	xsIntHigh,x
_MultLoop:	
		lsr 	zTemp2+1 					; ror zTemp2 into C
		ror 	zTemp2
		bcc 	_MultNoAdd
		;
		clc 								; add 2nd to 1st.
		lda 	xsIntLow,x
		adc 	xsIntLow+1,x
		sta 	xsIntLow,x
		lda 	xsIntHigh,x
		adc 	xsIntHigh+1,x
		sta 	xsIntHigh,x
		;
_MultNoAdd:
		asl 	xsIntLow+1,x 				; shift 2nd left
		rol 	xsIntHigh+1,x
		lda 	zTemp2	 					; until multiplier is zero
		ora 	zTemp2+1
		bne 	_MultLoop
		rts
