; *****************************************************************************
; *****************************************************************************
;
;		Name :		tostring.asm
;		Purpose :	Convert integer to string
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		8th February 2020
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;						Print YA using external interface
;
; *****************************************************************************

PrintYA:
		ldx 	#0 							; put on stack.
		sta 	xsIntLow,x
		tya
		sta 	xsIntHigh,x 
		stz 	xsStatus,x 					; tell system it is an integer.
		lda 	#10 						; base
		jsr 	ConvertIntegerUnsigned 		; unsigned integer conversion.
		jsr 	EXPrintString 				; print the result
		rts

; *****************************************************************************
;
;		Convert stack value to string in textBuffer, signed/unsigned.
;		Base A.
;
; *****************************************************************************

ConvertIntegerUnsigned:
		phx
		pha 								; save base on stack
		stz 	convertPtr 					; reset conversion position
		bra 	CIMain 	

ConvertIntegerSigned:
		phx
		pha 								; save base on stack.
		stz 	convertPtr 					; reset conversion position
		lda 	xsIntHigh,x 				; is it -ve ?
		bpl 	CIMain
		jsr 	IntegerNegate 				; make it positive
		lda 	#"-" 						; write a - sign out.
		jsr 	CIWriteCharacter
CIMain:		
		ply									; get base back
		lda 	#$FF 						; push marker on stack.
		pha
		phy  								; push base back.
_CILoop:
		pla 								; get and save base.
		pha
		sta 	xsIntLow+1,x 				; put it in the next stack level and set type
		stz 	xsIntHigh+1,x
		stz 	xsStatus,x
		jsr 	UnsignedIntegerDivide 		; divide.
		;
		ply 								; get base into Y
		lda 	zTemp1 						; push the remainder on the stack.
		pha
		phy 								; push the base back.
		lda 	xsIntLow,x 					; complete
		ora 	xsIntHigh,x
		bne 	_CILoop
		pla 								; throw the base
;		
_CIUnpack:
		pla 								; pull off stack so in the right order
		bmi 	_CIExit		
		cmp 	#10 						; convert to ASCII
		bcc 	_CINotAlpha
		clc
		adc 	#7
_CINotAlpha:
		clc
		adc 	#48		
		jsr 	CIWriteCharacter 			; keep going till reach the marker
		bra 	_CIUnpack
;
_CIExit:
		plx
		lda 	#textBuffer & $FF 			; return with pointer in YA
		ldy 	#textBuffer >> 8
		rts

CIWriteCharacter:
		phx
		ldx		convertPtr
		sta 	textBuffer,x
		stz 	textBuffer+1,x
		plx
		inc 	convertPtr
		rts
