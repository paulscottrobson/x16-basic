; *****************************************************************************
; *****************************************************************************
;
;		Name :		random.asm
;		Purpose :	Random functions
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		8th February 2020
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;								Random number 16 bit
;
; *****************************************************************************

RandomNumber: 	;; random(
		jsr 	AdvanceRandomSeed 			; bytes seperately as zero problem.
		sta 	xsIntLow,x
		jsr 	AdvanceRandomSeed
		sta 	xsIntHigh,x
		stz 	xsStatus,x
		jsr 	SyntaxCheckRightBracket 	; check followed by )
		rts

; *****************************************************************************
;
;						   LFSR Random Number Generator
;
; *****************************************************************************

AdvanceRandomSeed:
		lda 	randomSeed
		ora 	randomSeed+1
		bne 	_RH_NoInit
		lda 	#$7C
		sta 	randomSeed
		lda 	#$A1
		sta 	randomSeed+1
_RH_NoInit:
		lda 	randomSeed
        lsr		a
        rol 	randomSeed+1  
        bcc 	_RH_NoEor
        eor 	#$B4 
_RH_NoEor: 
        sta 	randomSeed
        eor 	randomSeed+1  
        rts
