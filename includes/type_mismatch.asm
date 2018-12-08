;
; TYPE MISMATCH (REMIX)
;

; Code and music by 4-Mat/Ate Bit/Orb
; (Regenerated to source for Zeptotro by T.M.R)

f60 		= $60

a60		= $60
a61		= $61
a62		= $62
a63		= $63
a64		= $64
a65		= $65
a66		= $66
a67		= $67
a68		= $68
a69		= $69

music_init	clc
		ldx #$02
		ldy #$00
b100b		lda #$08
		sta $d403,y  ;voice 1: pulse waveform width - high-nybble
		lda f1154,x
		sta $d406,y  ;voice 1: sustain / release cycle control
		lda #$57
		sta $d417    ;filter resonance control / voice input control
		lda #$00
		sta a60,x
		tya
		adc #$07
		tay
		dex
		bpl b100b
		stx a67
		stx a66
		rts

music_play	dec a62
		bmi b104f
b102f		ldy a61
		lda f1132,y
		sta $d412    ;voice 3: control register
		lda f1142,y
		sta $d40f    ;voice 3: frequency control - high-byte
		lda a64
		sbc a65
		sta a64
		sta $d416    ;filter cutoff frequency: high-byte
		lda a62
		cmp #$02
		bcc b104e
		inc a61
b104e		rts

b104f		lda #$04
		sta a62
		ldy a66
a1056		=*+$01
		lda f10f2,y
		bpl b105e
		and #$0f
		sta a65
a105f		=*+$01
b105e		lda f1112,y
		and #$01
		tax
		lda f1152,x
		sta $d404    ;voice 1: control register
		sta $d40b    ;voice 2: control register
		lda f10d2,y
		and a69
		sta $d401    ;voice 1: frequency control - high-byte
		lda f10cf,y
		and a69
		sta $d408    ;voice 2: frequency control - high-byte
		tya
		and #$07
		tay
		lda f116f,y
		and a68
		asl
		asl
		sta a61
		lda a63
		bmi b1090
		inc a63
b1090		lda a63
		sta a64
		inc a66
		lda a66
		and #$1f
		sta a66
		bne b102f
		inc a1056
		dec a105f
		inc a67
		lda a67
		and #$03
		sta a67
		bne b10cc
		lda #$48
		sta a63
		ldy a60
		lda f1157,y
		sta a69
		lda f1167,y
		sta $d418    ;select filter mode and volume
		lda f115f,y
		sta a68
		inc a60
		lda a60
		and #$07
		sta a60
b10cc		jmp b102f

f10cf		!byte $c1,$b5,$01
f10d2		!byte $85,$c2,$6c,$32,$03,$a5,$ba,$d0
		!byte $03,$4c,$13,$f7,$c9,$03,$f0,$f9
		!byte $90,$5f,$a9,$61,$85,$b9,$a4,$b7
		!byte $d0,$03,$4c,$10,$f7,$20,$d5,$f3
f10f2		!byte $50,$02,$ca,$ca,$60,$a6,$a9,$d0
		!byte $33,$c6,$a8,$f0,$36,$30,$0d,$a5
		!byte $a7,$45,$ab,$85,$ab,$46,$a7,$66
		!byte $aa,$60,$c6,$a8,$a5,$a7,$f0,$67
f1112		!byte $f3,$f0,$02,$18,$60,$20,$1f,$f3
		!byte $8a,$48,$a5,$ba,$f0,$50,$c9,$03
		!byte $f0,$4c,$b0,$47,$c9,$02,$d0,$1d
		!byte $68,$20,$f2,$f2,$20,$83,$f4,$20
f1132		!byte $0a,$0a,$0a,$09,$81,$41,$41,$40
		!byte $81,$81,$80,$09,$41,$81,$41,$80
f1142		!byte $00,$00,$00,$00,$3d,$08,$05,$03
		!byte $de,$d4,$00,$00,$14,$66,$0c,$26
f1152		!byte $51,$41
f1154		!byte $ea,$35,$f9
f1157		!byte $78,$0f,$0f,$28,$18,$0f,$0f,$28
f115f		!byte $00,$00,$03,$02,$03,$03,$01,$00
f1167		!byte $17,$1c,$5f,$2c,$3f,$5f,$5f,$4c
f116f		!byte $01,$00,$02,$02,$03,$00,$02
		!byte $01,$00
