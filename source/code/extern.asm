; ******************************************************************************
; ******************************************************************************
;
;		Name : 		extern.asm
;		Purpose : 	External functionality
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	8th February 2020
;
; ******************************************************************************
; ******************************************************************************

; ******************************************************************************
;
;							Extern Initialise
;
; ******************************************************************************

ExternInitialise:
		lda 	#144 						; set colour
		jsr 	$FFD2
		lda 	#$01
		jsr 	$FFD2
		lda 	#14							; lower case
		jsr 	$FFD2		
		lda 	#147 						; clear screen
		jsr 	$FFD2
		lda 	#COL_WHITE 					; white text.
		jmp 	ExternColour

; ******************************************************************************
;
;								Break Check
;
; ******************************************************************************

ExternCheckBreak:
		phx 								; make sure we keep XY
		phy
		jsr 	$FFE1						; STOP check on CBM KERNAL
		beq		_ECBExit 					; stopped
		ply 								; restore and exit.
		plx
		rts

_ECBExit:
		berror 	"Break"

; ******************************************************************************
;
;									Print A
;
; ******************************************************************************

ExternPrint:
		pha
		phx
		phy
		and 	#$7F
		jsr 	$FFD2
		ply
		plx
		pla
		rts

; ******************************************************************************
;
;								 Switch colours
;
; ******************************************************************************

ExternColour:
		pha
		phx
		pha
		and 	#8
		asl 	a
		asl 	a
		asl 	a
		asl 	a
		eor 	#$92
		jsr 	$FFD2

		pla
		and 	#7
		tax 	
		lda 	_ECTable,x
		jsr 	$FFD2
		plx
		pla
		rts

_ECTable:
		.byte 	144
		.byte 	28
		.byte 	30
		.byte 	158
		.byte 	31
		.byte 	156
		.byte 	159
		.byte 	5

; ******************************************************************************
;
;			  Input a command, ASCII U/C String in InputBuffer
;
; ******************************************************************************

ExternInput:
		lda 	#(textBuffer & $FF)
		sta 	zTemp3
		lda 	#(textBuffer >> 8)
		sta 	zTemp3+1
_EIRead:jsr 	$FFCF
		cmp 	#13
		beq 	_EIExit
		and 	#$7F
		sta 	(zTemp3)
		inc 	zTemp3
		bne 	_EIRead
		inc 	zTemp3+1
		bra 	_EIRead
_EIExit:lda 	#0
		sta 	(zTemp3)
		lda 	#13
		jsr 	ExternPrint
		rts

; ******************************************************************************
;
;						Save a file from YA to zTemp1
;
; ******************************************************************************

ExternSave:
		phx
		phy

		sta 	zTemp2 						; save start
		sty 	zTemp2+1

		jsr 	EXGetLength 				; get length of file into A
		ldx 	zTemp3
		ldy 	zTemp3+1
		jsr 	$FFBD 						; set name
		;
		lda 	#1
		ldx 	#8	 						; device #8
		ldy 	#0
		jsr 	$FFBA 						; set LFS
		;
		ldx 	zTemp1 						; end address
		ldy 	zTemp1+1
		;
		lda 	#zTemp2
		jsr 	$FFD8 						; save
		bcs 	_ESSave

		ply
		plx
		rts

_ESSave:
		berror 	"Load Failed"

; ******************************************************************************
;
;							  Load a file to YA
;
; ******************************************************************************

ExternLoad:
		phx 								; save XY
		phy

		pha 								; save target
		phy

		jsr 	EXGetLength 				; get length of file into A
		ldx 	zTemp3
		ldy 	zTemp3+1
		jsr 	$FFBD 						; set name
		;
		lda 	#1
		ldx 	#8	 						; device #8
		ldy 	#0
		jsr 	$FFBA 						; set LFS		

		ply 								; restore target to YX and call load
		plx
		lda 	#0 							; load command
		jsr 	$FFD5
		bcs 	_ESLoad

		ply
		plx
		rts

_ESLoad:
		berror 	"LOAD FAILED"

; ******************************************************************************
;
;						Get length of filename in zTemp3
;
; ******************************************************************************

EXGetLength:
		phy
		ldy 	#255
_EXGL0:	iny
		lda 	(zTemp3),y
		bne 	_EXGL0
		tya
		ply		
		rts

; ******************************************************************************
;
;							Print ASCIIZ string at YA
;
; ******************************************************************************

EXPrintString:
		pha
		phy
		sty 	zTemp1+1
		sta 	zTemp1
		ldy 	#0
_EXPSLoop:
		lda 	(zTemp1),y
		beq 	_EXPSExit
		and 	#$7F
		cmp 	#'a'
		bcc 	_EXPSNoLC
		cmp 	#'z'+1
		bcs 	_EXPSNoLC
		sec
		sbc 	#32
_EXPSNoLC:		
		jsr 	$FFD2
		iny	
		bra 	_EXPSLoop		
_EXPSExit:
		ply
		pla
		rts		
