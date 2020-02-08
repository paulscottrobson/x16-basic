; *****************************************************************************
; *****************************************************************************
;
;		Name :		run.asm
;		Purpose :	X16-Basic Run command
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		8th February 2020
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;								RUN program
;
; *****************************************************************************

Command_RUN: 	;; run
		; TODO: Clear variable memory and initialise memory free pointers.
		set16 	codePtr,BasicProgram 		; reset the program memory pointer.
		;
		;		Run line at codePtr
		;		
_CRNewLine:
		lda 	(codePtr) 					; check not at the end of the program
		beq 	Command_END 				; reached the end of the program
		ldy 	#2 							; first token of program line -1 for the INY
_CRNextToken:
		iny 								; 		
		;
		;		Do next command.
		;		
_CRNextCommand:
		lda 	(codePtr),y 				; look at token.
		bpl 	_CRDefaultLet 				; is it a token, if not, try LET.
		cmp 	#TOK_COLON 					; skip colons
		beq 	_CRNextToken
		cmp 	#TOK_LAST_TOKEN				; token too high, probably $F8-$FF
		bcs 	_CRSyntax
		asl 	a 							; put token x 2 in X, clears bit 7.
		beq 	_CRNextLine 				; if this is zero now it was $80, so end of line
		tax
		iny 								; advance over token.
		jsr 	_CRCallRoutine 				; call that routine
		bra 	_CRNextCommand 				; and carry on.
		;
		;		Go to next line
		;		
_CRNextLine:
		advance codePtr 					; go to actual next line.
		bra 	_CRNewLine 					; do new line code.

_CRCallRoutine:
		jmp 	(TokenVectors,x)
_CRSyntax:
		jmp 	SyntaxError
_CRDefaultLet:		
		jmp 	Command_LET

; *****************************************************************************
;
;									End program
;
; *****************************************************************************

Command_END:	;; end
		jmp 	WarmStart

; *****************************************************************************
;
;									Stop program
;
; *****************************************************************************

Command_STOP:	;; stop
		berror	"Stop"						

