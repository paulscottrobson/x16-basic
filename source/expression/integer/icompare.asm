; *****************************************************************************
; *****************************************************************************
;
;		Name :		icompare.asm
;		Purpose :	Comparisons, and integer implementations
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		8th February 2020
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;								Equality Tests
;
; *****************************************************************************

Compare_Equals: 	;; =
		clc 
		bra 	CEMain
Compare_NotEquals: 	;; <>
		sec
CEMain:
		php 								; carry set flips the result
		jsr 	EqualityComparison
CEWriteResult:		
		plp  								; get the flip flag
		bcc 	_CENoFlip
		eor 	#$FF 						; if so invert the result
_CENoFlip:
		sta 	xsIntLow,x 					; write it out
		sta 	xsIntHigh,x
		stz 	xsStatus,x 					; its an integer
		rts

; *****************************************************************************
;
;								Normal Magnitude Tests
;
; *****************************************************************************

Compare_GreaterEquals: 	;; >=
		clc 
		bra 	GEMain
Compare_Less: 	;; <
		sec
GEMain:
		php 								; carry set flips the result
		jsr 	MagnitudeComparison
		bra 	CEWriteResult

; *****************************************************************************
;
;								Flipped Magnitude Tests
;
; *****************************************************************************

Compare_LessEquals: ;; <=
		clc 
		bra 	LEMain
Compare_Greater: 	;; >
		sec
LEMain:
		php 								; carry set flips the result
		jsr 	SwapStackTop 				; swap the top two over. Not that efficient, probably doesn't matter
		jsr 	MagnitudeComparison 		; so the comparison is backwards.
		bra 	CEWriteResult

; *****************************************************************************
;
;		Type equality test - A = $FF (equals) $00 (not equals)
;
; *****************************************************************************

EqualityComparison:
		alltypederef FPEquality,SyntaxError					
		lda 	xsIntLow,x
		cmp 	xsIntLow+1,x
		bne 	_NECFail
		lda 	xsIntHigh,x
		cmp 	xsIntHigh+1,x
		bne 	_NECFail
		lda 	#$FF
		rts
_NECFail:
		lda 	#$00
		rts

; *****************************************************************************
;
;			Type magnitude test - A = $FF (greater/equals) $00 (less)
;
; *****************************************************************************

MagnitudeComparison:
		alltypederef FPMagnitude,SyntaxError					
		lda 	xsIntLow,x
		cmp 	xsIntLow+1,x
		lda 	xsIntHigh,x
		sbc 	xsIntHigh+1,x
		bvc 	_MCNoOverflow
		eor 	#$80
_MCNoOverflow:
		bmi 	_NECFail		
		lda 	#$FF
		rts
_NECFail:
		lda 	#$00
		rts

; *****************************************************************************
;
;						Swap the top two stack elements over
;
; *****************************************************************************

SwapStackTop:
		phx 	
		phy
		ldy 	#6 							; swap count
_SSTLoop:
		lda 	xsStatus,x 					; the first stack entry, flip it over.
		pha
		lda 	xsStatus+1,x
		sta 	xsStatus,x
		pla
		sta 	xsStatus+1,x		
		;
		txa 								; go forward to the next stack chunk.
		clc
		adc 	#stackSize
		tax
		;
		dey 								; do it for the whole of this stack
		bne 	_SSTLoop
		ply
		plx
		rts