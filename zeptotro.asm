;
; ZEPTOTRO
;

; Code and graphics by T.M.R/Cosine
; Music by 4-Mat/Ate Bit/Orb


; A minimal intro that sits between $03c0 and $07ff so, technically,
; it doesn't exist!  Just a bit of silliness inspired by Femtotro
; using screen RAM for data and wondering how much further that could
; potentially be pushed.


; This source code is formatted for the ACME cross assembler from
; http://sourceforge.net/projects/acme-crossass/
; Compression is handled with Exomizer which can be downloaded at
; http://csdb.dk/release/?id=141402

; build.bat will call both to create an assembled file and then the
; crunched release version.


; Select an output filename
		!to "zeptotro.prg",cbm


; Yank in binary data
		* = $07c0
sprite_data	!binary "data/copyright.spr"


; Constants
screen_col	= $09
scroll_col	= $0f

; Labels
spr_update_tmr	= $07f6
scroll_x	= $07f7


; Entry point at $0400
		* = $0400

entry		sei

; Turn on the sprites
		lda #$ff
		sta $d015
		sta $d017
		sta $d01d

; Set up colours
		lda #screen_col
		sta $d020
		sta $d021

		ldx #$00
colour_init_1	sta $d800,x
		sta $d900,x
		sta $da00,x
		sta $dae8,x
		inx
		bne colour_init_1

		ldx #$27
		lda #scroll_col
colour_init_2	sta $dbc0,x
		dex
		bpl colour_init_2

; Copy the sprite data and clear the scroller's space
		ldx #$3e
sprite_copy	lda sprite_data,x
		sta $03c0,x
		lda #$20
		sta sprite_data,x
		dex
		bpl sprite_copy

; Set the sprite colours and data pointers
		ldx #$00
sprite_set	lda sprite_cols,x
		sta $d027,x
		lda #$0f
		sta $07f8,x
		inx
		cpx #$08
		bne sprite_set

; Switch to lower case
		lda #$16
		sta $d018

; Set up the music
		jsr music_init

; Wait for raster line $fc
main_loop	lda $d012
		cmp #$fc
		bne main_loop

; Update the scroller
		lda scroll_x
		clc
		adc #$03
		sta scroll_x
		cmp #$08
		bcc scr_xb

		ldx #$00
mover		lda $07c1,x
		sta $07c0,x
		inx
		cpx #$26
		bne mover

; Fetch a new character
mread		lda scroll_text
		bne okay

		lda #<scroll_text
		sta mread+$01
		lda #>scroll_text
		sta mread+$02
		jmp mread

okay		sta $07e6

		inc mread+$01
		bne *+$05
		inc mread+$02

		lda scroll_x
scr_xb		and #$07
		sta scroll_x

		eor #$07
		sta $d016

; Move the sprites
		dec spr_update_tmr
		bne sprite_move-$02

; Time for a new sprite move
		lda sprite_speeds+$00
		pha
		ldy sprite_speeds+$01

		ldx #$00
speed_shift	lda sprite_speeds+$02,x
		sta sprite_speeds+$00,x
		inx
		cpx #$0e
		bne speed_shift

		pla
		sta sprite_speeds+$0e
		sty sprite_speeds+$0f

; Fetch a "random" delay from the ROM
update_rnd	lda $a800,x
		and #$7f
		clc
		adc #$40
		sta spr_update_tmr

		inc update_rnd+$01

; Update the sprite positions
		ldx #$0e
sprite_move	lda sprite_pos+$00,x
		clc
		adc sprite_speeds+$00,x
		sta sprite_pos+$00,x
		cmp #$e0
		bcc *+$05
		sec
		sbc #$04
		asl
		rol $d010
		sta $d000,x

		lda sprite_pos+$01,x
		clc
		adc sprite_speeds+$01,x
		sta sprite_pos+$01,x
		asl
		sta $d001,x

		dex
		dex
		bpl sprite_move

; Play the music
		jsr music_play

; Check to see if space has been pressed
		lda $dc01
		cmp #$ef
		beq *+$05
		jmp main_loop

; Exit point
		lda #$00
		sta $d011
		sta $d015
		sta $d418

; A call to the linked file's decruncher goes here...
		jmp $fce2


; Include the music
		!src "includes/type_mismatch.asm"

; Sprite positions
sprite_pos	!byte $7b,$d3,$8d,$e4,$32,$32,$4d,$53
		!byte $35,$b5,$6a,$a3,$ce,$57,$8b,$f6

; Sprite colours
sprite_cols	!byte $02,$08,$0a,$07,$0d,$03,$05,$04

; Sprite movement speeds
sprite_speeds	!byte $00,$ff,$01,$ff,$01,$00,$01,$01
		!byte $00,$01,$ff,$01,$ff,$00,$ff,$ff

; The scrolling message
scroll_text	!scr "Zeptotro - a teensy likkle intro "
		!scr "coded by T.M.R with some "
		!scr "miniscule music from 4-Mat!"
		!scr "      "

		!scr "This intro uses $03c0 to $07ff and "
		!scr "there's bugger all RAM for text, so "
		!scr "greetings to Cosine's friends and "
		!scr "don't forget to visit "
		!scr "Cosine.org.uk !"
		!scr "      "

		!scr "T.M.R - 2018-12-08"
		!scr "           "

		!byte $00
