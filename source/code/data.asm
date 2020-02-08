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

; *****************************************************************************
;				   Variables that can be shared with Kernel etc.
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