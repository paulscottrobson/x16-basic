; *****************************************************************************
; *****************************************************************************
;
;		Name :		miscellany.asm
;		Purpose :	X16-Basic Miscellaneous
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		8th February 2020
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;								Assert command
;
; *****************************************************************************

Command_Assert: ;; assert
		ldx 	#0 							; get a single parameter
		getparam_n SyntaxError  			; not a float.
		lda 	xsIntLow,x 					; check it is non-zero		
		ora 	xsIntHigh,x
		beq 	_CAFail
		rts
_CAFail:berror 	"Assert"		
