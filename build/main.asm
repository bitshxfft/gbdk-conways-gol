;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.1.6 #12539 (MINGW32)
;--------------------------------------------------------
	.module main
	.optsdcc -mgbz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _update_tile_position
	.globl _update_tile_sprite
	.globl _update_cursor_position
	.globl _update_cursor_sprite
	.globl _wait_vbls_done
	.globl _is_input_held
	.globl _was_input_released
	.globl _was_input_depressed
	.globl _update_input_state
	.globl _set_sprite_data
	.globl _set_bkg_tiles
	.globl _set_bkg_data
	.globl _wait_vbl_done
	.globl _joypad
	.globl _k_sprites
	.globl _k_cursor_sprite_index
	.globl _k_cursor_live_tile_index
	.globl _k_cursor_empty_tile_index
	.globl _k_live_tile_index
	.globl _k_empty_tile_index
	.globl _k_tile_was_alive_mask
	.globl _k_tile_is_alive_mask
	.globl _k_execution_state_active_mask
	.globl _k_background_tiles
	.globl _k_background_map
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_k_sprites::
	.ds 64
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;input.h:31: void update_input_state(struct input_state* is, uint8_t button_state)
;	---------------------------------
; Function update_input_state
; ---------------------------------
_update_input_state::
	add	sp, #-5
;input.h:34: is->previous_state = is->current_state;
	ldhl	sp,	#7
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl+), a
	pop	bc
	push	bc
	inc	bc
	ld	a, (bc)
	ld	(hl), a
	pop	de
	push	de
	ld	a, (hl)
	ld	(de), a
;input.h:37: is->current_state = ((button_state & J_A) == J_A) << btn_a;
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl)
	and	a, #0x10
	ld	e, a
	ld	d, #0x00
	ld	a, e
	sub	a, #0x10
	or	a, d
	ld	a, #0x01
	jr	Z, 00104$
	xor	a, a
00104$:
;input.h:38: is->current_state |= ((button_state & J_B) == J_B) << btn_b;
	ld	(bc), a
	ld	e, a
	ldhl	sp,	#3
	ld	a, (hl)
	and	a, #0x20
;	spillPairReg hl
;	spillPairReg hl
	ld	l, #0x00
	sub	a, #0x20
	or	a, l
	ld	a, #0x01
	jr	Z, 00106$
	xor	a, a
00106$:
	add	a, a
	or	a, e
	ld	e, a
	ld	(bc), a
;input.h:39: is->current_state |= ((button_state & J_UP) == J_UP) << btn_up;
	ldhl	sp,	#3
	ld	a, (hl)
	and	a, #0x04
;	spillPairReg hl
;	spillPairReg hl
	ld	l, #0x00
	sub	a, #0x04
	or	a, l
	ld	a, #0x01
	jr	Z, 00108$
	xor	a, a
00108$:
	add	a, a
	add	a, a
	or	a, e
	ld	e, a
	ld	(bc), a
;input.h:40: is->current_state |= ((button_state & J_DOWN) == J_DOWN) << btn_down;
	ldhl	sp,	#3
	ld	a, (hl)
	and	a, #0x08
;	spillPairReg hl
;	spillPairReg hl
	ld	l, #0x00
	sub	a, #0x08
	or	a, l
	ld	a, #0x01
	jr	Z, 00110$
	xor	a, a
00110$:
	add	a, a
	add	a, a
	add	a, a
	or	a, e
	ld	e, a
	ld	(bc), a
;input.h:41: is->current_state |= ((button_state & J_LEFT) == J_LEFT) << btn_left;
	ldhl	sp,	#3
	ld	a, (hl)
	and	a, #0x02
;	spillPairReg hl
;	spillPairReg hl
	ld	l, #0x00
	sub	a, #0x02
	or	a, l
	ld	a, #0x01
	jr	Z, 00112$
	xor	a, a
00112$:
	swap	a
	and	a, #0xf0
	or	a, e
	ld	e, a
	ld	(bc), a
;input.h:42: is->current_state |= ((button_state & J_RIGHT) == J_RIGHT) << btn_right;
	ldhl	sp,	#3
	ld	a, (hl)
	and	a, #0x01
;	spillPairReg hl
;	spillPairReg hl
	ld	l, #0x00
	dec	a
	or	a, l
	ld	a, #0x01
	jr	Z, 00114$
	xor	a, a
00114$:
	swap	a
	rlca
	and	a, #0xe0
	or	a, e
	ld	e, a
	ld	(bc), a
;input.h:43: is->current_state |= ((button_state & J_START) == J_START) << btn_start;
	ldhl	sp,	#3
	ld	a, (hl)
	and	a, #0x80
;	spillPairReg hl
;	spillPairReg hl
	ld	l, #0x00
	sub	a, #0x80
	or	a, l
	ld	a, #0x01
	jr	Z, 00116$
	xor	a, a
00116$:
	rrca
	rrca
	and	a, #0xc0
	or	a, e
	ld	e, a
	ld	(bc), a
;input.h:44: is->current_state |= ((button_state & J_SELECT) == J_SELECT) << btn_select;
	ldhl	sp,	#3
	ld	a, (hl)
	and	a, #0x40
;	spillPairReg hl
;	spillPairReg hl
	ld	l, #0x00
	sub	a, #0x40
	or	a, l
	ld	a, #0x01
	jr	Z, 00118$
	xor	a, a
00118$:
	rrca
	and	a, #0x80
	or	a, e
	ld	d, a
	ld	(bc), a
;input.h:47: is->held_buttons = is->previous_state & is->current_state;
	pop	bc
	push	bc
	inc	bc
	inc	bc
	ldhl	sp,	#2
;input.h:50: is->depressed_buttons = (is->current_state ^ is->held_buttons);
;input.h:53: is->released_buttons = (is->previous_state ^ is->held_buttons);
	ld	a, (hl-)
	dec	hl
	and	a, d
	ld	e, a
	ld	(bc), a
	pop	bc
	push	bc
	inc	bc
	inc	bc
	inc	bc
	ld	a, d
	xor	a, e
	ld	(bc), a
	push	de
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	ldhl	sp,	#2
	ld	a, (hl)
	xor	a, e
	ld	(bc), a
;input.h:54: }
	add	sp, #5
	ret
_k_background_map:
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
_k_background_tiles:
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0x00	; 0
	.db #0x80	; 128
	.db #0x00	; 0
_SCREEN_MIN_X:
	.db #0x08	; 8
_SCREEN_MIN_Y:
	.db #0x10	; 16
_SCREEN_WIDTH:
	.db #0xa0	; 160
_SCREEN_HEIGHT:
	.db #0x90	; 144
_SPRITE_TILE_WIDTH:
	.db #0x08	; 8
_SPRITE_TILE_HEIGHT:
	.db #0x08	; 8
;input.h:58: uint8_t was_input_depressed(struct input_state* is, uint8_t button)
;	---------------------------------
; Function was_input_depressed
; ---------------------------------
_was_input_depressed::
;input.h:60: return is->depressed_buttons & (1 << button);
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	inc	bc
	inc	bc
	inc	bc
	ld	a, (bc)
	ld	c, (hl)
	ld	b, #0x01
	inc	c
	jr	00104$
00103$:
	sla	b
00104$:
	dec	c
	jr	NZ,00103$
	and	a, b
	ld	e, a
;input.h:61: }
	ret
;input.h:63: uint8_t was_input_released(struct input_state* is, uint8_t button)
;	---------------------------------
; Function was_input_released
; ---------------------------------
_was_input_released::
;input.h:65: return is->released_buttons & (1 << button);
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0004
	add	hl, bc
	ld	c, (hl)
	ldhl	sp,	#4
	ld	b, (hl)
	ld	a, #0x01
	inc	b
	jr	00104$
00103$:
	add	a, a
00104$:
	dec	b
	jr	NZ,00103$
	and	a, c
	ld	e, a
;input.h:66: }
	ret
;input.h:68: uint8_t is_input_held(struct input_state* is, uint8_t button)
;	---------------------------------
; Function is_input_held
; ---------------------------------
_is_input_held::
;input.h:70: return is->held_buttons & (1 << button);
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	inc	bc
	inc	bc
	ld	a, (bc)
	ld	c, (hl)
	ld	b, #0x01
	inc	c
	jr	00104$
00103$:
	sla	b
00104$:
	dec	c
	jr	NZ,00103$
	and	a, b
	ld	e, a
;input.h:71: }
	ret
;utility.h:6: void wait_vbls_done(uint8_t num_loops)
;	---------------------------------
; Function wait_vbls_done
; ---------------------------------
_wait_vbls_done::
;utility.h:8: for (uint8_t loop_counter = 0; loop_counter < num_loops; ++loop_counter)
	ld	c, #0x00
00103$:
	ld	a, c
	ldhl	sp,	#2
	sub	a, (hl)
	ret	NC
;utility.h:10: wait_vbl_done();
	call	_wait_vbl_done
;utility.h:8: for (uint8_t loop_counter = 0; loop_counter < num_loops; ++loop_counter)
	inc	c
;utility.h:12: }
	jr	00103$
;main.c:55: void update_cursor_sprite(uint8_t tile_index)
;	---------------------------------
; Function update_cursor_sprite
; ---------------------------------
_update_cursor_sprite::
;main.c:57: set_sprite_tile(k_cursor_sprite_index, tile_index);
	ldhl	sp,	#2
	ld	c, (hl)
	ld	hl, #_k_cursor_sprite_index
;c:/gameboy-dev/gbdk/include/gb/gb.h:1447: shadow_OAM[nb].tile=tile;
	ld	l, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	ld	de, #_shadow_OAM
	add	hl, de
	inc	hl
	inc	hl
	ld	(hl), c
;main.c:57: set_sprite_tile(k_cursor_sprite_index, tile_index);
;main.c:58: }
	ret
_k_execution_state_active_mask:
	.db #0x02	; 2
_k_tile_is_alive_mask:
	.db #0x01	; 1
_k_tile_was_alive_mask:
	.db #0x02	; 2
_k_empty_tile_index:
	.db #0x00	; 0
_k_live_tile_index:
	.db #0x01	; 1
_k_cursor_empty_tile_index:
	.db #0x02	; 2
_k_cursor_live_tile_index:
	.db #0x03	; 3
_k_cursor_sprite_index:
	.db #0x00	; 0
;main.c:60: void update_cursor_position(uint8_t tile_x, uint8_t tile_y)
;	---------------------------------
; Function update_cursor_position
; ---------------------------------
_update_cursor_position::
;main.c:64: SCREEN_MIN_Y + (tile_y * SPRITE_TILE_HEIGHT));
	ld	a, (#_SPRITE_TILE_HEIGHT)
	push	af
	inc	sp
	ldhl	sp,	#4
	ld	a, (hl)
	push	af
	inc	sp
	call	__muluchar
	pop	hl
	ld	a, (#_SCREEN_MIN_Y)
	add	a, e
	ld	b, a
;main.c:63: SCREEN_MIN_X + (tile_x * SPRITE_TILE_WIDTH),
	ld	a, (#_SPRITE_TILE_WIDTH)
	push	bc
	push	af
	inc	sp
	ldhl	sp,	#5
	ld	a, (hl)
	push	af
	inc	sp
	call	__muluchar
	pop	hl
	pop	bc
	ld	a, (#_SCREEN_MIN_X)
	add	a, e
	ld	hl, #_k_cursor_sprite_index
;main.c:64: SCREEN_MIN_Y + (tile_y * SPRITE_TILE_HEIGHT));
;c:/gameboy-dev/gbdk/include/gb/gb.h:1520: OAM_item_t * itm = &shadow_OAM[nb];
	ld	l, (hl)
	ld	c, a
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	ld	de, #_shadow_OAM
	add	hl, de
;c:/gameboy-dev/gbdk/include/gb/gb.h:1521: itm->y=y, itm->x=x;
	ld	a, b
	ld	(hl+), a
	ld	(hl), c
;main.c:64: SCREEN_MIN_Y + (tile_y * SPRITE_TILE_HEIGHT));
;main.c:65: }
	ret
;main.c:67: void update_tile_sprite(uint8_t sprite_index, uint8_t tile_index)
;	---------------------------------
; Function update_tile_sprite
; ---------------------------------
_update_tile_sprite::
;main.c:69: set_sprite_tile(sprite_index, tile_index);
	ldhl	sp,	#3
	ld	a, (hl-)
	ld	c, a
;c:/gameboy-dev/gbdk/include/gb/gb.h:1447: shadow_OAM[nb].tile=tile;
	ld	l, (hl)
	ld	de, #_shadow_OAM+0
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	inc	hl
	inc	hl
	ld	(hl), c
;main.c:69: set_sprite_tile(sprite_index, tile_index);
;main.c:70: }
	ret
;main.c:72: void update_tile_position(uint8_t tile_index, uint8_t tile_x, uint8_t tile_y)
;	---------------------------------
; Function update_tile_position
; ---------------------------------
_update_tile_position::
;main.c:76: SCREEN_MIN_Y + (tile_y * SPRITE_TILE_HEIGHT));
	ld	a, (#_SPRITE_TILE_HEIGHT)
	push	af
	inc	sp
	ldhl	sp,	#5
	ld	a, (hl)
	push	af
	inc	sp
	call	__muluchar
	pop	hl
	ld	a, (#_SCREEN_MIN_Y)
	add	a, e
	ld	b, a
;main.c:75: SCREEN_MIN_X + (tile_x * SPRITE_TILE_WIDTH),
	ld	a, (#_SPRITE_TILE_WIDTH)
	push	bc
	push	af
	inc	sp
	ldhl	sp,	#6
	ld	a, (hl)
	push	af
	inc	sp
	call	__muluchar
	pop	hl
	pop	bc
	ld	a, (#_SCREEN_MIN_X)
	add	a, e
	ldhl	sp,	#2
;main.c:76: SCREEN_MIN_Y + (tile_y * SPRITE_TILE_HEIGHT));
;c:/gameboy-dev/gbdk/include/gb/gb.h:1520: OAM_item_t * itm = &shadow_OAM[nb];
	ld	l, (hl)
	ld	c, a
;	spillPairReg hl
;	spillPairReg hl
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	add	hl, hl
	add	hl, hl
	ld	de, #_shadow_OAM
	add	hl, de
;c:/gameboy-dev/gbdk/include/gb/gb.h:1521: itm->y=y, itm->x=x;
	ld	a, b
	ld	(hl+), a
	ld	(hl), c
;main.c:76: SCREEN_MIN_Y + (tile_y * SPRITE_TILE_HEIGHT));
;main.c:77: }
	ret
;main.c:81: int main()
;	---------------------------------
; Function main
; ---------------------------------
_main::
	ld	hl, #-805
	add	hl, sp
	ld	sp, hl
;main.c:85: input_state.previous_state = 0x00;
	ldhl	sp,	#0
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
;main.c:86: input_state.current_state = 0x00;
	ldhl	sp,	#0
	ld	a, l
	ld	d, h
	ld	hl, #766
	add	hl, sp
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
;main.c:87: input_state.held_buttons = 0x00;
	ld	a, (hl-)
	ld	b, a
	inc	bc
	xor	a, a
	ld	(bc), a
	ld	a, (hl+)
	ld	c, a
;main.c:88: input_state.depressed_buttons = 0x00;
	ld	a, (hl-)
	ld	b, a
	inc	bc
	inc	bc
	xor	a, a
	ld	(bc), a
	ld	a, (hl+)
	ld	c, a
;main.c:89: input_state.released_buttons = 0x00;
	ld	a, (hl-)
	ld	b, a
	inc	bc
	inc	bc
	inc	bc
	xor	a, a
	ld	(bc), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
;main.c:92: uint8_t execution_state = 0x00;
	ld	hl, #801
	add	hl, sp
	ld	(hl), #0x00
;main.c:95: uint8_t cursor_tile_x = 10;
	ld	hl, #768
	add	hl, sp
;main.c:96: uint8_t cursor_tile_y = 9;
	ld	a, #0x0a
	ld	(hl+), a
	ld	(hl), #0x09
;main.c:104: uint8_t next_available_sprite_index = 0;
	ld	hl, #802
	add	hl, sp
	ld	(hl), #0x00
;main.c:106: for (uint8_t i = 0; i < 39; ++i)
	ld	hl, #725
	add	hl, sp
	ld	a, l
	ld	d, h
	ld	hl, #770
	add	hl, sp
	ld	(hl+), a
	ld	(hl), d
	ld	e, #0x00
00173$:
	ld	a, e
	sub	a, #0x27
	jr	NC, 00101$
;main.c:108: available_sprites[i] = i + 1;
	push	de
	ld	d, #0x00
	ld	hl, #772
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	ld	d, e
	inc	d
	ld	a, d
	ld	(bc), a
;main.c:109: update_tile_sprite(i + 1, k_live_tile_index);
	ld	a, (#_k_live_tile_index)
	push	de
	push	af
	inc	sp
	push	de
	inc	sp
	call	_update_tile_sprite
	pop	hl
	pop	de
;main.c:110: update_tile_position(i + 1, 0, 19);
	push	de
	ld	hl, #0x1300
	push	hl
	push	de
	inc	sp
	call	_update_tile_position
	add	sp, #3
	pop	de
;main.c:106: for (uint8_t i = 0; i < 39; ++i)
	inc	e
	jr	00173$
00101$:
;main.c:113: for (uint8_t x = 0; x < 20; ++x)
	ld	hl, #764
	add	hl, sp
	ld	a, l
	ld	d, h
	ld	hl, #793
	add	hl, sp
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
	ldhl	sp,	#5
	ld	a, l
	ld	d, h
	ld	hl, #772
	add	hl, sp
	ld	(hl+), a
	ld	(hl), d
	ld	hl, #803
	add	hl, sp
	ld	(hl), #0x00
00179$:
	ld	hl, #803
	add	hl, sp
	ld	a, (hl)
	sub	a, #0x14
	jp	NC, 00103$
;main.c:115: for (uint8_t y = 0; y < 18; ++y)
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	ld	c, l
	ld	b, h
	ld	hl, #772
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, #799
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #798
	add	hl, sp
	ld	(hl), a
	ld	hl, #804
	add	hl, sp
	ld	(hl), #0x00
00176$:
	ld	hl, #804
	add	hl, sp
	ld	a, (hl)
	sub	a, #0x12
	jr	NC, 00180$
;main.c:118: tile_data.sprite_index = 0x00;
	ld	hl, #764
	add	hl, sp
	ld	a, l
	ld	d, h
	ld	hl, #799
	add	hl, sp
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
;main.c:119: tile_data.tile_flags = 0x00;
	ld	hl, #793
	add	hl, sp
	ld	a, (hl+)
	ld	c, a
;main.c:120: board[x][y] = tile_data;
	ld	a, (hl+)
	ld	b, a
	inc	bc
	xor	a, a
	ld	(bc), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #804
	add	hl, sp
	ld	a, (hl)
	add	a, a
	ld	e, a
	ld	d, #0x00
	ld	hl, #797
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, #0x0002
	push	hl
	push	bc
	push	de
	call	___memcpy
	add	sp, #6
;main.c:115: for (uint8_t y = 0; y < 18; ++y)
	ld	hl, #804
	add	hl, sp
	inc	(hl)
	jr	00176$
00180$:
;main.c:113: for (uint8_t x = 0; x < 20; ++x)
	ld	hl, #803
	add	hl, sp
	inc	(hl)
	jp	00179$
00103$:
;main.c:125: set_sprite_data(0, 3, k_sprites);
	ld	de, #_k_sprites
	push	de
	ld	hl, #0x300
	push	hl
	call	_set_sprite_data
	add	sp, #4
;main.c:126: set_bkg_data(0, 2, k_background_tiles);
	ld	de, #_k_background_tiles
	push	de
	ld	hl, #0x200
	push	hl
	call	_set_bkg_data
	add	sp, #4
;main.c:129: set_bkg_tiles(0, 0, 20, 18, k_background_map);
	ld	de, #_k_background_map
	push	de
	ld	hl, #0x1214
	push	hl
	xor	a, a
	rrca
	push	af
	call	_set_bkg_tiles
	add	sp, #6
;main.c:132: update_cursor_sprite(k_cursor_empty_tile_index);
	ld	a, (#_k_cursor_empty_tile_index)
	push	af
	inc	sp
	call	_update_cursor_sprite
	inc	sp
;main.c:133: update_cursor_position(cursor_tile_x, cursor_tile_y);
	ld	hl, #0x90a
	push	hl
	call	_update_cursor_position
	pop	hl
;main.c:135: SHOW_BKG;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x01
	ldh	(_LCDC_REG + 0), a
;main.c:136: SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;main.c:137: DISPLAY_ON;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;main.c:139: while (1)
00170$:
;main.c:142: update_input_state(&input_state, joypad());
	call	_joypad
	ld	a, e
	ld	hl, #766
	add	hl, sp
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	push	af
	inc	sp
	push	bc
	call	_update_input_state
	add	sp, #3
;main.c:145: if (was_input_released(&input_state, btn_start))
	ld	hl, #766
	add	hl, sp
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, #0x06
	push	af
	inc	sp
	push	bc
	call	_was_input_released
	add	sp, #3
	ld	a, e
	or	a, a
	jr	Z, 00105$
;main.c:147: execution_state ^= k_execution_state_active_mask;
	ld	hl, #_k_execution_state_active_mask
	ld	c, (hl)
	ld	hl, #801
	add	hl, sp
	ld	a, (hl)
	xor	a, c
	ld	(hl), a
;main.c:150: (execution_state & k_execution_state_active_mask) == k_execution_state_active_mask
	ld	a, (hl)
	and	a, c
	sub	a, c
	jr	NZ, 00195$
;main.c:151: ? k_empty_tile_index
	ld	a, (#_k_empty_tile_index)
	jr	00196$
00195$:
;main.c:152: : k_cursor_empty_tile_index);
	ld	a, (#_k_cursor_empty_tile_index)
00196$:
	push	af
	inc	sp
	call	_update_cursor_sprite
	inc	sp
00105$:
;main.c:156: if ((execution_state & k_execution_state_active_mask) == k_execution_state_active_mask)
	ld	hl, #_k_execution_state_active_mask
	ld	c, (hl)
	ld	hl, #801
	add	hl, sp
	ld	a, (hl)
	and	a, c
	sub	a, c
	jp	NZ,00167$
;main.c:158: for (uint8_t x = 0; x < 20; ++x)
	ld	hl, #772
	add	hl, sp
	ld	a, (hl)
	ld	hl, #797
	add	hl, sp
	ld	(hl), a
	ld	hl, #773
	add	hl, sp
	ld	a, (hl)
	ld	hl, #798
	add	hl, sp
	ld	(hl), a
	ld	hl, #804
	add	hl, sp
	ld	(hl), #0x00
00185$:
	ld	hl, #804
	add	hl, sp
	ld	a, (hl)
	sub	a, #0x14
	jr	NC, 00107$
;main.c:160: for (uint8_t y = 0; y < 18; ++y)
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	ld	c, l
	ld	b, h
	ld	hl, #797
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	e, #0x00
00182$:
;main.c:162: uint8_t tile_flags = board[x][y].tile_flags;
	ld	a,e
	cp	a,#0x12
	jr	NC, 00186$
	add	a, a
	ld	hl, #803
	add	hl, sp
	ld	(hl), a
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, #801
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #800
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
;	spillPairReg hl
;	spillPairReg hl
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	inc	hl
	ld	d, (hl)
;main.c:165: tile_flags &= ~k_tile_was_alive_mask;
	push	hl
	ld	a, (#_k_tile_was_alive_mask)
	pop	hl
	cpl
	and	a, d
	ld	d, a
;main.c:168: tile_flags |= ((tile_flags & k_tile_is_alive_mask) != 0x00) << tile_was_alive;
	push	hl
	ld	a, (#_k_tile_is_alive_mask)
	pop	hl
	and	a, d
	sub	a,#0x01
	ld	a, #0x00
	rla
	xor	a, #0x01
	add	a, a
	or	a, d
;main.c:171: board[x][y].tile_flags = tile_flags;
	ld	(hl), a
;main.c:160: for (uint8_t y = 0; y < 18; ++y)
	inc	e
	jr	00182$
00186$:
;main.c:158: for (uint8_t x = 0; x < 20; ++x)
	ld	hl, #804
	add	hl, sp
	inc	(hl)
	jr	00185$
00107$:
;main.c:176: for (uint8_t x = 0; x < 20; ++x)
	ld	hl, #772
	add	hl, sp
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
	ld	hl, #770
	add	hl, sp
	ld	a, (hl)
	ld	hl, #776
	add	hl, sp
	ld	(hl), a
	ld	hl, #771
	add	hl, sp
	ld	a, (hl)
	ld	hl, #777
	add	hl, sp
	ld	(hl), a
	ld	hl, #770
	add	hl, sp
	ld	a, (hl)
	ld	hl, #778
	add	hl, sp
	ld	(hl), a
	ld	hl, #771
	add	hl, sp
	ld	a, (hl)
	ld	hl, #779
	add	hl, sp
	ld	(hl), a
	ld	hl, #803
	add	hl, sp
	ld	(hl), #0x00
00191$:
	ld	hl, #803
	add	hl, sp
	ld	a, (hl)
	sub	a, #0x14
	jp	NC, 00168$
;main.c:178: for (uint8_t y = 0; y < 18; ++y)
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	ld	c, l
	ld	b, h
	ld	hl, #774
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, #782
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #781
	add	hl, sp
	ld	(hl), a
	ld	hl, #803
	add	hl, sp
	ld	a, (hl)
	sub	a, #0x13
	ld	a, #0x00
	rla
	ld	hl, #782
	add	hl, sp
	ld	(hl), a
	ld	hl, #804
	add	hl, sp
	ld	(hl), #0x00
00188$:
	ld	hl, #804
	add	hl, sp
	ld	a, (hl)
	sub	a, #0x12
	jp	NC, 00192$
;main.c:180: uint8_t tile_flags = board[x][y].tile_flags;
	ld	a, (hl)
	add	a, a
	ld	hl, #783
	add	hl, sp
	ld	(hl-), a
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	inc	hl
	ld	d, a
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, #786
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #785
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ld	hl, #788
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #787
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	(hl), a
;main.c:181: uint8_t sprite_index = board[x][y].sprite_index;
	ld	hl,#0x310
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	hl, #789
	add	hl, sp
;main.c:182: uint8_t neighbour_count = 0;
	ld	(hl+), a
	ld	(hl), #0x00
;main.c:165: tile_flags &= ~k_tile_was_alive_mask;
	ld	a, (#_k_tile_was_alive_mask)
	ld	hl, #791
	add	hl, sp
	ld	(hl), a
;main.c:186: && (board[x][y - 1].tile_flags & k_tile_was_alive_mask) != 0x00)
	ld	hl, #804
	add	hl, sp
	ld	a, (hl)
	ld	hl, #800
	add	hl, sp
	ld	(hl), a
	ld	a, (hl)
	dec	a
	add	a, a
	ld	hl, #792
	add	hl, sp
	ld	(hl), a
;main.c:185: if (y > 0
	ld	hl, #804
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00109$
;main.c:186: && (board[x][y - 1].tile_flags & k_tile_was_alive_mask) != 0x00)
	ld	hl,#0x30c
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #792
	add	hl, sp
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, #798
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #797
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ld	hl, #800
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #799
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	hl, #791
	add	hl, sp
	and	a,(hl)
	jr	Z, 00109$
;main.c:188: neighbour_count += 1;
	dec	hl
	ld	(hl), #0x01
00109$:
;main.c:194: && (board[x + 1][y - 1].tile_flags & k_tile_was_alive_mask) != 0x00)
	ld	hl, #803
	add	hl, sp
	ld	a, (hl)
	ld	hl, #793
	add	hl, sp
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ld	hl, #800
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #799
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	push	hl
	ld	a, l
	ld	hl, #797
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #796
	add	hl, sp
	ld	(hl), a
	ld	hl,#0x306
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #795
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, #799
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #798
	add	hl, sp
	ld	(hl), a
;main.c:193: && y > 0
	ld	hl, #782
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00112$
	ld	hl, #804
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00112$
;main.c:194: && (board[x + 1][y - 1].tile_flags & k_tile_was_alive_mask) != 0x00)
	ld	hl,#0x31d
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #792
	add	hl, sp
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, #797
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #796
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	ld	a, (bc)
	ld	hl, #791
	add	hl, sp
	and	a,(hl)
	jr	Z, 00112$
;main.c:196: neighbour_count += 1;
	dec	hl
	inc	(hl)
	ld	a, (hl)
00112$:
;main.c:201: && (board[x + 1][y].tile_flags & k_tile_was_alive_mask) != 0x00)
	ld	hl, #782
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00116$
	ld	hl,#0x31d
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #783
	add	hl, sp
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	inc	hl
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	hl, #791
	add	hl, sp
	and	a,(hl)
	jr	Z, 00116$
;main.c:203: neighbour_count += 1;
	dec	hl
	inc	(hl)
	ld	a, (hl)
00116$:
;main.c:209: && (board[x + 1][y + 1].tile_flags & k_tile_was_alive_mask) != 0x00)
	ld	hl, #804
	add	hl, sp
	ld	a, (hl)
	sub	a, #0x11
	ld	a, #0x00
	rla
	ld	hl, #795
	add	hl, sp
	ld	(hl), a
	ld	hl, #800
	add	hl, sp
	ld	a, (hl)
	inc	a
	add	a, a
	ld	hl, #796
	add	hl, sp
	ld	(hl), a
;main.c:208: && y < 17
	ld	hl, #782
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00119$
;main.c:209: && (board[x + 1][y + 1].tile_flags & k_tile_was_alive_mask) != 0x00)
	ld	hl, #795
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00119$
	ld	hl,#0x31d
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, #801
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #800
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	ld	a, (bc)
	ld	hl, #791
	add	hl, sp
	and	a,(hl)
	jr	Z, 00119$
;main.c:211: neighbour_count += 1;
	dec	hl
	inc	(hl)
	ld	a, (hl)
00119$:
;main.c:216: && (board[x][y + 1].tile_flags & k_tile_was_alive_mask) != 0x00)
	ld	hl, #795
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00123$
	ld	hl,#0x30c
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #796
	add	hl, sp
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, #799
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #798
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ld	hl, #801
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #800
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	hl, #791
	add	hl, sp
	and	a,(hl)
	jr	Z, 00123$
;main.c:218: neighbour_count += 1;
	dec	hl
	inc	(hl)
	ld	a, (hl)
00123$:
;main.c:224: && (board[x - 1][y + 1].tile_flags & k_tile_was_alive_mask) != 0x00)
	ld	hl,#0x319
	add	hl,sp
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	dec	bc
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	ld	c, l
	ld	b, h
	ld	hl, #774
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, #801
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #800
	add	hl, sp
	ld	(hl), a
;main.c:222: if (x > 0
	ld	hl, #803
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00126$
;main.c:224: && (board[x - 1][y + 1].tile_flags & k_tile_was_alive_mask) != 0x00)
	ld	hl, #795
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00126$
	inc	hl
	ld	e, (hl)
	ld	d, #0x00
	ld	hl, #799
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, #799
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #798
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	ld	a, (bc)
	ld	hl, #791
	add	hl, sp
	and	a,(hl)
	jr	Z, 00126$
;main.c:226: neighbour_count += 1;
	dec	hl
	inc	(hl)
	ld	a, (hl)
00126$:
;main.c:230: if (x > 0
	ld	hl, #803
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00130$
;main.c:231: && (board[x - 1][y].tile_flags & k_tile_was_alive_mask) != 0x00)
	ld	hl, #783
	add	hl, sp
	ld	e, (hl)
	ld	d, #0x00
	ld	hl, #799
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, #799
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #798
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ld	hl, #797
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #796
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	hl, #791
	add	hl, sp
	and	a,(hl)
	jr	Z, 00130$
;main.c:233: neighbour_count += 1;
	dec	hl
	inc	(hl)
	ld	a, (hl)
00130$:
;main.c:237: if (x > 0
	ld	hl, #803
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00133$
;main.c:238: && y > 0
	inc	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00133$
;main.c:239: && (board[x - 1][y - 1].tile_flags & k_tile_was_alive_mask) != 0x00)
	ld	hl, #792
	add	hl, sp
	ld	e, (hl)
	ld	d, #0x00
	ld	hl, #799
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, #799
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #798
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	ld	a, (bc)
	ld	hl, #791
	add	hl, sp
	and	a,(hl)
	jr	Z, 00133$
;main.c:241: neighbour_count += 1;
	dec	hl
	inc	(hl)
	ld	a, (hl)
00133$:
;main.c:168: tile_flags |= ((tile_flags & k_tile_is_alive_mask) != 0x00) << tile_was_alive;
	ld	a, (#_k_tile_is_alive_mask)
	ld	hl, #800
	add	hl, sp
	ld	(hl), a
;main.c:245: uint8_t is_alive = (tile_flags & k_tile_is_alive_mask) != 0x00;
	ld	hl, #788
	add	hl, sp
	ld	a, (hl)
	ld	hl, #800
	add	hl, sp
	and	a, (hl)
	sub	a,#0x01
	ld	a, #0x00
	rla
	xor	a, #0x01
;main.c:246: uint8_t come_to_life = !is_alive && neighbour_count == 3;
	ld	b, a
	or	a, a
	jr	NZ, 00197$
	ld	hl, #790
	add	hl, sp
	ld	a, (hl)
	sub	a, #0x03
	jr	Z, 00198$
00197$:
	ld	c, #0x00
	jr	00199$
00198$:
	ld	c, #0x01
00199$:
;main.c:251: uint8_t remain_alive = is_alive && neighbour_count >= 2 && neighbour_count <= 3;
	ld	a, b
	or	a, a
	jr	Z, 00200$
	ld	hl, #790
	add	hl, sp
	ld	a, (hl)
	sub	a, #0x02
	jr	C, 00200$
	ld	a, #0x03
	sub	a, (hl)
	jr	NC, 00201$
00200$:
	ld	e, #0x00
	jr	00202$
00201$:
	ld	e, #0x01
00202$:
;main.c:254: tile_flags &= ~k_tile_is_alive_mask;
	ld	hl, #800
	add	hl, sp
	ld	a, (hl-)
	dec	hl
	cpl
	ld	(hl), a
	ld	hl, #788
	add	hl, sp
	ld	a, (hl)
	ld	hl, #798
	add	hl, sp
	and	a, (hl)
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
;main.c:255: tile_flags |= ((come_to_life | remain_alive) != 0x00) << tile_is_alive;
	ld	a, c
	or	a, e
	sub	a,#0x01
	ld	a, #0x00
	rla
	xor	a, #0x01
	or	a, l
	ld	hl, #799
	add	hl, sp
	ld	(hl), a
;main.c:258: is_alive = (tile_flags & k_tile_is_alive_mask) != 0x00;
	ld	a, (hl+)
	and	a, (hl)
	sub	a,#0x01
	ld	a, #0x00
	rla
	xor	a, #0x01
;main.c:259: uint8_t was_alive = (tile_flags & k_tile_was_alive_mask) != 0x00;
	ld	(hl-), a
	ld	a, (hl)
	ld	hl, #791
	add	hl, sp
	and	a, (hl)
	sub	a,#0x01
	ld	a, #0x00
	rla
	xor	a, #0x01
	ld	hl, #796
	add	hl, sp
	ld	(hl), a
	ld	a, (hl+)
;main.c:262: if (!was_alive && is_alive)
	ld	(hl-), a
	ld	a, (hl)
	or	a, a
	jr	NZ, 00143$
	ld	hl, #800
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00143$
;main.c:265: if (next_available_sprite_index < 39)
	inc	hl
	inc	hl
	ld	a, (hl)
	sub	a, #0x27
	jr	NC, 00137$
;main.c:268: sprite_index = available_sprites[next_available_sprite_index];
	ld	hl,#0x30a
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #802
	add	hl, sp
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, #799
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #798
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	hl, #789
	add	hl, sp
	ld	(hl), a
;main.c:269: next_available_sprite_index++;
	ld	hl, #802
	add	hl, sp
	inc	(hl)
;main.c:272: update_tile_position(sprite_index, x, y);
	inc	hl
	inc	hl
	ld	a, (hl-)
	ld	d, a
	ld	e, (hl)
	push	de
	ld	hl, #791
	add	hl, sp
	ld	a, (hl)
	push	af
	inc	sp
	call	_update_tile_position
	add	sp, #3
	jr	00144$
00137$:
;main.c:277: tile_flags &= ~k_tile_is_alive_mask;
	ld	hl, #799
	add	hl, sp
	ld	a, (hl-)
	and	a, (hl)
	inc	hl
	ld	(hl), a
	jr	00144$
00143$:
;main.c:280: else if (was_alive && !is_alive)
	ld	hl, #797
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00144$
	ld	hl, #800
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	NZ, 00144$
;main.c:283: update_tile_position(sprite_index, 0, 19);
	ld	a, #0x13
	push	af
	inc	sp
	xor	a, a
	push	af
	inc	sp
	ld	hl, #791
	add	hl, sp
	ld	a, (hl)
	push	af
	inc	sp
	call	_update_tile_position
	add	sp, #3
;main.c:286: next_available_sprite_index--;
	ld	hl, #802
	add	hl, sp
	dec	(hl)
;main.c:287: available_sprites[next_available_sprite_index] = sprite_index;
	ld	hl,#0x308
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #802
	add	hl, sp
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, #789
	add	hl, sp
	ld	a, (hl)
	ld	(bc), a
;main.c:290: sprite_index = 0x00;
	ld	(hl), #0x00
00144$:
;main.c:293: board[x][y].tile_flags = tile_flags;
	ld	hl,#0x312
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #799
	add	hl, sp
	ld	a, (hl)
	ld	(de), a
;main.c:294: board[x][y].sprite_index = sprite_index;
	ld	hl,#0x310
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #789
	add	hl, sp
	ld	a, (hl)
	ld	(de), a
;main.c:178: for (uint8_t y = 0; y < 18; ++y)
	ld	hl, #804
	add	hl, sp
	inc	(hl)
	jp	00188$
00192$:
;main.c:176: for (uint8_t x = 0; x < 20; ++x)
	ld	hl, #803
	add	hl, sp
	inc	(hl)
	jp	00191$
00167$:
;main.c:307: if (was_input_depressed(&input_state, btn_up))
	ld	hl, #766
	add	hl, sp
	ld	a, (hl)
	ld	hl, #803
	add	hl, sp
	ld	(hl), a
	ld	hl, #767
	add	hl, sp
	ld	a, (hl)
	ld	hl, #804
	add	hl, sp
	ld	(hl-), a
	ld	a, #0x02
	push	af
	inc	sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	call	_was_input_depressed
	add	sp, #3
	ld	hl, #804
	add	hl, sp
	ld	(hl), e
;main.c:309: cursor_tile_y -= 1;
	ld	hl, #769
	add	hl, sp
	ld	a, (hl)
	ld	hl, #800
	add	hl, sp
	ld	(hl), a
;main.c:307: if (was_input_depressed(&input_state, btn_up))
	ld	hl, #804
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00157$
;main.c:309: cursor_tile_y -= 1;
	ld	hl, #800
	add	hl, sp
	ld	a, (hl)
	dec	a
	ld	hl, #769
	add	hl, sp
	ld	(hl), a
	jp	00158$
00157$:
;main.c:311: else if (was_input_depressed(&input_state, btn_down))
	ld	hl, #766
	add	hl, sp
	ld	a, (hl)
	ld	hl, #803
	add	hl, sp
	ld	(hl), a
	ld	hl, #767
	add	hl, sp
	ld	a, (hl)
	ld	hl, #804
	add	hl, sp
	ld	(hl-), a
	ld	a, #0x03
	push	af
	inc	sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	call	_was_input_depressed
	add	sp, #3
	ld	a, e
	or	a, a
	jr	Z, 00154$
;main.c:313: cursor_tile_y += 1;
	ld	hl, #800
	add	hl, sp
	ld	a, (hl)
	inc	a
	ld	hl, #769
	add	hl, sp
	ld	(hl), a
	jr	00158$
00154$:
;main.c:315: else if (was_input_depressed(&input_state, btn_left))
	ld	hl, #766
	add	hl, sp
	ld	a, (hl)
	ld	hl, #803
	add	hl, sp
	ld	(hl), a
	ld	hl, #767
	add	hl, sp
	ld	a, (hl)
	ld	hl, #804
	add	hl, sp
	ld	(hl-), a
	ld	a, #0x04
	push	af
	inc	sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	call	_was_input_depressed
	add	sp, #3
;main.c:317: cursor_tile_x -= 1;
	ld	hl, #768
	add	hl, sp
	ld	a, (hl)
	ld	hl, #800
	add	hl, sp
	ld	(hl), a
;main.c:315: else if (was_input_depressed(&input_state, btn_left))
	ld	a, e
	or	a, a
	jr	Z, 00151$
;main.c:317: cursor_tile_x -= 1;
	ld	a, (hl)
	dec	a
	ld	hl, #768
	add	hl, sp
	ld	(hl), a
	jr	00158$
00151$:
;main.c:319: else if (was_input_depressed(&input_state, btn_right))
	ld	hl, #766
	add	hl, sp
	ld	a, (hl)
	ld	hl, #803
	add	hl, sp
	ld	(hl), a
	ld	hl, #767
	add	hl, sp
	ld	a, (hl)
	ld	hl, #804
	add	hl, sp
	ld	(hl-), a
	ld	a, #0x05
	push	af
	inc	sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	call	_was_input_depressed
	add	sp, #3
	ld	a, e
	or	a, a
	jr	Z, 00158$
;main.c:321: cursor_tile_x += 1;
	ld	hl, #800
	add	hl, sp
	ld	a, (hl)
	inc	a
	ld	hl, #768
	add	hl, sp
	ld	(hl), a
00158$:
;main.c:326: ? 19
	ld	hl, #768
	add	hl, sp
	ld	a, (hl)
	inc	a
	jr	NZ, 00206$
	ld	hl, #803
	add	hl, sp
	ld	a, #0x13
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
	jr	00207$
00206$:
;main.c:328: ? 0
	ld	a, #0x13
	ld	hl, #768
	add	hl, sp
	sub	a, (hl)
	jr	NC, 00208$
	xor	a, a
	ld	hl, #803
	add	hl, sp
	ld	(hl+), a
	ld	(hl), a
	jr	00209$
00208$:
;main.c:329: : cursor_tile_x;
	ld	hl, #768
	add	hl, sp
	ld	a, (hl)
	ld	hl, #803
	add	hl, sp
	ld	(hl+), a
	ld	(hl), #0x00
00209$:
00207$:
	ld	hl, #803
	add	hl, sp
	ld	a, (hl)
	ld	hl, #768
	add	hl, sp
;main.c:333: ? 17
	ld	(hl+), a
	ld	a, (hl)
	inc	a
	jr	NZ, 00210$
	ld	hl, #803
	add	hl, sp
	ld	a, #0x11
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
	jr	00211$
00210$:
;main.c:335: ? 0
	ld	a, #0x11
	ld	hl, #769
	add	hl, sp
	sub	a, (hl)
	jr	NC, 00212$
	xor	a, a
	ld	hl, #803
	add	hl, sp
	ld	(hl+), a
	ld	(hl), a
	jr	00213$
00212$:
;main.c:336: : cursor_tile_y;
	ld	hl, #769
	add	hl, sp
	ld	a, (hl)
	ld	hl, #803
	add	hl, sp
	ld	(hl+), a
	ld	(hl), #0x00
00213$:
00211$:
	ld	hl, #803
	add	hl, sp
	ld	a, (hl)
	ld	hl, #769
	add	hl, sp
	ld	(hl), a
;main.c:338: update_cursor_position(cursor_tile_x, cursor_tile_y);
	ld	a, (hl-)
	ld	d, a
	ld	e, (hl)
	push	de
	call	_update_cursor_position
	pop	hl
;main.c:341: if (was_input_depressed(&input_state, btn_b))
	ld	hl, #766
	add	hl, sp
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, #0x01
	push	af
	inc	sp
	push	bc
	call	_was_input_depressed
	add	sp, #3
	ld	a, e
	or	a, a
	jp	Z, 00168$
;main.c:343: uint8_t tile_flags = board[cursor_tile_x][cursor_tile_y].tile_flags;
	ld	hl, #768
	add	hl, sp
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	ld	c, l
	ld	b, h
	ld	hl, #772
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, #769
	add	hl, sp
	ld	a, (hl)
	add	a, a
	ld	l, a
	ld	h, #0x00
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, #801
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #800
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ld	hl, #805
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #804
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
;main.c:344: uint8_t sprite_index = board[cursor_tile_x][cursor_tile_y].sprite_index;
	ld	hl,#0x31f
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	b, a
;main.c:345: uint8_t is_alive = tile_flags & k_tile_is_alive_mask;
	ld	a, (#_k_tile_is_alive_mask)
;main.c:347: if (!is_alive)
	and	a,c
	jr	NZ, 00162$
;main.c:349: if (next_available_sprite_index < 39)
	ld	hl, #802
	add	hl, sp
	ld	a, (hl)
	sub	a, #0x27
	jr	NC, 00163$
;main.c:352: sprite_index = available_sprites[next_available_sprite_index];
	ld	hl,#0x302
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #802
	add	hl, sp
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	b, a
;main.c:353: next_available_sprite_index++;
	ld	hl, #802
	add	hl, sp
	inc	(hl)
;main.c:356: update_tile_position(sprite_index, cursor_tile_x, cursor_tile_y);
	push	bc
	ld	hl, #771
	add	hl, sp
	ld	a, (hl-)
	ld	d, a
	ld	e, (hl)
	push	de
	push	bc
	inc	sp
	call	_update_tile_position
	add	sp, #3
	pop	bc
;main.c:359: tile_flags |= k_tile_is_alive_mask;
	ld	a, (#_k_tile_is_alive_mask)
	or	a, c
	ld	c, a
	jr	00163$
00162$:
;main.c:365: update_tile_position(sprite_index, 0, 19);
	push	bc
	ld	hl, #0x1300
	push	hl
	push	bc
	inc	sp
	call	_update_tile_position
	add	sp, #3
	pop	bc
;main.c:368: next_available_sprite_index--;
	ld	hl, #802
	add	hl, sp
	dec	(hl)
;main.c:369: available_sprites[next_available_sprite_index] = sprite_index;
	ld	hl,#0x302
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #802
	add	hl, sp
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, b
	ld	(de), a
;main.c:372: sprite_index = 0x00;
	ld	b, #0x00
;main.c:375: tile_flags &= ~k_tile_is_alive_mask;
	ld	a, (#_k_tile_is_alive_mask)
	cpl
	and	a, c
	ld	c, a
00163$:
;main.c:379: board[cursor_tile_x][cursor_tile_y].tile_flags = tile_flags;
	ld	hl, #803
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), c
;main.c:380: board[cursor_tile_x][cursor_tile_y].sprite_index = sprite_index;
	ld	hl, #799
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), b
00168$:
;main.c:385: wait_vbls_done(1);
	ld	a, #0x01
	push	af
	inc	sp
	call	_wait_vbls_done
	inc	sp
	jp	00170$
;main.c:387: }
	ld	hl, #805
	add	hl, sp
	ld	sp, hl
	ret
	.area _CODE
	.area _INITIALIZER
__xinit__k_sprites:
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x7f	; 127
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x3e	; 62
	.db #0x00	; 0
	.db #0x41	; 65	'A'
	.db #0x00	; 0
	.db #0x41	; 65	'A'
	.db #0x00	; 0
	.db #0x41	; 65	'A'
	.db #0x00	; 0
	.db #0x41	; 65	'A'
	.db #0x00	; 0
	.db #0x41	; 65	'A'
	.db #0x00	; 0
	.db #0x3e	; 62
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x41	; 65	'A'
	.db #0x7f	; 127
	.db #0x3e	; 62
	.db #0x7f	; 127
	.db #0x3e	; 62
	.db #0x7f	; 127
	.db #0x3e	; 62
	.db #0x7f	; 127
	.db #0x3e	; 62
	.db #0x7f	; 127
	.db #0x3e	; 62
	.db #0x7f	; 127
	.db #0x41	; 65	'A'
	.db #0x7f	; 127
	.area _CABS (ABS)
