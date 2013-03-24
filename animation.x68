*-----------------------------------------------------------
* Written by    : Hussein Abdallah, Cameron Beyer
* Date Created  : April 24, 2012
* Description   : Final Project, Graphical
*
*-----------------------------------------------------------
  ORG	$1000

START
	
	LEA		QUANTUM,A1
	MOVE	#70,D0
	TRAP	#15			; play the sound file

	move.l	#0,COUNT
	move.l	#FUCHSIA,d1
	move.b	#80,d0
	trap	#15			; set pen color for shape outline to fuchsia
	
	move.b	#93,d0
	move.b	#5,d1
	trap	#15			; set pen width to 3 pixels
	
repeat	move.l	#20,d1	; X1 = 20
	move.l	#20,d2		; Y1 = 20
	move.l	#620,d3		; X2 = 620
	move.l	#460,d4		; Y2 = 460
	
	move.l	#0,d5
	
ocent	move.l	#0,d6
	move.b	#87,d0		; draw the rectangle specified by the coordinates above
	trap	#15
wait1	add	#1,d6
	NOP					; dont do anything
	NOP
	cmp	#WLIM,d6
	bne	wait1
	move.l	d1,X1
	move.w  #$FF00,d1
	move.b	#11,d0		; clear screen command
	trap	#15
	move.l	X1,d1		
	add	#1,d5
	add	#20,d1
	add	#20,d2
	sub	#20,d3
	sub	#20,d4			; shrink the rectangle
	
	cmp	#11,d5
	bne	ocent			; draw 11 shrinking rectangles
	add	#1,COUNT
	cmp	#15,COUNT
	bne	repeat			; repeat the 11-draws 15 times

	move.l	#GREEN,d1
	move.b	#80,d0		
	trap	#15			; set pen color for shape outline
	
	move.l	#LIME,d1
	move.b	#81,d0
	trap	#15			; set shape fill color	
	
	move.b	#93,d0		
	move.b	#1,d1
	trap	#15			; set pen width
	
	move.l	#75,d1		; X1 = 75
	move.l	#20,d2		; Y1 = 20
	move.l	#95,d3		; X2 = 95
	move.l	#75,d4		; Y2 = 75
	
rec	move.l	#0,d5
	move.b	#88,d0		; draw ellipse bounded by points in D1-D4
	trap	#15
	add.l	#101,d2		; increment the value of y
	add.l	#101,d4		; increment the value of y
	trap	#15			; draw filled rectangle
	cmp		#330,d3		; keep going for 330 pixels
	bge		bounce
	sub.l	#100,d2		; net loss of one pixel in the y-direction (going down)
	sub.l	#100,d4		; net loss of one pixel in the y-direction (going down)
	bra kk
bounce sub.l	#102,d2	; net gain of one pixel in the y-direction (going up)
	sub.l	#102,d4		; net gain of one pixel in the y-direction
kk	cmp		#545,d1
	beq		kgo
	add 	#1,d1
	add		#1,d3
wait2 add	#1,d5
	cmp		#15000,d5
	bne		wait2		; a little pause in between construction of the tubes
	bra		rec
	
kgo						; begin second round of tubes
	move.b	#93,d0		
	move.b	#1,d1
	trap	#15			; set pen width
	move.l	#75,d1		; X1 = 75
	move.l	#460,d2		; Y1 = 460
	move.l	#95,d3		; X2 = 95
	move.l	#405,d4		; Y2 = 405
rec1	move.l	#0,d5
	move.b	#88,d0		; draw ellipse bounded by points in D1-D4
	trap	#15
	sub.l	#101,d2		; decrement the value of y
	sub.l	#101,d4		; decrement the value of y
	trap	#15			; draw filled rectangle
	cmp		#330,d3		; keep going for 330 pixels
	bge		bounce1
	add.l	#100,d2		; net loss of one pixel in the y-direction (going down)
	add.l	#100,d4		; net loss of one pixel in the y-direction (going down)
	bra kk1
bounce1 add.l	#102,d2	; net gain of one pixel in the y-direction (going up)
	add.l	#102,d4		; net gain of one pixel in the y-direction
kk1	cmp		#545,d1
	beq		kgo1
	add 	#1,d1
	add		#1,d3
wait3 add	#1,d5
	cmp		#15000,d5
	bne		wait3		; again a little pausing
	bra		rec1
kgo1					; tubes complete
	move.l	#240,d1
	move.l	#160,d2
	move.l	#400,d3
	move.l	#320,d4
	move.b	#88,d0
	trap	#15			; draw center circle (nucleus)

	move.l	#10,d1		; X1 = 10
	move.l	#10,d2		; Y1 = 10
	move.l	#60,d3		; X2 = 60
	move.l	#60,d4		; Y2 = 60
	move.b	#88,d0		; circle-drawing command in for trapping
	trap	#15			; draw upper left filled circle
		
	move.l	#60,d1
	move.l	#35,d2		; X-Y of where to start the upper line
	
	move.l	#0,d5		; clear the wait counter
pix	move.b	#82,d0		; pixel-draw command
	trap	#15			; draw upper line
	add		#1,d1		; we're increasing 1 in the X-direction (move right)
	trap	#15
	add		#1,d1		; do two so it draws faster
	trap	#15
	add		#1,d1
wait4 add	#1,d5
	cmp		#WLIMIT,d5	; mini pause
	bne		wait4
	cmp		#580,d1		; see if we're done...
	blt		pix			; ... if we're not there yet, keep going
		
	add		#570,d3		; catch our X2 up to all the moving we've been doing
	move.l	#10,d2		; get the Y1 back to where we're drawing the circle instead of the line
	move.b	#88,d0		; circle-drawing command in for trapping
	trap	#15			; draw upper right filled circle
	
	move.l	#605,d1
	move.l	#60,d2		; X-Y of where to start the right line
	
	move.l	#0,d5		; clear the wait counter
pi2 move.b	#82,d0		; pixel-draw command
	trap	#15			; draw right line
	add		#1,d2		; we're increasing 1 in the Y-direction (move down)
	trap	#15
	add		#1,d2		; do two so it draws faster
	trap	#15
	add		#1,d2
wait5 add	#1,d5
	cmp		#WLIMIT,d5	; mini pause
	bne		wait5
	cmp		#420,d2		; see if we're done...
	blt		pi2			; ... if we're not there yet, keep going
	
	add		#410,d4		; catch our Y2 up to all the moving we've been doing
	move.l	#580,d1		; get the X1 back to where we're drawing the circle instead of the line
	move.b	#88,d0		; circle-drawing command in for trapping
	trap	#15			; draw lower right filled circle
	
						; turns out the X1 is correct to start drawing our bottom line
	move.l	#445,d2		; Y of where to start the bottom line
	
	move.l	#0,d5		; clear the wait counter
pi3	move.b	#82,d0		; pixel-draw command
	trap	#15			; draw bottom line
	sub		#1,d1		; we're decreasing 1 in the X-direction (move left)
	trap	#15
	sub		#1,d1		; do two so it draws faster
	trap	#15
	sub		#1,d1
wait6 add	#1,d5
	cmp		#WLIMIT,d5	; mini pause
	bne		wait6
	cmp		#60,d1		; see if we're done...
	bgt		pi3 		; ... if we're not there yet, keep going
	
	sub		#570,d3		; back our X2 up to all the moving we've been doing
	move.l  #10,d1		; get the X1 back to where we're drawing the circle instead of the line
	move.l	#420,d2		; get the Y1 back to where we're drawing the circle instead of the line
	move.b	#88,d0		; circle-drawing command in for trapping
	trap	#15			; draw lower left filled circle
	
						; turns out the Y1 is correct to start drawing our left line
	move.l  #35,d1		; X of where to start the left line
	
	move.l	#0,d5		; clear the wait counter
pi4 move.b	#82,d0		; pixel-draw command
	trap	#15			; draw left line
	sub		#1,d2		; we're decreasing 1 in the Y-direction (move up)
	trap	#15
	sub		#1,d2		; do two so it draws faster
	trap	#15
	sub		#1,d2
wait7 add	#1,d5
	cmp		#WLIMIT,d5	; mini pause
	bne		wait7
	cmp		#60,d2		; see if we're done...
	bgt		pi4			; ... if we're not there yet, keep going

redraw	move.l	#0,d5	; clear the wait counter
	move.l	#MAROON,d1	; set base color for shape outline
	add.l	#$00001F,COLOROF
	add.l	COLOROF,d1	; add color offset
	move.b	#80,d0		
	trap	#15			; set pen color for shape outline
	
	move.b	#81,d0
	trap	#15			; shape fill color will be the same as the outline
	
	move.b	#0,d1
	move.b	#0,d2
	move.b	#89,d0
	trap	#15			; flood the edges
	
	move.b	#88,d0		; circle-drawing command in for trapping
; draws
	move.l	#10,d1
	move.l	#10,d2
	move.l	#60,d3
	move.l	#60,d4
	trap	#15			; draw upper left filled circle
; all of
	move.l	#580,d1
	add		#570,d3
	trap	#15			; draw upper right filled circle
; the circles
	move.l	#420,d2
	add		#410,d4
	trap	#15			; draw lower right filled circle	
; including
	move.l	#10,d1
	sub		#570,d3
	trap	#15			; draw lower left filled circle		
; the
	move.l	#240,d1
	move.l	#160,d2
	move.l	#400,d3
	move.l	#320,d4
	trap	#15			; draw center circle (nucleus)
; nucleus
wait8 add	#1,d5
	cmp		#WLIMIT,d5	; mini pause
	bne		wait8
	move.l	#MAROON,d1	; set base color for shape outline
	add.l	COLOROF,d1	; add color offset
	cmp.l	#$FFFF00,d1	; if we've not gone through all the colors...
	blt		redraw		; ... then we're good; redraw
	
	MOVE.B	#9,D0
	TRAP	#15			Halt Simulator

QUANTUM	dc.b 	'quantum.wav',0	

BLACK	EQU	$00000000
MAROON	EQU	$00000080
GREEN	EQU	$00008000
OLIVE	EQU	$00008080
NAVY	EQU	$00800000
PURPLE	EQU	$00800080
TEAL	EQU	$00808000
GRAY	EQU	$00808080
RED		EQU	$000000FF
LIME	EQU	$0000FF00
YELLOW	EQU	$0000FFFF
BLUE	EQU	$00FF0000
FUCHSIA	EQU	$00FF00FF
AQUA	EQU	$00FFFF00
LTGRAY	EQU	$00C0C0C0
WHITE	EQU	$00FFFFFF

WLIMIT	EQU	200

COUNT	dc.l	0
COLOROF	dc.l	0
X1		dc.l	0
WLIM	EQU	50000

	END	START













