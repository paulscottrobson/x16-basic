; *****************************************************************************
; *****************************************************************************
;
;		Name :		unary.asm
;		Purpose :	Simple Unary Functions
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		8th February 2020
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;			Dummy % and $ unary functions which are markers for the display
;			base (binary and hexadecimal)
;
; *****************************************************************************

Dummy_Binary:	;; %
Dummy_Hex: 		;; $
		jsr 	EvaluateTermAtX
		rts

; *****************************************************************************
;
;			Parenthesis is implemented as a unary function. Which it sort
;			of is ;-)
;
; *****************************************************************************

Parenthesis:	;; (
		jsr 	EvaluateExpressionAtX 		; parenthesised expression
		jsr 	SyntaxCheckRightBracket 	; check followed by )
		rts

; *****************************************************************************
;
;									Absolute value
;
; *****************************************************************************

AbsoluteValue: 	;; abs(
		getparam_n 	AVFloat 				; get the value.
		jsr 	CheckIntegerNegate 			; use absolute value in divide
		jsr 	SyntaxCheckRightBracket
		rts		
;		
AVFloat:									; FP version of ABS()
		jsr 	FPAbs
		jsr 	SyntaxCheckRightBracket
		rts		

; *****************************************************************************
;
;									Sign of value
;
; *****************************************************************************

SignValue: 	;; sgn(
		getparam_n 	SVFloat 				; get the value.
		jsr 	SyntaxCheckRightBracket
		lda 	xsIntHigh,x 				; Check zero
		ora 	xsIntLow,x
		beq 	_SVSetLH
		asl 	a 							; msb into carry
		bcc 	_SVGreater0 				; if CC then it's positive and non zero
		lda 	#$FF 						; -ve so return -1
_SVSetLH: 									; copy A to LowHigh
		sta 	xsIntLow,x
		sta 	xsIntHigh,x		
		rts		
_SVGreater0: 								; come here to return 1.
		lda 	#1
		sta 	xsIntLow,x
		stz 	xsIntHigh,x		
		rts
;		
SVFloat:									; FP version of SGN()
		jsr 	FPSgn
		jsr 	SyntaxCheckRightBracket
		rts		

; *****************************************************************************
;
;									String length
;
; *****************************************************************************

StringLength: ;; len(
		getparam_s 							; get string parameter
		jsr 	SyntaxCheckRightBracket
		lda 	xsAddrLow,x 				; put address of string into zTemp1
		sta 	zTemp1
		lda 	xsAddrHigh,x
		sta 	zTemp1+1
		lda 	(zTemp1)					; get the length (strings are len prefixed)
		sta 	xsIntLow,x 					; and return it
		stz 	xsIntHigh,x
		stz 	xsStatus,x
		rts

