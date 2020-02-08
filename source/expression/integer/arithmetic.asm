; *****************************************************************************
; *****************************************************************************
;
;		Name :		arithmetic.asm
;		Purpose :	Simple Integer Arithmetic
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		8th February 2020
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;									 Add
;
; *****************************************************************************

BinaryAdd:	;; 	+
		alltypederef FPAdd,SyntaxError
		clc
		lda 	xsIntLow,x
		adc 	xsIntLow+1,x
		sta 	xsIntLow,x
		lda 	xsIntHigh,x
		adc 	xsIntHigh+1,x
		sta 	xsIntHigh,x
		rts

; *****************************************************************************
;
;								    Subtract
;
; *****************************************************************************

BinarySub:	;; 	-
		typederef 	FPSub
		sec
		lda 	xsIntLow,x
		sbc 	xsIntLow+1,x
		sta 	xsIntLow,x
		lda 	xsIntHigh,x
		sbc 	xsIntHigh+1,x
		sta 	xsIntHigh,x
		rts

; *****************************************************************************
;
;								   Binary And
;
; *****************************************************************************

BinaryAnd:	;; 	and
		intderef
		lda 	xsIntLow,x
		and 	xsIntLow+1,x
		sta 	xsIntLow,x
		lda 	xsIntHigh,x
		and 	xsIntHigh+1,x
		sta 	xsIntHigh,x
		rts

; *****************************************************************************
;
;								   Binary Or
;
; *****************************************************************************

BinaryOr:	;; 	or
		intderef
		lda 	xsIntLow,x
		ora 	xsIntLow+1,x
		sta 	xsIntLow,x
		lda 	xsIntHigh,x
		ora 	xsIntHigh+1,x
		sta 	xsIntHigh,x
		rts

; *****************************************************************************
;
;								   Binary And
;
; *****************************************************************************

BinaryXor:	;; 	xor
		intderef
		lda 	xsIntLow,x
		eor 	xsIntLow+1,x
		sta 	xsIntLow,x
		lda 	xsIntHigh,x
		eor 	xsIntHigh+1,x
		sta 	xsIntHigh,x
		rts		