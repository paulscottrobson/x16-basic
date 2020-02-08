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
TokenVectors:
		.include 	"generated/tokenvectors.inc"
		.include 	"generated/tokenconst.inc"

		.include 	"code/syntax.asm"
		
		.include 	"expression/evaluate.asm"
		.include 	"expression/exprutils.asm"
		.include 	"expression/integer/arithmetic.asm"
		.include 	"expression/integer/multiply.asm"
		.include 	"expression/integer/divide.asm"
		.include 	"expression/integer/icompare.asm"
		.include 	"expression/integer/unary.asm"

		.include 	"expression/float/floatdummy.asm"

		.include 	"variables/variable.asm"