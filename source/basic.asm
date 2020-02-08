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
		jsr 	ExternInitialise		
		lda 	#BootMessage & $FF
		ldy 	#BootMessage >> 8
		jsr 	EXPrintString
		jmp 	Command_Run
		
WarmStart:		
		jmp 	$FFFF		

BootMessage:
		.text 	"**** Commander X16 Basic Alpha 1 ****",13,13
		.text 	"512K High RAM",13,13,0

BasicProgram:
		