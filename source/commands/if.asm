; *****************************************************************************
; *****************************************************************************
;
;		Name :		if.asm
;		Purpose :	X16-Basic Conditional commands
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		9th February 2020
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;									IF command
;
;		IF .... THEN .... 					Classic 'single line'
; 		IF .... ..... ELSE .... ENDIF 		Modern 'multi line'
;
; *****************************************************************************

IfCommand:		;; if
		jsr 	EvaluateExpression 			; this is the IF test.
		jsr 	DereferenceUnary 			; make it an integer value.
		bit 	xsStatus 					; check type
		bvs 	_IFCType 					; string, error
		bpl 	_IFCInteger 				; if float
		jsr 	FPFloatToInteger  			; convert to integer
_IFCInteger:
		lda 	(codePtr),y 				; what follows ?
		cmp 	#TOK_THEN 					; if it is not then it is multiline IF
		bne 	_IFCMultiline
		iny 
		lda 	xsIntLow 					; check if it is non-zero
		ora 	xsIntHigh
		bne 	_IFCExecute 				; if so, then execute the rest of the line.
		lda 	(codePtr)					; point at the last character on the line
		tay 								
		dey
		rts
		;
		;		Successful IF test. Check for IF ... THEN <constant>
		;
_IFCExecute:
		lda 	(codePtr),y 				; what follows ? if it is a number, then do GOTO
		cmp 	#TOK_BYTE_OBJ 				; byte/word tokens
		beq 	_IFCGoto
		cmp 	#TOK_WORD_OBJ
		beq 	_IFCGoto
		and 	#$C0 						; check for 40-7F the short constants.
		cmp 	#$40
		beq 	_IFCGoto 
		rts

_IFCGoto:
		jmp 	Command_GOTO

_IFCType:
		jmp 	TypeMismatch		


_IFCMultiline:
		berror	"IF..ENDIF not implemented"