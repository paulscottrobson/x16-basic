; *****************************************************************************
; *****************************************************************************
;
;		Name :		goto.asm
;		Purpose :	X16-Basic Assignment command
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		8th February 2020
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;									GOTO
;
; *****************************************************************************

Command_GOTO:	;; goto
		jsr 	EvaluateExpression 			; get the line number.
		jsr 	TransferControlToStack		; branch to there
		rts


; *****************************************************************************
;	
;						Goto the line number on the stack,x
;
; *****************************************************************************

TransferControlToStack:				
		jsr 	DeReferenceUnary 			; remove a reference.
		lda 	xsStatus,x 					; must be an integer.
		bne 	_TCTBadLine
		;
		lda 	xsIntLow,x 					; copy line # to zTemp1
		sta 	zTemp1
		lda 	xsIntHigh,x
		sta 	zTemp1+1
		;
		set16 	codePtr,BasicProgram 		; reset pointer.
		;
_TCTLoop:
		lda 	(codePtr) 					; didn't find it
		beq 	_TCTUnknown		
		ldy 	#1 		 					; does it match ?				
		lda		(codePtr),y
		cmp 	zTemp1
		bne 	_TCTGoNext
		iny
		lda		(codePtr),y
		cmp 	zTemp1+1
		beq 	_TCTFound
_TCTGoNext:
		advance codePtr 					; next line
		bra 	_TCTLoop 					; loop round
_TCTFound:
		ldy 	#3 							; from start of the line
		rts						


_TCTBadLine:
		jmp 	ParameterError
_TCTUnknown:
		berror 	"Line number"		