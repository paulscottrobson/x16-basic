; *****************************************************************************
; *****************************************************************************
;
;		Name :		exprutils.asm
;		Purpose :	Expression Utilities
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		8th February 2020
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;					Dereference either 2 stack references, or 1
;
;	Used when stack contains a reference (normally a variable) and needs its
;	value to calculate an expression.
;
; *****************************************************************************

DeReferenceBinary:
		inx
		jsr 	DeReferenceUnary
		dex
DeReferenceUnary:
		lda 	xsStatus,x 					; the reference flag is in bit 0
		ror 	a 							; shift into carry.
		bcc 	_DRNotReference 			; if clear, it's already a reference.
		asl 	a 							; get back, but with bit 0 cleared
		sta 	xsStatus,x 
		;
		lda 	xsAddrLow,x 				; put the address to dereference into zTemp1
		sta 	zTemp1
		lda 	xsAddrHigh,x
		sta 	zTemp1+1
		;
		phy 								; save position in code
		lda 	(zTemp1) 					; dereference the first two bytes - this will be
		sta 	xsIntLow,x 					; for float, int and string, and will go in these
		ldy 	#1 							; which are also the address, and mantissa3 & 2
		lda 	(zTemp1),y
		sta 	xsIntHigh,x
		;
		lda 	xsStatus,x 					; check if it's a float (bit 7)
		bpl 	_DRNotFloat 				; if not, we are complete
		;
		iny 								; if float, copy all five bytes of the floating point
		lda 	(zTemp1),y 					; number into the stack.
		sta 	xsMantissa1,x
		iny
		lda 	(zTemp1),y
		sta 	xsMantissa0,x
		iny
		lda 	(zTemp1),y
		sta 	xsExponent,x
		;
_DRNotFloat:
		ply 								; restore code position.
_DRNotReference:
		rts		

; *****************************************************************************
;
;		Check the top 2 stack values are numbers. Return CS if a float is 
;		required (e.g. if one of them is a floating point number), CC if
;		can be done using integers.
;
; *****************************************************************************

NumberTypeCheck:
		lda 	xsStatus,x 					; bit 7 set if either float, bit 6 set if either string.
		ora 	xsStatus+1,x
		asl 	a 							; carry set if either float, bit 7 set if either string
		bmi 	_NTCError 					; so fail if string, we want int
		rts 						
_NTCError:
		berror	"Number Operation"		
		