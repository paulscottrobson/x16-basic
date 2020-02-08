; *****************************************************************************
; *****************************************************************************
;
;		Name :		structstack.asm
;		Purpose :	Structure Stack.
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		8th February 2020
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;						Reset the structure stack
;
; *****************************************************************************

StructReset:
		lda 	#$7F	 					; reset the SP points to TOS
		sta 	structSP
		lda 	#$FF 						; put a dummy marker that can't be a struct marker
		sta 	structStack+$7F
		rts

; *****************************************************************************
;
;						Push A on structure stack
;
; *****************************************************************************

StructPushA:
		phx 								; save X
		dec 	structSP 					; make space on stack
		beq 	SPUnderflow 				; no space left
		ldx 	structSP 					; get offset into X
		sta 	structStack,x 				; and save
		plx
		rts
SPUnderflow:
		berror	"Structure Stack"

; *****************************************************************************
;
;						   Push Y and codePtr on stack
;
; *****************************************************************************

StructPushPos:
		phx
		lda 	structSP 					; make space for 3 bytes
		sec
		sbc 	#3
		beq 	SPUnderflow
		bcc 	SPUnderflow 				; borrowed, so underflowed.
		sta 	structSP
		tax 								; X points to space
		tya 								; save offset
		sta 	structStack,x 				
		lda 	codePtr 					; save address of line
		sta 	structStack+1,x 			
		lda 	codePtr+1
		sta 	structStack+2,x
		plx 									
		rts

; *****************************************************************************
;
;					Restore Y and codePtr of stack at offset A
;
; *****************************************************************************

StructGetPos:
		clc 								; add offset to stack pointer.
		adc 	structSP
		tax
		lda 	structStack,x 				; Y offset
		tay
		lda 	structStack+1,x
		sta 	codePtr
		lda 	structStack+2,x
		sta 	codePtr+1
		rts

; *****************************************************************************
;
;						Pop A bytes off the structure stack
;
; *****************************************************************************

StructPopABytes:
		clc
		adc 	structSP
		sta 	structSP
		rts

; *****************************************************************************
;
;					 Check TOS is A. Return CS if not flag
;
; *****************************************************************************

StructCheckTOS:
		phx
		ldx 	structSP 					; get offset to TOS
		eor 	structStack,x 				; zero if match, non zero if didn't
		clc
		adc 	#$FF 						; carry will now be set if it doesn't match
		plx 								; restore X and exit
		rts
		