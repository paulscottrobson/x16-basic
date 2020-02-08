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

; *****************************************************************************
;
;				Binary operators supported in int, float and string
;							(+ and comparison operators)
;
; *****************************************************************************

alltypederef .macro
		jsr 	DeReferenceBinary 			; convert references to values		
		bit 	xsStatus,x 					; is this a string ?
		bvc 	_NumericType
		jsr 	BinaryStringTypeCheck 		; check both are strings
		jmp 	\2 							; and do the string handler
_NumericType:	
		jsr 	BinaryNumberTypeCheck 		; see if they are compatible.	
		bcc 	_Integer
		jmp 	\1
_Integer:
		.endm
		
; *****************************************************************************
;
;			Check if top of structure stack is a value, error if not.
;
; *****************************************************************************

checkStructureStack .macro
		lda 	#\1 						; thing to check against
		jsr 	StructureCheckTOS 			; is it on top ?
		bcc 	_Ok
		berror 	\2 							; if not display error message
_Ok:
		.endm		
		