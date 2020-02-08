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


		.include 	"expression/evaluate.asm"
		.include 	"expression/exprutils.asm"
		.include 	"expression/integer/arithmetic.asm"

		.include 	"expression/float/floatdummy.asm"