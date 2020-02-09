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
		cmp 	#$40 						; is it a variable (0-3F) 
		bcc 	_EXAVariable
		;
		iny 								; skip over the short constant
		and 	#$3F 						; short constant $00-$3F
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
		;
		;		Variable reference comes here.
		;
_EXAVariable:
		jsr 	VariableLookup 				; look up the variable value perhaps creating it.
		bra 	_EXAHaveTerm 				; and carry on with the expression
		;
		;		Token / Reference where term is expected here.
		;
_EXAKeywordData:
		cmp 	#TOK_MINUS 					; special case as - is unary and binary operator.
		bne 	_EXANotNegate
		iny
		jsr 	EvaluateTermAtX 			; the term
		jsr 	IntegerNegate 				; negate it
		bra 	_EXAHaveTerm 				; and loop back.
		;
_EXANotNegate:
		cmp 	#$F8 						; $80-$F8 are unary functions
		bcc 	_EXAUnaryFunction
		cmp 	#TOK_STRING_OBJ 			; $FB is a string.
		beq 	_EXAString
		;
		;		Now handle $FE (byte constant) $FF (int constant)
		;
		stz 	xsStatus,x 					; it is now either $FE (short int) or $FF (long int)
		stz 	xsIntHigh,x
		pha 								; save identifier
		iny 								; do the low byte
		lda 	(codePtr),y
		sta 	xsIntLow,x
		iny
		pla 								; get identifier
		cmp 	#TOK_BYTE_OBJ  				; if short then done.
		beq 	_EXAHaveTerm
		cmp 	#TOK_WORD_OBJ 				; should be $FF
		bne 	_EXACrash
		lda 	(codePtr),y 				; copy high byte
		sta 	xsIntHigh,x
		iny
		bra 	_EXAHaveTerm
_EXACrash:									; internal error should not happen.
		berror 	"#X"
		;
		;		String
		;
_EXAString:
		iny 								; point to string length, which is the string start.
		tya 								; work out the physical address of the string
		clc
		adc 	codePtr
		sta 	xsAddrLow,x
		lda 	codePtr+1
		adc 	#0
		sta 	xsAddrHigh,x
		lda 	#$40 						; set the type to string
		sta 	xsStatus,x
		;
		tya 								; add the length to the current position
		sec 								; +1 for the length byte itself.
		adc 	(codePtr),y
		tay
		jmp 	_EXAHaveTerm
		;
		;		Unary Function. A contains its token.
		;
_EXAUnaryFunction:				
		phx 								; get the table entry to check it is a unary function
		tax
		bit 	TokenControlByteTable-$80,x ; if bit 6 is not set, it's not a unary function.
		bvc 	_EXANotUnaryFunction 		
		txa 								; now copy the routine address, put token x 2 in.
		asl 	a
		tax
		lda 	TokenVectors,x 				; get address => zTemp2
		sta 	zTemp2
		lda 	TokenVectors+1,x
		sta 	zTemp2+1
		plx 								; restore stack depth.
		iny 								; skip unary function token.
		jsr 	_EXACallZTemp2 				; call the routine	
		jmp 	_EXAHaveTerm 				; and loop round again.
		;
_EXANotUnaryFunction:
		jmp 	SyntaxError		

_EXACallZTemp2:								; so we can jsr (zTemp2)
		jmp 	(zTemp2)
		