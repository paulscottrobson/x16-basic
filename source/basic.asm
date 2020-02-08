; *****************************************************************************
; *****************************************************************************
;
;		Name :		basic.asm
;		Purpose :	X16-Basic Main program.
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		7th February 2020
;
; *****************************************************************************
; *****************************************************************************

		.include 	"code/data.asm"
		.include 	"code/macros.asm"

		* =	$1000
		jmp 	ColdStart
		.include "files.asm" 				; minimises address change hopefully.
ColdStart:		
		ldx 	#$FF 						; reset the stack
		txs
		set16 	codePtr,TestProgram 		; set up.
		ldy 	#0
		jsr 	EvaluateExpression 
		jmp 	$FFFF
		
TestProgram:
		.include 	"generated/testcode.inc"	
		.byte 	$80

SyntaxError:	
		ldx 	#$5E			
		.byte 	$FF
ErrorHandler:	
		.byte 	$FF		
		ldx 	#$EE			
