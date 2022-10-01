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
	.globl _k_tile_sprite_index_mask
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
;main.c:38: void update_cursor_sprite(uint8_t tile_index)
;	---------------------------------
; Function update_cursor_sprite
; ---------------------------------
_update_cursor_sprite::
;main.c:40: set_sprite_tile(k_cursor_sprite_index, tile_index);
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
;main.c:40: set_sprite_tile(k_cursor_sprite_index, tile_index);
;main.c:41: }
	ret
_k_execution_state_active_mask:
	.db #0x01	; 1
_k_tile_sprite_index_mask:
	.db #0x3f	; 63
_k_tile_is_alive_mask:
	.db #0x40	; 64
_k_tile_was_alive_mask:
	.db #0x80	; 128
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
;main.c:43: void update_cursor_position(uint8_t tile_x, uint8_t tile_y)
;	---------------------------------
; Function update_cursor_position
; ---------------------------------
_update_cursor_position::
;main.c:47: SCREEN_MIN_Y + (tile_y * SPRITE_TILE_HEIGHT));
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
;main.c:46: SCREEN_MIN_X + (tile_x * SPRITE_TILE_WIDTH),
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
;main.c:47: SCREEN_MIN_Y + (tile_y * SPRITE_TILE_HEIGHT));
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
;main.c:47: SCREEN_MIN_Y + (tile_y * SPRITE_TILE_HEIGHT));
;main.c:48: }
	ret
;main.c:50: void update_tile_sprite(uint8_t sprite_index, uint8_t tile_index)
;	---------------------------------
; Function update_tile_sprite
; ---------------------------------
_update_tile_sprite::
;main.c:52: set_sprite_tile(sprite_index, tile_index);
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
;main.c:52: set_sprite_tile(sprite_index, tile_index);
;main.c:53: }
	ret
;main.c:55: void update_tile_position(uint8_t tile_index, uint8_t tile_x, uint8_t tile_y)
;	---------------------------------
; Function update_tile_position
; ---------------------------------
_update_tile_position::
;main.c:59: SCREEN_MIN_Y + (tile_y * SPRITE_TILE_HEIGHT));
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
;main.c:58: SCREEN_MIN_X + (tile_x * SPRITE_TILE_WIDTH),
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
;main.c:59: SCREEN_MIN_Y + (tile_y * SPRITE_TILE_HEIGHT));
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
;main.c:59: SCREEN_MIN_Y + (tile_y * SPRITE_TILE_HEIGHT));
;main.c:60: }
	ret
;main.c:64: int main()
;	---------------------------------
; Function main
; ---------------------------------
_main::
	ld	hl, #-439
	add	hl, sp
	ld	sp, hl
;main.c:68: input_state.previous_state = 0x00;
	ldhl	sp,	#2
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
;main.c:69: input_state.current_state = 0x00;
	ldhl	sp,	#2
	ld	a, l
	ld	d, h
	ld	hl, #406
	add	hl, sp
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
;main.c:70: input_state.held_buttons = 0x00;
	ld	a, (hl-)
	ld	b, a
	inc	bc
	xor	a, a
	ld	(bc), a
	ld	a, (hl+)
	ld	c, a
;main.c:71: input_state.depressed_buttons = 0x00;
	ld	a, (hl-)
	ld	b, a
	inc	bc
	inc	bc
	xor	a, a
	ld	(bc), a
	ld	a, (hl+)
	ld	c, a
;main.c:72: input_state.released_buttons = 0x00;
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
;main.c:75: uint8_t execution_state = 0x00;
	ld	hl, #435
	add	hl, sp
	ld	(hl), #0x00
;main.c:78: uint8_t cursor_tile_x = 10;
	ld	hl, #408
	add	hl, sp
;main.c:79: uint8_t cursor_tile_y = 9;
	ld	a, #0x0a
	ld	(hl+), a
	ld	(hl), #0x09
;main.c:87: uint8_t next_available_sprite_index = 0;
	ld	hl, #436
	add	hl, sp
	ld	(hl), #0x00
;main.c:90: for (uint8_t i = 0; i < 39; ++i)
	ld	hl, #367
	add	hl, sp
	ld	a, l
	ld	d, h
	ld	hl, #410
	add	hl, sp
	ld	(hl+), a
	ld	(hl), d
	ld	e, #0x00
00177$:
	ld	a, e
	sub	a, #0x27
	jr	NC, 00101$
;main.c:92: available_sprites[i] = i + 1;
	push	de
	ld	d, #0x00
	ld	hl, #412
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
;main.c:93: update_tile_sprite(i + 1, k_live_tile_index);
	ld	a, (#_k_live_tile_index)
	push	de
	push	af
	inc	sp
	push	de
	inc	sp
	call	_update_tile_sprite
	pop	hl
	pop	de
;main.c:94: update_tile_position(i + 1, 0, 19);
	push	de
	ld	hl, #0x1300
	push	hl
	push	de
	inc	sp
	call	_update_tile_position
	add	sp, #3
	pop	de
;main.c:90: for (uint8_t i = 0; i < 39; ++i)
	inc	e
	jr	00177$
00101$:
;main.c:98: for (uint8_t x = 0; x < 20; ++x)
	ldhl	sp,	#7
	ld	a, l
	ld	d, h
	ld	hl, #412
	add	hl, sp
	ld	(hl+), a
	ld	(hl), d
	ld	hl, #438
	add	hl, sp
	ld	(hl), #0x00
00183$:
	ld	hl, #438
	add	hl, sp
	ld	a, (hl)
	sub	a, #0x14
	jr	NC, 00103$
;main.c:100: for (uint8_t y = 0; y < 18; ++y)
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	ld	c, l
	ld	b, h
	ld	hl, #412
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	c, #0x00
00180$:
	ld	a, c
	sub	a, #0x12
	jr	NC, 00184$
;main.c:102: board[x][y] = 0x00;
	ld	l, c
	ld	h, #0x00
	add	hl, de
	ld	(hl), #0x00
;main.c:100: for (uint8_t y = 0; y < 18; ++y)
	inc	c
	jr	00180$
00184$:
;main.c:98: for (uint8_t x = 0; x < 20; ++x)
	ld	hl, #438
	add	hl, sp
	inc	(hl)
	jr	00183$
00103$:
;main.c:107: set_sprite_data(0, 3, k_sprites);
	ld	de, #_k_sprites
	push	de
	ld	hl, #0x300
	push	hl
	call	_set_sprite_data
	add	sp, #4
;main.c:108: set_bkg_data(0, 2, k_background_tiles);
	ld	de, #_k_background_tiles
	push	de
	ld	hl, #0x200
	push	hl
	call	_set_bkg_data
	add	sp, #4
;main.c:111: set_bkg_tiles(0, 0, 20, 18, k_background_map);
	ld	de, #_k_background_map
	push	de
	ld	hl, #0x1214
	push	hl
	xor	a, a
	rrca
	push	af
	call	_set_bkg_tiles
	add	sp, #6
;main.c:114: update_cursor_sprite(k_cursor_empty_tile_index);
	ld	a, (#_k_cursor_empty_tile_index)
	push	af
	inc	sp
	call	_update_cursor_sprite
	inc	sp
;main.c:115: update_cursor_position(cursor_tile_x, cursor_tile_y);
	ld	hl, #0x90a
	push	hl
	call	_update_cursor_position
	pop	hl
;main.c:117: SHOW_BKG;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x01
	ldh	(_LCDC_REG + 0), a
;main.c:118: SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;main.c:119: DISPLAY_ON;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;main.c:121: while (1)
00174$:
;main.c:124: update_input_state(&input_state, joypad());
	call	_joypad
	ld	a, e
	ld	hl, #406
	add	hl, sp
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	push	af
	inc	sp
	push	bc
	call	_update_input_state
	add	sp, #3
;main.c:127: if (was_input_released(&input_state, btn_start))
	ld	hl, #406
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
;main.c:129: execution_state ^= k_execution_state_active_mask;
	ld	hl, #_k_execution_state_active_mask
	ld	c, (hl)
	ld	hl, #435
	add	hl, sp
	ld	a, (hl)
	xor	a, c
	ld	(hl), a
;main.c:132: (execution_state & k_execution_state_active_mask) == k_execution_state_active_mask
	ld	a, (hl)
	and	a, c
	sub	a, c
	jr	NZ, 00199$
;main.c:133: ? k_empty_tile_index
	ld	a, (#_k_empty_tile_index)
	jr	00200$
00199$:
;main.c:134: : k_cursor_empty_tile_index);
	ld	a, (#_k_cursor_empty_tile_index)
00200$:
	push	af
	inc	sp
	call	_update_cursor_sprite
	inc	sp
00105$:
;main.c:138: if ((execution_state & k_execution_state_active_mask) == k_execution_state_active_mask)
	ld	hl, #_k_execution_state_active_mask
	ld	c, (hl)
	ld	hl, #435
	add	hl, sp
	ld	a, (hl)
	and	a, c
	sub	a, c
	jp	NZ,00171$
;main.c:140: for (uint8_t x = 0; x < 20; ++x)
	ld	hl, #412
	add	hl, sp
	ld	a, (hl)
	ld	hl, #428
	add	hl, sp
	ld	(hl), a
	ld	hl, #413
	add	hl, sp
	ld	a, (hl)
	ld	hl, #429
	add	hl, sp
	ld	(hl), a
	ld	hl, #434
	add	hl, sp
	ld	(hl), #0x00
00189$:
	ld	hl, #434
	add	hl, sp
	ld	a, (hl)
	sub	a, #0x14
	jp	NC, 00109$
;main.c:142: for (uint8_t y = 0; y < 18; ++y)
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	ld	c, l
	ld	b, h
	ld	hl, #428
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, #432
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #431
	add	hl, sp
	ld	(hl), a
	ld	hl, #437
	add	hl, sp
	ld	(hl), #0x00
00186$:
	ld	hl, #437
	add	hl, sp
	ld	a, (hl)
	sub	a, #0x12
	jr	NC, 00190$
;main.c:144: uint8_t tile_data = board[x][y];
	ld	hl,#0x1ae
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #437
	add	hl, sp
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, #434
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #433
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	b, a
;main.c:147: tile_data &= ~k_tile_was_alive_mask;
	ld	hl, #_k_tile_was_alive_mask
	ld	c, (hl)
	ld	a, c
	cpl
	and	a, b
	ld	hl, #438
	add	hl, sp
	ld	(hl), a
;main.c:150: if ((tile_data & k_tile_is_alive_mask) != 0x00)
	ld	a, (#_k_tile_is_alive_mask)
	ld	hl, #438
	add	hl, sp
	and	a,(hl)
	jr	Z, 00107$
;main.c:152: tile_data |= k_tile_was_alive_mask;
	ld	a, (hl)
	or	a, c
	ld	(hl), a
00107$:
;main.c:156: board[x][y] = tile_data;
	ld	hl,#0x1b0
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #438
	add	hl, sp
;main.c:142: for (uint8_t y = 0; y < 18; ++y)
	ld	a, (hl-)
	ld	(de), a
	inc	(hl)
	jr	00186$
00190$:
;main.c:140: for (uint8_t x = 0; x < 20; ++x)
	ld	hl, #434
	add	hl, sp
	inc	(hl)
	jp	00189$
00109$:
;main.c:161: for (uint8_t x = 0; x < 20; ++x)
	ld	hl, #412
	add	hl, sp
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
	ld	hl, #410
	add	hl, sp
	ld	a, (hl)
	ld	hl, #416
	add	hl, sp
	ld	(hl), a
	ld	hl, #411
	add	hl, sp
	ld	a, (hl)
	ld	hl, #417
	add	hl, sp
	ld	(hl), a
	ld	hl, #410
	add	hl, sp
	ld	a, (hl)
	ld	hl, #418
	add	hl, sp
	ld	(hl), a
	ld	hl, #411
	add	hl, sp
	ld	a, (hl)
	ld	hl, #419
	add	hl, sp
	ld	(hl), a
	ld	hl, #437
	add	hl, sp
	ld	(hl), #0x00
00195$:
	ld	hl, #437
	add	hl, sp
	ld	a, (hl)
	sub	a, #0x14
	jp	NC, 00172$
;main.c:163: for (uint8_t y = 0; y < 18; ++y)
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	ld	c, l
	ld	b, h
	ld	hl, #414
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, #422
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #421
	add	hl, sp
	ld	(hl), a
	ld	hl, #437
	add	hl, sp
	ld	a, (hl)
	sub	a, #0x13
	ld	a, #0x00
	rla
	ld	hl, #422
	add	hl, sp
	ld	(hl), a
	ld	hl, #438
	add	hl, sp
	ld	(hl), #0x00
00192$:
	ld	hl, #438
	add	hl, sp
	ld	a, (hl)
	sub	a, #0x12
	jp	NC, 00196$
;main.c:165: uint8_t tile_data = board[x][y];
	ld	hl,#0x1a4
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #438
	add	hl, sp
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, #425
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #424
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
;main.c:166: uint8_t neighbour_count = 0;
	ld	(hl+), a
	ld	(hl), #0x00
;main.c:147: tile_data &= ~k_tile_was_alive_mask;
	ld	a, (#_k_tile_was_alive_mask)
	ld	hl, #427
	add	hl, sp
	ld	(hl), a
;main.c:170: && (board[x][y - 1] & k_tile_was_alive_mask) != 0x00)
	ld	hl, #438
	add	hl, sp
	ld	a, (hl)
	ld	hl, #434
	add	hl, sp
	ld	(hl), a
	ld	a, (hl)
	dec	a
	ld	hl, #428
	add	hl, sp
	ld	(hl), a
;main.c:169: if (y > 0
	ld	hl, #438
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00111$
;main.c:170: && (board[x][y - 1] & k_tile_was_alive_mask) != 0x00)
	ld	hl,#0x1a4
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #428
	add	hl, sp
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	hl, #427
	add	hl, sp
	and	a,(hl)
	jr	Z, 00111$
;main.c:172: neighbour_count += 1;
	dec	hl
	ld	(hl), #0x01
00111$:
;main.c:178: && (board[x + 1][y - 1] & k_tile_was_alive_mask) != 0x00)
	ld	hl, #437
	add	hl, sp
	ld	a, (hl)
	ld	hl, #429
	add	hl, sp
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	ld	c, l
	ld	b, h
	ld	hl, #414
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, #433
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #432
	add	hl, sp
	ld	(hl), a
;main.c:177: && y > 0
	ld	hl, #422
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00114$
	ld	hl, #438
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00114$
;main.c:178: && (board[x + 1][y - 1] & k_tile_was_alive_mask) != 0x00)
	ld	hl,#0x1af
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #428
	add	hl, sp
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	inc	sp
	inc	sp
	ld	e, l
	ld	d, h
	push	de
	ld	a, (de)
	ld	hl, #427
	add	hl, sp
	and	a,(hl)
	jr	Z, 00114$
;main.c:180: neighbour_count += 1;
	dec	hl
	inc	(hl)
	ld	a, (hl)
00114$:
;main.c:185: && (board[x + 1][y] & k_tile_was_alive_mask) != 0x00)
	ld	hl, #422
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00118$
	ld	hl,#0x1af
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #438
	add	hl, sp
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	hl, #427
	add	hl, sp
	and	a,(hl)
	jr	Z, 00118$
;main.c:187: neighbour_count += 1;
	dec	hl
	inc	(hl)
	ld	a, (hl)
00118$:
;main.c:193: && (board[x + 1][y + 1] & k_tile_was_alive_mask) != 0x00)
	ld	hl, #438
	add	hl, sp
	ld	a, (hl)
	sub	a, #0x11
	ld	a, #0x00
	rla
	ld	hl, #433
	add	hl, sp
	ld	(hl+), a
	inc	(hl)
;main.c:192: && y < 17
	ld	hl, #422
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00121$
;main.c:193: && (board[x + 1][y + 1] & k_tile_was_alive_mask) != 0x00)
	ld	hl, #433
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00121$
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
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	hl, #427
	add	hl, sp
	and	a,(hl)
	jr	Z, 00121$
;main.c:195: neighbour_count += 1;
	dec	hl
	inc	(hl)
	ld	a, (hl)
00121$:
;main.c:200: && (board[x][y + 1] & k_tile_was_alive_mask) != 0x00)
	ld	hl, #433
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00125$
	ld	hl,#0x1a4
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #434
	add	hl, sp
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, #433
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #432
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	hl, #427
	add	hl, sp
	and	a,(hl)
	jr	Z, 00125$
;main.c:202: neighbour_count += 1;
	dec	hl
	inc	(hl)
	ld	a, (hl)
00125$:
;main.c:208: && (board[x - 1][y + 1] & k_tile_was_alive_mask) != 0x00)
	ld	hl,#0x1ad
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
	ld	c, l
	ld	b, h
	ld	hl, #414
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, #433
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #432
	add	hl, sp
	ld	(hl), a
;main.c:206: if (x > 0
	ld	hl, #437
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00128$
;main.c:208: && (board[x - 1][y + 1] & k_tile_was_alive_mask) != 0x00)
	ld	hl, #433
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00128$
	inc	hl
	ld	e, (hl)
	ld	d, #0x00
	ld	hl, #431
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	hl, #427
	add	hl, sp
	and	a,(hl)
	jr	Z, 00128$
;main.c:210: neighbour_count += 1;
	dec	hl
	inc	(hl)
	ld	a, (hl)
00128$:
;main.c:214: if (x > 0
	ld	hl, #437
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00132$
;main.c:215: && (board[x - 1][y] & k_tile_was_alive_mask) != 0x00)
	ld	hl,#0x1af
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #438
	add	hl, sp
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	hl, #427
	add	hl, sp
	and	a,(hl)
	jr	Z, 00132$
;main.c:217: neighbour_count += 1;
	dec	hl
	inc	(hl)
	ld	a, (hl)
00132$:
;main.c:221: if (x > 0
	ld	hl, #437
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00135$
;main.c:222: && y > 0
	inc	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00135$
;main.c:223: && (board[x - 1][y - 1] & k_tile_was_alive_mask) != 0x00)
	ld	hl, #428
	add	hl, sp
	ld	e, (hl)
	ld	d, #0x00
	ld	hl, #431
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, #435
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #434
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	hl, #427
	add	hl, sp
	and	a,(hl)
	jr	Z, 00135$
;main.c:225: neighbour_count += 1;
	dec	hl
	inc	(hl)
	ld	a, (hl)
00135$:
;main.c:150: if ((tile_data & k_tile_is_alive_mask) != 0x00)
	ld	hl, #_k_tile_is_alive_mask
	ld	c, (hl)
;main.c:229: uint8_t is_alive = (tile_data & k_tile_is_alive_mask) != 0x00;
	ld	hl, #425
	add	hl, sp
	ld	a, (hl)
	and	a, c
	sub	a,#0x01
	ld	a, #0x00
	rla
	xor	a, #0x01
;main.c:230: uint8_t come_to_life = !is_alive && neighbour_count == 3;
	ld	e, a
	or	a, a
	jr	NZ, 00201$
	inc	hl
	ld	a, (hl)
	sub	a, #0x03
	jr	Z, 00202$
00201$:
	xor	a, a
	jr	00203$
00202$:
	ld	a, #0x01
00203$:
	ld	hl, #432
	add	hl, sp
	ld	(hl), a
;main.c:235: uint8_t remain_alive = is_alive && neighbour_count >= 2 && neighbour_count <= 3;
	ld	a, e
	or	a, a
	jr	Z, 00204$
	ld	hl, #426
	add	hl, sp
	ld	a, (hl)
	sub	a, #0x02
	jr	C, 00204$
	ld	a, #0x03
	sub	a, (hl)
	jr	NC, 00205$
00204$:
	ld	e, #0x00
	jr	00206$
00205$:
	ld	e, #0x01
00206$:
;main.c:238: tile_data &= ~k_tile_is_alive_mask;
	ld	a, c
	cpl
	ld	hl, #433
	add	hl, sp
	ld	(hl), a
	ld	hl, #425
	add	hl, sp
	ld	a, (hl)
	ld	hl, #433
	add	hl, sp
	and	a, (hl)
	inc	hl
;main.c:239: if ((come_to_life | remain_alive) != 0x00)
	ld	(hl-), a
	dec	hl
	ld	a, (hl)
	or	a, e
	or	a, a
	jr	Z, 00139$
;main.c:241: tile_data |= k_tile_is_alive_mask;
	inc	hl
	inc	hl
	ld	a, (hl)
	or	a, c
	ld	(hl), a
00139$:
;main.c:245: is_alive = (tile_data & k_tile_is_alive_mask) != 0x00;
	ld	hl, #434
	add	hl, sp
	ld	a, (hl-)
	dec	hl
	and	a, c
	sub	a, #0x01
	ld	a, #0x00
	rla
	xor	a, #0x01
;main.c:246: uint8_t was_alive = (tile_data & k_tile_was_alive_mask) != 0x00;
	ld	(hl+), a
	inc	hl
	ld	a, (hl)
	ld	hl, #427
	add	hl, sp
	and	a, (hl)
	inc	hl
	inc	hl
	sub	a, #0x01
	ld	a, #0x00
	rla
	xor	a, #0x01
	ld	(hl), a
	ld	a, (hl+)
	ld	(hl), a
;main.c:259: update_tile_position(tile_data & k_tile_sprite_index_mask, x, y);
	ld	a, (#_k_tile_sprite_index_mask)
	ld	hl, #431
	add	hl, sp
;main.c:249: if (!was_alive && is_alive)
	ld	(hl-), a
	dec	hl
	ld	a, (hl)
	or	a, a
	jr	NZ, 00147$
	ld	hl, #432
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00147$
;main.c:252: if (next_available_sprite_index < 39)
	ld	hl, #436
	add	hl, sp
	ld	a, (hl)
	sub	a, #0x27
	jr	NC, 00141$
;main.c:255: tile_data |= available_sprites[next_available_sprite_index];
	ld	hl,#0x1a2
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #436
	add	hl, sp
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, #434
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #433
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	or	a, (hl)
;main.c:256: next_available_sprite_index++;
	ld	(hl+), a
	inc	hl
	inc	(hl)
;main.c:259: update_tile_position(tile_data & k_tile_sprite_index_mask, x, y);
	dec	hl
	dec	hl
	ld	a, (hl)
	ld	hl, #431
	add	hl, sp
	and	a, (hl)
	ld	hl, #438
	add	hl, sp
	ld	h, (hl)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	inc	sp
	ld	hl, #438
	add	hl, sp
	ld	h, (hl)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_update_tile_position
	add	sp, #3
	jr	00148$
00141$:
;main.c:264: tile_data &= ~k_tile_is_alive_mask;
	ld	hl, #434
	add	hl, sp
	ld	a, (hl-)
	and	a, (hl)
	inc	hl
	ld	(hl), a
	jr	00148$
00147$:
;main.c:267: else if (was_alive && !is_alive)
	ld	hl, #430
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00148$
	inc	hl
	inc	hl
	ld	a, (hl)
	or	a, a
	jr	NZ, 00148$
;main.c:270: update_tile_position(tile_data & k_tile_sprite_index_mask, 0, 19);
	inc	hl
	inc	hl
	ld	a, (hl)
	ld	hl, #431
	add	hl, sp
	and	a, (hl)
	ld	h, #0x13
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	inc	sp
	ld	h, #0x00
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_update_tile_position
	add	sp, #3
;main.c:273: next_available_sprite_index--;
	ld	hl, #436
	add	hl, sp
	dec	(hl)
;main.c:274: available_sprites[next_available_sprite_index] = tile_data & k_tile_sprite_index_mask;
	ld	hl,#0x1a0
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #436
	add	hl, sp
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, #_k_tile_sprite_index_mask
	ld	c, (hl)
	ld	hl, #434
	add	hl, sp
	ld	a, (hl)
	and	a, c
	ld	(de), a
;main.c:277: tile_data &= ~k_tile_sprite_index_mask;
	ld	a, c
	cpl
	and	a, (hl)
	ld	(hl), a
00148$:
;main.c:280: board[x][y] = tile_data;
	ld	hl,#0x1a7
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #434
	add	hl, sp
	ld	a, (hl)
	ld	(de), a
;main.c:163: for (uint8_t y = 0; y < 18; ++y)
	ld	hl, #438
	add	hl, sp
	inc	(hl)
	jp	00192$
00196$:
;main.c:161: for (uint8_t x = 0; x < 20; ++x)
	ld	hl, #437
	add	hl, sp
	inc	(hl)
	jp	00195$
00171$:
;main.c:293: if (was_input_depressed(&input_state, btn_up))
	ld	hl, #406
	add	hl, sp
	ld	a, (hl)
	ld	hl, #437
	add	hl, sp
	ld	(hl), a
	ld	hl, #407
	add	hl, sp
	ld	a, (hl)
	ld	hl, #438
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
	ld	hl, #438
	add	hl, sp
	ld	(hl), e
;main.c:295: cursor_tile_y -= 1;
	ld	hl, #409
	add	hl, sp
	ld	a, (hl)
	ld	hl, #434
	add	hl, sp
	ld	(hl), a
;main.c:293: if (was_input_depressed(&input_state, btn_up))
	ld	hl, #438
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00161$
;main.c:295: cursor_tile_y -= 1;
	ld	hl, #434
	add	hl, sp
	ld	a, (hl)
	dec	a
	ld	hl, #409
	add	hl, sp
	ld	(hl), a
	jp	00162$
00161$:
;main.c:297: else if (was_input_depressed(&input_state, btn_down))
	ld	hl, #406
	add	hl, sp
	ld	a, (hl)
	ld	hl, #437
	add	hl, sp
	ld	(hl), a
	ld	hl, #407
	add	hl, sp
	ld	a, (hl)
	ld	hl, #438
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
	jr	Z, 00158$
;main.c:299: cursor_tile_y += 1;
	ld	hl, #434
	add	hl, sp
	ld	a, (hl)
	inc	a
	ld	hl, #409
	add	hl, sp
	ld	(hl), a
	jr	00162$
00158$:
;main.c:301: else if (was_input_depressed(&input_state, btn_left))
	ld	hl, #406
	add	hl, sp
	ld	a, (hl)
	ld	hl, #437
	add	hl, sp
	ld	(hl), a
	ld	hl, #407
	add	hl, sp
	ld	a, (hl)
	ld	hl, #438
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
;main.c:303: cursor_tile_x -= 1;
	ld	hl, #408
	add	hl, sp
	ld	a, (hl)
	ld	hl, #434
	add	hl, sp
	ld	(hl), a
;main.c:301: else if (was_input_depressed(&input_state, btn_left))
	ld	a, e
	or	a, a
	jr	Z, 00155$
;main.c:303: cursor_tile_x -= 1;
	ld	a, (hl)
	dec	a
	ld	hl, #408
	add	hl, sp
	ld	(hl), a
	jr	00162$
00155$:
;main.c:305: else if (was_input_depressed(&input_state, btn_right))
	ld	hl, #406
	add	hl, sp
	ld	a, (hl)
	ld	hl, #437
	add	hl, sp
	ld	(hl), a
	ld	hl, #407
	add	hl, sp
	ld	a, (hl)
	ld	hl, #438
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
	jr	Z, 00162$
;main.c:307: cursor_tile_x += 1;
	ld	hl, #434
	add	hl, sp
	ld	a, (hl)
	inc	a
	ld	hl, #408
	add	hl, sp
	ld	(hl), a
00162$:
;main.c:312: ? 19
	ld	hl, #408
	add	hl, sp
	ld	a, (hl)
	inc	a
	jr	NZ, 00210$
	ld	hl, #437
	add	hl, sp
	ld	a, #0x13
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
	jr	00211$
00210$:
;main.c:314: ? 0
	ld	a, #0x13
	ld	hl, #408
	add	hl, sp
	sub	a, (hl)
	jr	NC, 00212$
	xor	a, a
	ld	hl, #437
	add	hl, sp
	ld	(hl+), a
	ld	(hl), a
	jr	00213$
00212$:
;main.c:315: : cursor_tile_x;
	ld	hl, #408
	add	hl, sp
	ld	a, (hl)
	ld	hl, #437
	add	hl, sp
	ld	(hl+), a
	ld	(hl), #0x00
00213$:
00211$:
	ld	hl, #437
	add	hl, sp
	ld	a, (hl)
	ld	hl, #408
	add	hl, sp
;main.c:319: ? 17
	ld	(hl+), a
	ld	a, (hl)
	inc	a
	jr	NZ, 00214$
	ld	hl, #437
	add	hl, sp
	ld	a, #0x11
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
	jr	00215$
00214$:
;main.c:321: ? 0
	ld	a, #0x11
	ld	hl, #409
	add	hl, sp
	sub	a, (hl)
	jr	NC, 00216$
	xor	a, a
	ld	hl, #437
	add	hl, sp
	ld	(hl+), a
	ld	(hl), a
	jr	00217$
00216$:
;main.c:322: : cursor_tile_y;
	ld	hl, #409
	add	hl, sp
	ld	a, (hl)
	ld	hl, #437
	add	hl, sp
	ld	(hl+), a
	ld	(hl), #0x00
00217$:
00215$:
	ld	hl, #437
	add	hl, sp
	ld	a, (hl)
	ld	hl, #409
	add	hl, sp
	ld	(hl), a
;main.c:324: update_cursor_position(cursor_tile_x, cursor_tile_y);
	ld	a, (hl-)
	ld	d, a
	ld	e, (hl)
	push	de
	call	_update_cursor_position
	pop	hl
;main.c:327: if (was_input_depressed(&input_state, btn_b))
	ld	hl, #406
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
	jp	Z, 00172$
;main.c:329: uint8_t tile_data = board[cursor_tile_x][cursor_tile_y];
	ld	hl, #408
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
	ld	c, l
	ld	b, h
	ld	hl, #412
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, #409
	add	hl, sp
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, #435
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #434
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	hl, #438
	add	hl, sp
	ld	(hl), a
;main.c:330: uint8_t is_alive = tile_data & k_tile_is_alive_mask;
	ld	hl, #_k_tile_is_alive_mask
	ld	c, (hl)
;main.c:259: update_tile_position(tile_data & k_tile_sprite_index_mask, x, y);
	ld	a, (#_k_tile_sprite_index_mask)
	ld	hl, #437
	add	hl, sp
;main.c:330: uint8_t is_alive = tile_data & k_tile_is_alive_mask;
	ld	(hl+), a
	ld	a, (hl)
	and	a, c
	ld	hl, #432
	add	hl, sp
	ld	(hl), a
;main.c:332: if (!is_alive)
	ld	a, (hl)
	or	a, a
	jr	NZ, 00166$
;main.c:334: if (next_available_sprite_index < 39)
	ld	hl, #436
	add	hl, sp
	ld	a, (hl)
	sub	a, #0x27
	jp	NC, 00167$
;main.c:337: tile_data |= available_sprites[next_available_sprite_index];
	ld	hl,#0x19a
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #436
	add	hl, sp
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	hl, #438
	add	hl, sp
	or	a, (hl)
;main.c:338: next_available_sprite_index++;
	dec	hl
	dec	hl
	ld	c, a
	inc	(hl)
;main.c:341: update_tile_position(tile_data & k_tile_sprite_index_mask, cursor_tile_x, cursor_tile_y);
	inc	hl
	ld	a, c
	and	a, (hl)
	push	bc
	ld	hl, #411
	add	hl, sp
	ld	h, (hl)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	inc	sp
	ld	hl, #411
	add	hl, sp
	ld	h, (hl)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_update_tile_position
	add	sp, #3
	pop	bc
;main.c:344: tile_data |= k_tile_is_alive_mask;
	ld	a, (#_k_tile_is_alive_mask)
	or	a, c
	ld	hl, #438
	add	hl, sp
	ld	(hl), a
	jr	00167$
00166$:
;main.c:350: update_tile_position(tile_data & k_tile_sprite_index_mask, 0, 19);
	ld	hl, #437
	add	hl, sp
	ld	a, (hl+)
	and	a, (hl)
	dec	hl
	ld	(hl), a
	ld	a, #0x13
	push	af
	inc	sp
	xor	a, a
	push	af
	inc	sp
	ld	a, (hl)
	push	af
	inc	sp
	call	_update_tile_position
	add	sp, #3
;main.c:353: next_available_sprite_index--;
	ld	hl, #436
	add	hl, sp
	dec	(hl)
;main.c:354: available_sprites[next_available_sprite_index] = tile_data & k_tile_sprite_index_mask;
	ld	hl,#0x19a
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #436
	add	hl, sp
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, #433
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #432
	add	hl, sp
	ld	(hl), a
	ld	a, (#_k_tile_sprite_index_mask)
	ld	hl, #437
	add	hl, sp
	ld	(hl+), a
	ld	a, (hl-)
	and	a, (hl)
	ld	c, a
	ld	hl, #431
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), c
;main.c:357: tile_data &= ~k_tile_sprite_index_mask;
	ld	hl, #437
	add	hl, sp
	ld	a, (hl)
	cpl
	ld	hl, #432
	add	hl, sp
	ld	(hl), a
	ld	hl, #438
	add	hl, sp
	ld	a, (hl)
	ld	hl, #432
	add	hl, sp
	and	a, (hl)
	ld	hl, #438
	add	hl, sp
	ld	(hl), a
;main.c:360: tile_data &= ~k_tile_is_alive_mask;
	ld	a, (#_k_tile_is_alive_mask)
	cpl
	ld	hl, #438
	add	hl, sp
	and	a, (hl)
	ld	(hl), a
00167$:
;main.c:364: board[cursor_tile_x][cursor_tile_y] = tile_data;
	ld	hl,#0x1b1
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #438
	add	hl, sp
	ld	a, (hl)
	ld	(de), a
00172$:
;main.c:369: wait_vbls_done(1);
	ld	a, #0x01
	push	af
	inc	sp
	call	_wait_vbls_done
	inc	sp
	jp	00174$
;main.c:371: }
	ld	hl, #439
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
