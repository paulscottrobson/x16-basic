; *****************************************************************************
; *****************************************************************************
;
;		Name :		let.asm
;		Purpose :	X16-Basic Assignment command
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		8th February 2020
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;								LET statement
;
; *****************************************************************************

Command_LET:
		;
		;		Get L-Expr and R-Expr
		;
		ldx 	#0 							; get the L-Expr
		jsr 	EvaluateTermAtX
		lda 	xsStatus,x 					; check to see if it is a reference.
		ror 	a 	
		bcc 	_CLTNotVar 					; if not, then we have an error.
		lda 	#TOK_EQUAL					; next token must be an equals.
		jsr 	SyntaxCheckA 				
		inx
		jsr 	EvaluateExpressionAtX 		; calculate the R-Expr in level 1.
		;
		;		Copy the target address to zTemp1 as we'll need it.
		;
		lda 	xsAddrLow 		
		sta 	zTemp1
		lda 	xsAddrHigh
		sta 	zTemp1+1
		;
		;		Check types match, and what types are being assigned
		;
		lda 	xsStatus 					; check the same types.
		eor 	xsStatus+1
		and 	#$40
		bne 	_CLTTypeMismatch
		;
		bit 	xsStatus 					; string to string assignment
		bvs 	_CLTStringAssignment
		bmi 	_CLTFloatAssignment 
		;
		;		Integer assignment
		;
		bit 	xsStatus+1 					; are we assigning a float to an integer ?
		bvs 	_CLTFloatToInt 				; yes, then we do not auto truncate.
		;
		phy 								; copy value into reference.
		lda 	xsIntLow+1
		sta 	(zTemp1)
		ldy 	#1
		lda 	xsIntHigh+1
		sta 	(zTemp1),y
		ply
		rts

_CLTNotVar:
		jmp 	SyntaxError		
_CLTTypeMismatch:
		jmp 	TypeMismatch		
_CLTFloatToInt:
		berror 	"Precision Lost"

_CLTFloatAssignment:
		bra 	_CLTFloatAssignment
		; TODO: Assign number to float. Might be an int or a float.

_CLTStringAssignment:
		bra 	_CLTStringAssignment
		; TODO: Assign string to string.
