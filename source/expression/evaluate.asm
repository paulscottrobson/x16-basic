; *****************************************************************************
; *****************************************************************************
;
;		Name :		evaluate.asm
;		Purpose :	Basic Expression Evaluation
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		7th February 2020
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;	  Evaluate an expression starting from empty stack with lowest precedence
;
; *****************************************************************************

EvaluateExpression:
		ldx 	#0 							; reset the evaluation stack pointer in X

; *****************************************************************************
;
;				Evaluate lowest precedence, current stack level
;
; *****************************************************************************

EvaluateExpressionAtX:
		lda 	#$10 						; this is the lowest precedence.

; *****************************************************************************
;
;				Evaluate at precedence A, current stack level
;
; *****************************************************************************

EvaluateExpressionAtXPrecA:		
		pha 								; save lowest stack level.

		lda 	(codePtr),y 				; get the first term.
		bmi 	_EXAKeywordData 			; is it keyword, or data.
		cmp 	#$60 						; is it a variable
		bcc 	_EXAVariable
		;
		iny 								; skip over the short constant
		and 	#$1F 						; short constant $00-$1F
		sta 	xsIntLow,x 					; and put as an integer
		stz 	xsIntHigh,x
		stz 	xsStatus,x 					; integer, number, not a reference.
		;
		;		Come here when we have a term. Current precedence on stack
		;
_EXAHaveTerm:				
		pla 	 							; restore current precedence and save in zTemp1
		sta 	zTemp1
		lda 	(codePtr),y 				; is it followed by a binary operation.
		phx
		tax
		lda 	TokenControlByteTable-$80,x ; get the control byte.
		plx
		cmp 	#$20 						; must be $10-$17 (or possibly $00, will be < precedence)
		bcs 	_EXAExit
		cmp 	zTemp1 						; check against current precedence.
		beq 	_EXAExit 
		bcs		_EXABinaryOp 				; if >, do a binary operation.
_EXAExit:
		rts 								; exit expression evaluation.		
		;
		;		Handle a binary operation.	
		;
_EXABinaryOp:
		sta 	zTemp1+1 					; save operator.
		lda 	zTemp1 						; get and save current precedence
		pha
		;
		lda 	(codePtr),y 				; push binary operator on stack
		pha
		iny 								; and skip over it.
		;
		inx 								; calculate the RHS in the next slot up.
		lda 	zTemp1+1 					; at operator precedence level.
		jsr 	EvaluateExpressionAtXPrecA
		dex
		;
		pla 								; get binary operator.
		phx 								; save stack depth.
		asl 	a 							; double binary operator and put into X, loses MSB
		tax
		lda 	TokenVectors,x 				; get address => zTemp2
		sta 	zTemp2
		lda 	TokenVectors+1,x
		sta 	zTemp2+1
		plx 								; restore stack depth.
		jsr 	_EXACallZTemp2 				; call the routine	
		bra 	_EXAHaveTerm 				; and loop round again.

_EXAVariable:
		.byte 	$FF

_EXAKeywordData:
		.byte 	$FF

_EXACallZTemp2:								; so we can jsr (zTemp2)
		jmp 	(zTemp2)