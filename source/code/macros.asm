; *****************************************************************************
; *****************************************************************************
;
;		Name :		macros.asm
;		Purpose :	Data allocation
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		7th February 2020
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;							Report a BASIC error
;
; *****************************************************************************

berror	.macro
		jsr 	ErrorHandler
		.text 	\1,0
		.endm

; *****************************************************************************
;
;							Set 16 bit constant
;
; *****************************************************************************

set16 	.macro
		lda 	#(\2) & $FF
		sta 	0+(\1)
		lda 	#(\2) >> 8
		sta 	1+(\1)
		.endm

; *****************************************************************************
;
;				Advance 2 byte address in zero page to next line
;
; *****************************************************************************

advance	.macro
		clc
		lda 	\1
		adc 	(\1)
		sta 	\1
		bcc 	_NoCarryAdv
		inc 	\1+1
_NoCarryAdv:
		.endm				

; *****************************************************************************
;
;						TypeDereference and Number Check
;
; *****************************************************************************

typederef .macro
		jsr 	DeReferenceBinary 			; convert references to values
		jsr 	BinaryNumberTypeCheck 		; check numeric, returns CC if both integer.
		bcc 	_Integer
		jmp 	\1
_Integer:
		.endm

;
;		This does the same but *converts* to integers, this is for binary operations.
;		(there is no FP *and* routine)
;
intderef .macro		
		jsr 	DeReferenceBinary 			; convert references to values
		jsr 	BinaryNumberTypeCheck 		; check numeric. if float convert to integer
		bcc 	_Integer
		jsr 	FPFloatToInteger 	
_Integer:
		.endm

; *****************************************************************************
;
;							Get a single numeric parameter
;
; *****************************************************************************
		
getparam_n .macro
		jsr 	EvaluateExpressionAtX 		; evaluate the term
		jsr 	DeReferenceUnary 			; convert term to value if reference.
		jsr 	UnaryNumberTypeCheck 		; check numeric, returns CC if integer.
		bcc 	_Integer
		jmp 	\1
_Integer:
		.endm

getparam_s .macro
		jsr 	EvaluateExpressionAtX 		; evaluate the term
		jsr 	DeReferenceUnary 			; convert term to value if reference.
		jsr 	UnaryStringTypeCheck 		; check string.
		.endm

