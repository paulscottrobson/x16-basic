; *****************************************************************************
; *****************************************************************************
;
;		Name :		error.asm
;		Purpose :	Error Handling
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		8th February 2020
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;								  	Common Errors
;
; *****************************************************************************

SyntaxError:	
		berror 	"Syntax Error"
TypeMismatch:
		berror 	"Type Mismatch"
ParameterError:
		berror 	"Parameter"
		
; *****************************************************************************
;
;							  Handle specific errors
;
; *****************************************************************************

ErrorHandler:	
		pla 								; get message address
		ply
		inc 	a
		bne 	_EHNoCarry
		iny
_EHNoCarry:
		jsr 	EXPrintString
		ldy 	#1 							; check if there is a line #
		lda 	(codePtr),y
		iny
		ora 	(codePtr),y
		beq 	_EHNoLine
		;
		lda 	#_EHMsg2 & $FF 				; print " at "
		ldy 	#_EHMsg2 >> 8
		jsr 	EXPrintString
		ldy 	#2 							; print line number
		lda 	(codePtr),y
		pha
		dey		
		lda 	(codePtr),y
		ply
		clc
		jsr 	PrintYA
_EHNoLine:
		lda 	#13
		jsr 	ExternPrint
_h1:	bra 	_h1
		jmp 	WarmStart

_EHMsg2:
		.text 	" at ",0	
