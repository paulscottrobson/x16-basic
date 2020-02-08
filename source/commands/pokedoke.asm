; *****************************************************************************
; *****************************************************************************
;
;		Name :		pokedoke.asm
;		Purpose :	X16-Basic Poke/Doke
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		8th February 2020
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;						POKE and DOKE write byte and word
;
; *****************************************************************************

Command_Poke:  ;; poke
		clc
		bra 	WriteMemoryMain
Command_Doke:	;; doke		
		sec
WriteMemoryMain:
		php									; save cc byte cs word
		ldx 	#0 							; get address and parameter.
		getparam_n 	TypeMismatch
		jsr 	SyntaxCheckComma
		inx
		getparam_n 	TypeMismatch
		;
		lda 	xsAddrLow 					; transfer address
		sta 	zTemp1
		lda 	xsAddrHigh		
		sta 	zTemp1+1
		lda 	xsIntLow+1 					; do the poke anyway
		sta 	(zTemp1)
		plp
		bcs 	_WMMWord
		lda 	xsIntHigh+1 				; get high byte
		bne 	_WMMByteReq 				; should be zero
		rts
_WMMByteReq:
		jmp 	ParameterError
		;
_WMMWord:									; word write.
		phy
		ldy 	#1
		lda 	xsIntHigh+1
		sta 	(zTemp1),y
		ply
		rts				
