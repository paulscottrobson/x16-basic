; *****************************************************************************
; *****************************************************************************
;
;		Name :		gosub.asm
;		Purpose :	X16-Basic Gosub & Return
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		8th February 2020
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;								GOSUB <linenumber>
;
; *****************************************************************************

Command_Gosub:	;; gosub
		jsr 	EvaluateExpression 			; get the line number.
		jsr 	StructPushPos 				; save position
		lda 	#SMARK_GOSUB 				; push a GOSUB marker
		jsr 	StructPushA
		jsr 	TransferControlToStack		; branch to there
		rts

; *****************************************************************************
;
;									RETURN
;
; *****************************************************************************

Command_Return: ;; return
		checkStructureStack SMARK_GOSUB,"No Gosub"
		lda 	#1 							; restore return address
		jsr 	StructGetPos
		lda 	#4 							; pop the address and marker
		jsr 	StructPopABytes
		rts
