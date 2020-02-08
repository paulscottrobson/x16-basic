; *****************************************************************************
; *****************************************************************************
;
;		Name :		files.asm
;		Purpose :	Basic Includes
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		7th February 2020
;
; *****************************************************************************
; *****************************************************************************

TokenTextTable:
		.include 	"generated/tokentext.inc"

TokenControlByteTable:		
		.include 	"generated/tokencbyte.inc"		

		.align 	2 				; defense against old 6502 bug may be present.
TokenVectors:
		.include 	"generated/tokenvectors.inc"

		.include 	"generated/tokenconst.inc"

		.include 	"code/error.asm"
		.include 	"code/extern.asm"
		.include 	"code/syntax.asm"
		
		.include 	"commands/let.asm"
		.include 	"commands/miscellany.asm"
		.include 	"commands/run.asm"

		.include 	"expression/evaluate.asm"
		.include 	"expression/exprutils.asm"
		.include 	"expression/integer/arithmetic.asm"
		.include 	"expression/integer/multiply.asm"
		.include 	"expression/integer/divide.asm"
		.include 	"expression/integer/icompare.asm"
		.include 	"expression/integer/unary.asm"

		.include 	"variables/variable.asm"
		
		.include 	"expression/float/floatdummy.asm"

