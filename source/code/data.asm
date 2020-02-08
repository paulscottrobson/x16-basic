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

xsStatus = $600								; expression stack.
xsAddrLow = $620 							; these values are shared depending on type.
xsAddrHigh = $640

xsIntLow = xsAddrLow
xsIntHigh = xsAddrHigh

xsMantissa3 = xsAddrLow
xsMantissa2 = xsAddrHigh
xsMantissa1 = $660
xsMantissa0 = $680
xsExponent = $6A0

