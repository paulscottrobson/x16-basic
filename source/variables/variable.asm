; *****************************************************************************
; *****************************************************************************
;
;		Name :		variable.asm
;		Purpose :	Variable look up
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		8th February 2020
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;		Put a reference to the variable/array at (codePtr),y at stack 
;		position X.
;
;		Very simple implementation which supports 26 variables A-Z only
;		all integer.
;
; *****************************************************************************

VariableLookup:
		cmp 	#26 						; multi character variables.
		bcs 	_VLError
		asl 	a 							; multiply by 5, do not move for float
		asl 	a
		adc 	(codePtr),y
		iny 								; skip over variable token
		sta 	xsAddrLow,x
		lda 	#variables >> 8
		sta 	xsAddrHigh,x
		lda 	#$01 						; integer reference.
		sta 	xsStatus,x
		rts
_VLError:
		berror	"Bad Variable"
