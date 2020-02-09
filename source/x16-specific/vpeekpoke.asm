; *****************************************************************************
; *****************************************************************************
;
;		Name :		vpeekpoke.asm
;		Purpose :	X16-Basic VPeek/VPoke
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		9th February 2020
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;									VPOKE
;
; *****************************************************************************

Command_VPOKE: 	;; vpoke
		ldx 	#0 							; get final parameter
		jsr 	LoadVRAMAddress 			; do page,address
		jsr 	SyntaxCheckComma 			; comma
		getparam_n 	TypeMismatch
		lda 	xsIntLow 					; get low byte and write to Vera
		sta 	VeraDataPort
		rts

; *****************************************************************************
;
;									VPEEK
;
; *****************************************************************************

Unary_VPEEK: 	;; vpeek(
		jsr 	LoadVRAMAddress 			; do page,address
		jsr 	SyntaxCheckRightBracket		; do right bracket
		lda 	VeraDataPort 				; return read data
		sta 	xsIntLow,x 					
		stz 	xsIntHigh,x
		stz 	xsStatus,x
		rts

; *****************************************************************************
;
;			Process a sequence of <page>,<addr> for Vera RAM access
;
; *****************************************************************************

LoadVRAMAddress:
		getparam_n 	TypeMismatch 			; page number
		lda 	xsIntLow,x 				
		sta 	VeraAddressPort+2
		;
		jsr 	SyntaxCheckComma 			; comma
		;
		getparam_n 	TypeMismatch 			; page address
		lda 	xsIntLow,x 				
		sta 	VeraAddressPort+0
		lda 	xsIntHigh,x
		sta 	VeraAddressPort+1
		rts
