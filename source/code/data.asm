; *****************************************************************************
; *****************************************************************************
;
;		Name :		data.asm
;		Purpose :	Data allocation
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		7th February 2020
;
; *****************************************************************************
; *****************************************************************************

		* = $0

; *****************************************************************************
;
;								Zero Page Variables
;
; *****************************************************************************

codePtr:									; pointer to current line.
		.word 	?

structSP:									; structure stack pointer (index into structStack)
		.byte 	?

; *****************************************************************************
;
;	 	  Temp Zero Page Variables that can be shared with Kernel etc.
;
; *****************************************************************************

zTemp1:										; general usage zero page
		.word 	?	
zTemp2:	
		.word 	?
zTemp3:	
		.word 	?
zTemp4:
		.word 	?
		
; *****************************************************************************
;
;							Other memory allocation
;
; *****************************************************************************

signCount:									; division sign count
		.byte 	?

convertPtr:									; buffer position when converting.
		.byte 	?

randomSeed: 								; 16 bit random value.
		.word 	?

; *****************************************************************************
;
;						  Specific address allocation
;
; *****************************************************************************

xsStatus = $600								; expression stack (must all fit in one page)
stackSize = $20 							; stack elements allowed (max 256/6)

xsAddrLow = xsStatus+stackSize 				; these values are shared depending on type.
xsAddrHigh = xsStatus+stackSize*2

xsIntLow = xsAddrLow
xsIntHigh = xsAddrHigh

xsMantissa3 = xsAddrLow
xsMantissa2 = xsAddrHigh
xsMantissa1 = xsStatus+stackSize*3
xsMantissa0 = xsStatus+stackSize*4
xsExponent = xsStatus+stackSize*5

variables = $700							; 26 variables A-Z. Must be on a page boundary.

structStack = $780 							; structure stack.

textBuffer = $800							; text buffer for input command lines.

; *****************************************************************************
;
;									   Constants
;
; *****************************************************************************

TOK_STRING_OBJ = $FB
TOK_BYTE_OBJ = $FE
TOK_WORD_OBJ = $FF

SMARK_GOSUB = 'G'

; *****************************************************************************
;
;										Colours.
;
; *****************************************************************************

COL_BLACK = 0 		
COL_RED = 1
COL_GREEN = 2
COL_YELLOW = 3
COL_BLUE = 4
COL_MAGENTA = 5
COL_CYAN = 6
COL_WHITE = 7
COL_RVS = 8

