; *****************************************************************************
; *****************************************************************************
;
;		Name :		variable.asm
;		Purpose :	Variable look up
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		8th February 2020
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;		Put a reference to the variable/array at (codePtr),y at stack 
;		position X.
;
; *****************************************************************************

VariableLookup:
		berror	"?IMP"