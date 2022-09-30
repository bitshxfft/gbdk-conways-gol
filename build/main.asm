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
	.globl _k_tile_sprite_index_mask
	.globl _k_tile_is_east_column_mask
	.globl _k_tile_is_west_column_mask
	.globl _k_tile_is_south_row_mask
	.globl _s_tile_is_north_row_mask
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
;main.c:52: void update_cursor_sprite(uint8_t tile_index)
;	---------------------------------
; Function update_cursor_sprite
; ---------------------------------
_update_cursor_sprite::
;main.c:54: set_sprite_tile(k_cursor_sprite_index, tile_index);
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
;main.c:54: set_sprite_tile(k_cursor_sprite_index, tile_index);
;main.c:55: }
	ret
_k_execution_state_active_mask:
	.db #0x02	; 2
_k_tile_is_alive_mask:
	.dw #0x0001
_k_tile_was_alive_mask:
	.dw #0x0002
_s_tile_is_north_row_mask:
	.dw #0x0004
_k_tile_is_south_row_mask:
	.dw #0x0008
_k_tile_is_west_column_mask:
	.dw #0x0010
_k_tile_is_east_column_mask:
	.dw #0x0020
_k_tile_sprite_index_mask:
	.dw #0xff00
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
;main.c:57: void update_cursor_position(uint8_t tile_x, uint8_t tile_y)
;	---------------------------------
; Function update_cursor_position
; ---------------------------------
_update_cursor_position::
;main.c:61: SCREEN_MIN_Y + (tile_y * SPRITE_TILE_HEIGHT));
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
;main.c:60: SCREEN_MIN_X + (tile_x * SPRITE_TILE_WIDTH),
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
;main.c:61: SCREEN_MIN_Y + (tile_y * SPRITE_TILE_HEIGHT));
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
;main.c:61: SCREEN_MIN_Y + (tile_y * SPRITE_TILE_HEIGHT));
;main.c:62: }
	ret
;main.c:64: void update_tile_sprite(uint8_t sprite_index, uint8_t tile_index)
;	---------------------------------
; Function update_tile_sprite
; ---------------------------------
_update_tile_sprite::
;main.c:66: set_sprite_tile(sprite_index, tile_index);
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
;main.c:66: set_sprite_tile(sprite_index, tile_index);
;main.c:67: }
	ret
;main.c:69: void update_tile_position(uint8_t tile_index, uint8_t tile_x, uint8_t tile_y)
;	---------------------------------
; Function update_tile_position
; ---------------------------------
_update_tile_position::
;main.c:73: SCREEN_MIN_Y + (tile_y * SPRITE_TILE_HEIGHT));
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
;main.c:72: SCREEN_MIN_X + (tile_x * SPRITE_TILE_WIDTH),
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
;main.c:73: SCREEN_MIN_Y + (tile_y * SPRITE_TILE_HEIGHT));
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
;main.c:73: SCREEN_MIN_Y + (tile_y * SPRITE_TILE_HEIGHT));
;main.c:74: }
	ret
;main.c:78: int main()
;	---------------------------------
; Function main
; ---------------------------------
_main::
	ld	hl, #-797
	add	hl, sp
	ld	sp, hl
;main.c:82: input_state.previous_state = 0x00;
	ldhl	sp,	#0
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
;main.c:83: input_state.current_state = 0x00;
	ldhl	sp,	#0
	ld	a, l
	ld	d, h
	ld	hl, #764
	add	hl, sp
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
;main.c:84: input_state.held_buttons = 0x00;
	ld	a, (hl-)
	ld	b, a
	inc	bc
	xor	a, a
	ld	(bc), a
	ld	a, (hl+)
	ld	c, a
;main.c:85: input_state.depressed_buttons = 0x00;
	ld	a, (hl-)
	ld	b, a
	inc	bc
	inc	bc
	xor	a, a
	ld	(bc), a
	ld	a, (hl+)
	ld	c, a
;main.c:86: input_state.released_buttons = 0x00;
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
;main.c:89: uint8_t execution_state = 0x00;
	ld	hl, #793
	add	hl, sp
	ld	(hl), #0x00
;main.c:92: uint8_t cursor_tile_x = 10;
	ld	hl, #766
	add	hl, sp
;main.c:93: uint8_t cursor_tile_y = 9;
	ld	a, #0x0a
	ld	(hl+), a
	ld	(hl), #0x09
;main.c:102: uint8_t next_available_sprite_index = 0;
	ld	hl, #796
	add	hl, sp
	ld	(hl), #0x00
;main.c:104: for (uint8_t i = 0; i < 39; ++i)
	ld	hl, #725
	add	hl, sp
	ld	a, l
	ld	d, h
	ld	hl, #768
	add	hl, sp
	ld	(hl+), a
	ld	(hl), d
	ld	e, #0x00
00142$:
	ld	a, e
	sub	a, #0x27
	jr	NC, 00101$
;main.c:106: available_sprites[i] = i + 1;
	push	de
	ld	d, #0x00
	ld	hl, #770
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
;main.c:107: update_tile_sprite(i + 1, k_empty_tile_index);
	ld	a, (#_k_empty_tile_index)
	push	de
	push	af
	inc	sp
	push	de
	inc	sp
	call	_update_tile_sprite
	pop	hl
	pop	de
;main.c:108: update_tile_position(i + 1, 21, 19);
	push	de
	ld	hl, #0x1315
	push	hl
	push	de
	inc	sp
	call	_update_tile_position
	add	sp, #3
	pop	de
;main.c:104: for (uint8_t i = 0; i < 39; ++i)
	inc	e
	jr	00142$
00101$:
;main.c:111: for (uint16_t i = 0; i < 360; ++i)
	ldhl	sp,	#5
	ld	a, l
	ld	d, h
	ld	hl, #770
	add	hl, sp
	ld	(hl+), a
	ld	(hl), d
	xor	a, a
	ld	hl, #794
	add	hl, sp
	ld	(hl+), a
	ld	(hl), a
00145$:
	ld	hl, #794
	add	hl, sp
	ld	a, (hl)
	ld	hl, #785
	add	hl, sp
	ld	(hl), a
	ld	hl, #795
	add	hl, sp
	ld	a, (hl)
	ld	hl, #786
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	sub	a, #0x68
	ld	a, (hl)
	sbc	a, #0x01
	jp	NC, 00102$
;main.c:113: uint16_t tile_data = 0x0000;
	xor	a, a
	ld	hl, #791
	add	hl, sp
	ld	(hl+), a
	ld	(hl), a
;main.c:114: tile_data |= (i < 20 ? s_tile_is_north_row_mask : 0x0000);
	ld	hl, #785
	add	hl, sp
	ld	a, (hl+)
	sub	a, #0x14
	ld	a, (hl)
	sbc	a, #0x00
	jr	NC, 00155$
	ld	a, (#_s_tile_is_north_row_mask)
	ld	hl, #789
	add	hl, sp
	ld	(hl), a
	ld	a, (#_s_tile_is_north_row_mask + 1)
	ld	hl, #790
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ld	hl, #790
	add	hl, sp
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	jr	00156$
00155$:
	xor	a, a
	ld	hl, #787
	add	hl, sp
	ld	(hl+), a
	ld	(hl), a
00156$:
	ld	hl, #791
	add	hl, sp
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ld	hl, #792
	add	hl, sp
	ld	a, (hl-)
	dec	hl
	ld	(hl-), a
	ld	a, (hl-)
	dec	hl
	or	a, (hl)
	ld	hl, #791
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl-)
	dec	hl
	or	a, (hl)
	ld	hl, #792
	add	hl, sp
	ld	(hl), a
;main.c:115: tile_data |= (i >= 340 ? k_tile_is_south_row_mask : 0x0000);
	ld	hl, #785
	add	hl, sp
	ld	a, (hl+)
	sub	a, #0x54
	ld	a, (hl)
	sbc	a, #0x01
	jr	C, 00157$
	ld	a, (#_k_tile_is_south_row_mask)
	ld	hl, #789
	add	hl, sp
	ld	(hl), a
	ld	a, (#_k_tile_is_south_row_mask + 1)
	ld	hl, #790
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ld	hl, #790
	add	hl, sp
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	jr	00158$
00157$:
	xor	a, a
	ld	hl, #787
	add	hl, sp
	ld	(hl+), a
	ld	(hl), a
00158$:
	ld	hl, #791
	add	hl, sp
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ld	hl, #792
	add	hl, sp
	ld	a, (hl-)
	dec	hl
	ld	(hl-), a
	ld	a, (hl-)
	dec	hl
	or	a, (hl)
	ld	hl, #791
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl-)
	dec	hl
	or	a, (hl)
	ld	hl, #792
	add	hl, sp
	ld	(hl), a
;main.c:116: tile_data |= (i % 20 == 0 ? k_tile_is_west_column_mask : 0x0000);
	ld	de, #0x0014
	push	de
	ld	hl, #787
	add	hl, sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	call	__moduint
	add	sp, #4
	ld	a, d
	or	a, e
	jr	NZ, 00159$
	ld	hl, #_k_tile_is_west_column_mask
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	jr	00160$
00159$:
	ld	bc, #0x0000
00160$:
	ld	hl, #791
	add	hl, sp
	ld	a, (hl+)
	or	a, c
	ld	c, a
	ld	a, (hl-)
	or	a, b
	ld	(hl), c
	inc	hl
	ld	(hl), a
;main.c:117: tile_data |= (i % 20 == 19 ? k_tile_is_east_column_mask : 0x0000);
	ld	a, e
	sub	a, #0x13
	or	a, d
	jr	NZ, 00161$
	ld	a, (#_k_tile_is_east_column_mask)
	ld	hl, #789
	add	hl, sp
	ld	(hl), a
	ld	a, (#_k_tile_is_east_column_mask + 1)
	ld	hl, #790
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ld	hl, #790
	add	hl, sp
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	jr	00162$
00161$:
	xor	a, a
	ld	hl, #787
	add	hl, sp
	ld	(hl+), a
	ld	(hl), a
00162$:
	ld	hl, #791
	add	hl, sp
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ld	hl, #792
	add	hl, sp
	ld	a, (hl-)
	dec	hl
	ld	(hl-), a
	ld	a, (hl-)
	dec	hl
	or	a, (hl)
	ld	hl, #791
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl-)
	dec	hl
	or	a, (hl)
	ld	hl, #792
	add	hl, sp
;main.c:118: board[i] = tile_data;
	ld	(hl+), a
	inc	hl
	ld	a, (hl)
	ld	hl, #789
	add	hl, sp
	ld	(hl), a
	ld	hl, #795
	add	hl, sp
	ld	a, (hl)
	ld	hl, #790
	add	hl, sp
	ld	(hl-), a
	sla	(hl)
	inc	hl
	rl	(hl)
	ld	hl,#0x302
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #789
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, #791
	add	hl, sp
	ld	a, (hl+)
	ld	(bc), a
	inc	bc
;main.c:111: for (uint16_t i = 0; i < 360; ++i)
	ld	a, (hl+)
	inc	hl
	ld	(bc), a
	inc	(hl)
	jp	NZ,00145$
	inc	hl
	inc	(hl)
	jp	00145$
00102$:
;main.c:122: set_sprite_data(0, 3, k_sprites);
	ld	de, #_k_sprites
	push	de
	ld	hl, #0x300
	push	hl
	call	_set_sprite_data
	add	sp, #4
;main.c:123: set_bkg_data(0, 2, k_background_tiles);
	ld	de, #_k_background_tiles
	push	de
	ld	hl, #0x200
	push	hl
	call	_set_bkg_data
	add	sp, #4
;main.c:126: set_bkg_tiles(0, 0, 20, 18, k_background_map);
	ld	de, #_k_background_map
	push	de
	ld	hl, #0x1214
	push	hl
	xor	a, a
	rrca
	push	af
	call	_set_bkg_tiles
	add	sp, #6
;main.c:129: update_cursor_sprite(k_cursor_empty_tile_index);
	ld	a, (#_k_cursor_empty_tile_index)
	push	af
	inc	sp
	call	_update_cursor_sprite
	inc	sp
;main.c:130: update_cursor_position(cursor_tile_x, cursor_tile_y);
	ld	hl, #0x90a
	push	hl
	call	_update_cursor_position
	pop	hl
;main.c:132: SHOW_BKG;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x01
	ldh	(_LCDC_REG + 0), a
;main.c:133: SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;main.c:134: DISPLAY_ON;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;main.c:136: while (1)
00139$:
;main.c:139: update_input_state(&input_state, joypad());
	call	_joypad
	ld	a, e
	ld	hl, #764
	add	hl, sp
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	push	af
	inc	sp
	push	bc
	call	_update_input_state
	add	sp, #3
;main.c:142: if (was_input_released(&input_state, btn_start))
	ld	hl, #764
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
	jr	Z, 00104$
;main.c:144: execution_state ^= k_execution_state_active_mask;
	ld	hl, #_k_execution_state_active_mask
	ld	c, (hl)
	ld	hl, #793
	add	hl, sp
	ld	a, (hl)
	xor	a, c
	ld	(hl), a
;main.c:147: (execution_state & k_execution_state_active_mask) == k_execution_state_active_mask
	ld	a, (hl)
	and	a, c
	sub	a, c
	jr	NZ, 00163$
;main.c:148: ? k_empty_tile_index
	ld	a, (#_k_empty_tile_index)
	jr	00164$
00163$:
;main.c:149: : k_cursor_empty_tile_index);
	ld	a, (#_k_cursor_empty_tile_index)
00164$:
	push	af
	inc	sp
	call	_update_cursor_sprite
	inc	sp
00104$:
;main.c:153: if ((execution_state & k_execution_state_active_mask) == k_execution_state_active_mask)
	ld	hl, #_k_execution_state_active_mask
	ld	c, (hl)
	ld	hl, #793
	add	hl, sp
	ld	a, (hl)
	and	a, c
	sub	a, c
	jp	NZ,00136$
;main.c:156: for (uint16_t i = 0; i < 360; ++i)
	ld	hl, #770
	add	hl, sp
	ld	a, (hl)
	ld	hl, #791
	add	hl, sp
	ld	(hl), a
	ld	hl, #771
	add	hl, sp
	ld	a, (hl)
	ld	hl, #792
	add	hl, sp
	ld	(hl+), a
	inc	hl
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
00148$:
	ld	hl, #794
	add	hl, sp
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, c
	sub	a, #0x68
	ld	a, b
	sbc	a, #0x01
	jr	NC, 00105$
;main.c:158: uint8_t tile_data = board[i];
	dec	hl
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	sla	c
	rl	b
	ld	hl, #791
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	e, a
;main.c:161: tile_data &= ~k_tile_was_alive_mask;
	ld	hl, #_k_tile_was_alive_mask
	ld	a, (hl+)
	ld	d, (hl)
	cpl
	and	a, e
	ld	e, a
;main.c:163: tile_data |= ((tile_data & k_tile_is_alive_mask) << tile_was_alive);
	ld	hl, #_k_tile_is_alive_mask
	ld	a, (hl+)
	ld	d, (hl)
	and	a, e
	add	a, a
	or	a, e
;main.c:165: board[i] = tile_data;
	ld	e, a
	ld	d, #0x00
	ld	a, e
	ld	(bc), a
	inc	bc
	ld	a, d
	ld	(bc), a
;main.c:156: for (uint16_t i = 0; i < 360; ++i)
	ld	hl, #794
	add	hl, sp
	inc	(hl)
	jr	NZ, 00148$
	inc	hl
	inc	(hl)
	jr	00148$
00105$:
;main.c:169: for (uint16_t i = 0; i < 360; ++i)
	ld	hl, #770
	add	hl, sp
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
	ld	hl, #768
	add	hl, sp
	ld	a, (hl)
	ld	hl, #774
	add	hl, sp
	ld	(hl), a
	ld	hl, #769
	add	hl, sp
	ld	a, (hl)
	ld	hl, #775
	add	hl, sp
	ld	(hl), a
	ld	hl, #796
	add	hl, sp
	ld	a, (hl-)
	dec	hl
	ld	(hl+), a
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
00151$:
	ld	hl, #795
	add	hl, sp
	ld	a, (hl)
	ld	hl, #776
	add	hl, sp
	ld	(hl), a
	ld	hl, #796
	add	hl, sp
	ld	a, (hl)
	ld	hl, #777
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	sub	a, #0x68
	ld	a, (hl)
	sbc	a, #0x01
	jp	NC, 00263$
;main.c:171: uint16_t tile_data = board[i];
	ld	hl, #795
	add	hl, sp
	ld	a, (hl+)
	ld	d, (hl)
	add	a, a
	rl	d
	ld	e, a
	ld	hl, #772
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, #780
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #779
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
;main.c:172: uint8_t neighbour_count = 0;
	ld	hl, #792
	add	hl, sp
	ld	(hl), #0x00
;main.c:174: uint16_t is_not_north_row = (tile_data & s_tile_is_north_row_mask) == 0x00;
	ld	hl, #_s_tile_is_north_row_mask
	ld	a, (hl+)
	ld	b, (hl)
	ld	hl, #780
	add	hl, sp
	and	a, (hl)
	inc	hl
	ld	c, a
	ld	a, b
	and	a, (hl)
	ld	b, a
	ld	a, c
	or	a, a
	or	a, b
	ld	a, #0x01
	jr	Z, 00511$
	xor	a, a
00511$:
	ld	hl, #782
	add	hl, sp
	ld	(hl+), a
	ld	(hl), #0x00
;main.c:175: uint16_t is_not_east_col = (tile_data & k_tile_is_east_column_mask) == 0x00;
	ld	hl, #_k_tile_is_east_column_mask
	ld	a, (hl+)
	ld	b, (hl)
	ld	hl, #780
	add	hl, sp
	and	a, (hl)
	inc	hl
	ld	c, a
	ld	a, b
	and	a, (hl)
	ld	b, a
	ld	a, c
	or	a, a
	or	a, b
	ld	a, #0x01
	jr	Z, 00513$
	xor	a, a
00513$:
	ld	hl, #790
	add	hl, sp
	ld	(hl+), a
	ld	(hl), #0x00
;main.c:176: uint16_t is_not_south_row = (tile_data & k_tile_is_south_row_mask) == 0x00;
	ld	hl, #_k_tile_is_south_row_mask
	ld	a, (hl+)
	ld	b, (hl)
	ld	hl, #780
	add	hl, sp
	and	a, (hl)
	inc	hl
	ld	c, a
	ld	a, b
	and	a, (hl)
	ld	b, a
	ld	a, c
	or	a, a
	or	a, b
	ld	a, #0x01
	jr	Z, 00515$
	xor	a, a
00515$:
	ld	hl, #784
	add	hl, sp
	ld	(hl+), a
	ld	(hl), #0x00
;main.c:177: uint16_t is_not_west_col = (tile_data & k_tile_is_west_column_mask) == 0x00;
	ld	hl, #_k_tile_is_west_column_mask
	ld	a, (hl+)
	ld	b, (hl)
	ld	hl, #780
	add	hl, sp
	and	a, (hl)
	inc	hl
	ld	c, a
	ld	a, b
	and	a, (hl)
	ld	b, a
	ld	a, c
	or	a, a
	or	a, b
	ld	a, #0x01
	jr	Z, 00517$
	xor	a, a
00517$:
	ld	hl, #786
	add	hl, sp
	ld	(hl+), a
	ld	(hl), #0x00
;main.c:161: tile_data &= ~k_tile_was_alive_mask;
	ld	a, (#_k_tile_was_alive_mask)
	ld	hl, #788
	add	hl, sp
	ld	(hl), a
	ld	a, (#_k_tile_was_alive_mask + 1)
	ld	hl, #789
	add	hl, sp
	ld	(hl), a
;main.c:180: neighbour_count += is_not_north_row
	ld	hl, #783
	add	hl, sp
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00165$
;main.c:181: && ((board[i - 20] & k_tile_was_alive_mask) != 0x00);
	ld	hl,#0x308
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0014
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	c, e
	ld	b, a
	sla	c
	rl	b
	ld	hl, #772
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, c
	ld	hl, #788
	add	hl, sp
	and	a, (hl)
	inc	hl
	ld	c, a
	ld	a, b
	and	a, (hl)
	or	a, c
	jr	NZ, 00166$
00165$:
	xor	a, a
	jr	00167$
00166$:
	ld	a, #0x01
00167$:
	ld	hl, #792
	add	hl, sp
	ld	c, (hl)
	add	a, c
	ld	c, a
;main.c:184: neighbour_count += is_not_north_row	&& is_not_east_col
	ld	hl, #783
	add	hl, sp
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00168$
	ld	hl, #791
	add	hl, sp
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00168$
;main.c:185: && ((board[i - 19] & k_tile_was_alive_mask) != 0x00);
	ld	hl,#0x308
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0013
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	b, e
	ld	d, a
	ld	a, b
	add	a, a
	rl	d
	ld	e, a
	ld	hl, #772
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl)
	push	af
	ld	a, b
	ld	hl, #790
	add	hl, sp
	and	a, (hl)
	inc	hl
	ld	b, a
	pop	af
	and	a, (hl)
	or	a, b
	jr	NZ, 00169$
00168$:
	xor	a, a
	jr	00170$
00169$:
	ld	a, #0x01
00170$:
	add	a, c
	ld	hl, #792
	add	hl, sp
;main.c:188: neighbour_count += is_not_east_col
	ld	(hl-), a
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00174$
;main.c:189: && ((board[i + 1] & k_tile_was_alive_mask) != 0x00);
	ld	hl, #776
	add	hl, sp
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	sla	c
	rl	b
	ld	hl, #772
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, c
	ld	hl, #788
	add	hl, sp
	and	a, (hl)
	inc	hl
	ld	c, a
	ld	a, b
	and	a, (hl)
	or	a, c
	jr	NZ, 00175$
00174$:
	xor	a, a
	jr	00176$
00175$:
	ld	a, #0x01
00176$:
	ld	hl, #792
	add	hl, sp
	ld	c, (hl)
	add	a, c
	ld	c, a
;main.c:192: neighbour_count += is_not_south_row && is_not_east_col
	ld	hl, #785
	add	hl, sp
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00177$
	ld	hl, #791
	add	hl, sp
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00177$
;main.c:193: && ((board[i + 21] & k_tile_was_alive_mask) != 0x00);
	ld	hl,#0x308
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0015
	add	hl, de
	ld	e, l
	ld	d, h
	sla	e
	rl	d
	ld	hl, #772
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl)
	push	af
	ld	a, b
	ld	hl, #790
	add	hl, sp
	and	a, (hl)
	inc	hl
	ld	b, a
	pop	af
	and	a, (hl)
	or	a, b
	jr	NZ, 00178$
00177$:
	xor	a, a
	jr	00179$
00178$:
	ld	a, #0x01
00179$:
	add	a, c
	ld	hl, #790
	add	hl, sp
	ld	(hl), a
;main.c:196: neighbour_count += is_not_south_row
	ld	hl, #785
	add	hl, sp
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00183$
;main.c:197: && ((board[i + 20] & k_tile_was_alive_mask) != 0x00);
	ld	hl,#0x308
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0014
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, #793
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #792
	add	hl, sp
	ld	(hl-), a
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #772
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, c
	ld	hl, #788
	add	hl, sp
	and	a, (hl)
	inc	hl
	ld	c, a
	ld	a, b
	and	a, (hl)
	or	a, c
	jr	NZ, 00184$
00183$:
	xor	a, a
	jr	00185$
00184$:
	ld	a, #0x01
00185$:
	ld	hl, #790
	add	hl, sp
	ld	c, (hl)
	inc	hl
	inc	hl
	add	a, c
	ld	(hl), a
;main.c:200: neighbour_count += is_not_south_row && is_not_west_col
	ld	hl, #785
	add	hl, sp
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00186$
	ld	hl, #787
	add	hl, sp
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00186$
;main.c:201: && ((board[i + 19] & k_tile_was_alive_mask) != 0x00);
	ld	hl,#0x308
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0013
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, #792
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #791
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl)
	ld	hl, #784
	add	hl, sp
	ld	(hl), a
	ld	hl, #791
	add	hl, sp
	ld	a, (hl)
	ld	hl, #785
	add	hl, sp
	ld	(hl-), a
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #772
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, #792
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #791
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	push	af
	ld	a, c
	ld	hl, #790
	add	hl, sp
	and	a, (hl)
	inc	hl
	ld	c, a
	pop	af
	and	a, (hl)
	or	a, c
	jr	NZ, 00187$
00186$:
	xor	a, a
	jr	00188$
00187$:
	ld	a, #0x01
00188$:
	ld	hl, #792
	add	hl, sp
	ld	c, (hl)
	dec	hl
	dec	hl
	add	a, c
	ld	(hl), a
;main.c:204: neighbour_count += is_not_west_col
	ld	hl, #787
	add	hl, sp
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00192$
;main.c:205: && ((board[i - 1] & k_tile_was_alive_mask) != 0x00);
	ld	hl,#0x308
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0001
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, #792
	add	hl, sp
	ld	(hl-), a
	ld	(hl), e
	sla	(hl)
	inc	hl
	rl	(hl)
	ld	hl,#0x304
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #791
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, c
	ld	hl, #788
	add	hl, sp
	and	a, (hl)
	inc	hl
	ld	c, a
	ld	a, b
	and	a, (hl)
	or	a, c
	jr	NZ, 00193$
00192$:
	xor	a, a
	jr	00194$
00193$:
	ld	a, #0x01
00194$:
	ld	hl, #790
	add	hl, sp
	ld	c, (hl)
	inc	hl
	inc	hl
	add	a, c
	ld	(hl), a
;main.c:208: neighbour_count += is_not_north_row && is_not_west_col
	ld	hl, #783
	add	hl, sp
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00195$
	ld	hl, #787
	add	hl, sp
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00195$
;main.c:209: && ((board[i - 21] & k_tile_was_alive_mask) != 0x00);
	ld	hl,#0x308
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0015
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	hl, #791
	add	hl, sp
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl)
	ld	hl, #786
	add	hl, sp
	ld	(hl), a
	ld	hl, #791
	add	hl, sp
	ld	a, (hl)
	ld	hl, #787
	add	hl, sp
	ld	(hl-), a
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #772
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, #792
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #791
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl-), a
	ld	a, (hl-)
	dec	hl
	and	a, (hl)
	ld	c, a
	ld	hl, #791
	add	hl, sp
	ld	a, (hl-)
	dec	hl
	and	a, (hl)
	or	a, c
	jr	NZ, 00196$
00195$:
	ld	hl, #791
	add	hl, sp
	ld	(hl), #0x00
	jr	00197$
00196$:
	ld	hl, #791
	add	hl, sp
	ld	(hl), #0x01
00197$:
	ld	hl, #791
	add	hl, sp
	ld	a, (hl+)
	ld	c, (hl)
	add	a, c
	ld	(hl), a
;main.c:163: tile_data |= ((tile_data & k_tile_is_alive_mask) << tile_was_alive);
	ld	a, (#_k_tile_is_alive_mask)
	ld	hl, #784
	add	hl, sp
	ld	(hl), a
	ld	a, (#_k_tile_is_alive_mask + 1)
	ld	hl, #785
	add	hl, sp
	ld	(hl), a
;main.c:212: uint8_t is_alive = (tile_data & k_tile_is_alive_mask) != 0x00;
	ld	hl, #780
	add	hl, sp
	ld	a, (hl)
	ld	hl, #784
	add	hl, sp
	and	a, (hl)
	ld	c, a
	ld	hl, #781
	add	hl, sp
	ld	a, (hl)
	ld	hl, #785
	add	hl, sp
	and	a, (hl)
	or	a, c
	sub	a,#0x01
	ld	a, #0x00
	rla
	xor	a, #0x01
;main.c:213: uint8_t come_to_life = !is_alive && neighbour_count == 3;
	ld	e, a
	or	a, a
	jr	NZ, 00201$
	ld	hl, #792
	add	hl, sp
	ld	a, (hl)
	sub	a, #0x03
	jr	Z, 00202$
00201$:
	ld	c, #0x00
	jr	00203$
00202$:
	ld	c, #0x01
00203$:
;main.c:218: uint8_t remain_alive = is_alive && neighbour_count >= 2 && neighbour_count <= 3;
	ld	a, e
	or	a, a
	jr	Z, 00204$
	ld	hl, #792
	add	hl, sp
	ld	a, (hl)
	sub	a, #0x02
	jr	C, 00204$
	ld	a, #0x03
	sub	a, (hl)
	jr	NC, 00205$
00204$:
	xor	a, a
	jr	00206$
00205$:
	ld	a, #0x01
00206$:
;main.c:221: tile_data &= ~k_tile_is_alive_mask;
	push	af
	ld	hl, #786
	add	hl, sp
	ld	a, (hl+)
	inc	hl
	cpl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	cpl
	ld	(hl), a
	ld	hl, #782
	add	hl, sp
	ld	a, (hl)
	ld	hl, #788
	add	hl, sp
	and	a, (hl)
	ld	e, a
	ld	hl, #783
	add	hl, sp
	ld	a, (hl)
	ld	hl, #789
	add	hl, sp
	and	a, (hl)
	ld	d, a
	pop	af
;main.c:222: tile_data |= (come_to_life | remain_alive) << tile_is_alive;
	or	a, c
	ld	c, a
	ld	b, #0x00
	ld	a, e
	or	a, c
	ld	c, a
	ld	a, d
	or	a, b
	ld	b, a
	ld	hl, #791
	add	hl, sp
	ld	a, c
	ld	(hl+), a
;main.c:225: is_alive = (tile_data & k_tile_is_alive_mask) != 0x00;
	ld	a, b
	ld	(hl-), a
	ld	a, (hl)
	ld	hl, #784
	add	hl, sp
	and	a, (hl)
	ld	c, a
	ld	hl, #792
	add	hl, sp
	ld	a, (hl)
	ld	hl, #785
	add	hl, sp
	and	a, (hl)
	or	a, c
	sub	a,#0x01
	ld	a, #0x00
	rla
	xor	a, #0x01
	ld	hl, #790
	add	hl, sp
;main.c:226: uint8_t was_alive = (tile_data & k_tile_was_alive_mask) != 0x00;
	ld	(hl+), a
	ld	a, (hl)
	ld	hl, #788
	add	hl, sp
	and	a, (hl)
	ld	c, a
	ld	hl, #792
	add	hl, sp
	ld	a, (hl)
	ld	hl, #789
	add	hl, sp
	and	a, (hl)
	dec	hl
	or	a, c
	sub	a, #0x01
	ld	a, #0x00
	rla
	xor	a, #0x01
	ld	(hl), a
	ld	a, (hl+)
;main.c:229: if (!was_alive && is_alive)
	ld	(hl-), a
	ld	a, (hl)
	or	a, a
	jp	NZ, 00113$
	inc	hl
	inc	hl
	ld	a, (hl)
	or	a, a
	jp	Z, 00113$
;main.c:232: if (next_available_sprite_index < 39)
	ld	hl, #794
	add	hl, sp
	ld	a, (hl)
	sub	a, #0x27
	jp	NC, 00107$
;main.c:235: uint8_t sprite_index = available_sprites[next_available_sprite_index];
	ld	hl,#0x306
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #794
	add	hl, sp
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
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
	inc	hl
	ld	d, a
	ld	a, (de)
	ld	(hl), a
;main.c:236: next_available_sprite_index++;
	ld	hl, #794
	add	hl, sp
	inc	(hl)
;main.c:239: update_tile_sprite(sprite_index, k_live_tile_index);
	ld	a, (#_k_live_tile_index)
	push	af
	inc	sp
	ld	hl, #790
	add	hl, sp
	ld	a, (hl)
	push	af
	inc	sp
	call	_update_tile_sprite
	pop	hl
;main.c:240: update_tile_position(sprite_index, i % 20, i / 20);
	ld	de, #0x0014
	push	de
	ld	hl, #778
	add	hl, sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	call	__divuint
	add	sp, #4
	ld	hl, #790
	add	hl, sp
	ld	(hl), e
	ld	de, #0x0014
	push	de
	ld	hl, #778
	add	hl, sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	call	__moduint
	add	sp, #4
	ld	hl, #787
	add	hl, sp
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ld	hl, #787
	add	hl, sp
	ld	a, (hl)
	ld	hl, #790
	add	hl, sp
	ld	h, (hl)
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	inc	sp
	push	af
	inc	sp
	ld	hl, #791
	add	hl, sp
	ld	a, (hl)
	push	af
	inc	sp
	call	_update_tile_position
	add	sp, #3
;main.c:243: tile_data |= sprite_index << 8;
	ld	hl, #789
	add	hl, sp
	ld	a, (hl)
	ld	hl, #786
	add	hl, sp
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl)
	ld	hl, #790
	add	hl, sp
	ld	(hl-), a
	xor	a, a
	ld	(hl+), a
	inc	hl
	ld	a, (hl+)
	ld	c, (hl)
	ld	hl, #789
	add	hl, sp
	or	a, (hl)
	inc	hl
	push	af
	ld	a, c
	or	a, (hl)
	inc	hl
	ld	c, a
	pop	af
	ld	(hl+), a
	ld	(hl), c
	jr	00114$
00107$:
;main.c:248: tile_data &= ~k_tile_is_alive_mask;
	ld	hl, #791
	add	hl, sp
	ld	a, (hl)
	ld	hl, #786
	add	hl, sp
	and	a, (hl)
	ld	hl, #791
	add	hl, sp
	ld	(hl+), a
	ld	a, (hl)
	ld	hl, #787
	add	hl, sp
	and	a, (hl)
	ld	hl, #792
	add	hl, sp
	ld	(hl), a
	jr	00114$
00113$:
;main.c:251: else if (was_alive && !is_alive)
	ld	hl, #789
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00114$
	inc	hl
	ld	a, (hl)
	or	a, a
	jr	NZ, 00114$
;main.c:254: tile_data |= k_tile_is_alive_mask;
	inc	hl
	ld	a, (hl)
	ld	hl, #784
	add	hl, sp
	or	a, (hl)
	ld	hl, #791
	add	hl, sp
	ld	(hl+), a
	ld	a, (hl)
	ld	hl, #785
	add	hl, sp
	or	a, (hl)
	ld	hl, #792
	add	hl, sp
	ld	(hl), a
00114$:
;main.c:271: board[i] = tile_data;
	ld	hl,#0x30a
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #791
	add	hl, sp
	ld	a, (hl+)
	ld	(de), a
	inc	de
	ld	a, (hl)
	ld	(de), a
;main.c:169: for (uint16_t i = 0; i < 360; ++i)
	ld	hl, #795
	add	hl, sp
	inc	(hl)
	jp	NZ,00151$
	inc	hl
	inc	(hl)
	jp	00151$
00263$:
	ld	hl, #794
	add	hl, sp
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
;main.c:276: execution_state &= ~k_execution_state_active_mask;
	ld	a, (#_k_execution_state_active_mask)
	cpl
	ld	hl, #793
	add	hl, sp
	and	a, (hl)
	ld	(hl), a
;main.c:277: update_cursor_sprite(k_cursor_empty_tile_index);
	ld	a, (#_k_cursor_empty_tile_index)
	push	af
	inc	sp
	call	_update_cursor_sprite
	inc	sp
	jp	00137$
00136$:
;main.c:283: if (was_input_depressed(&input_state, btn_up))
	ld	hl, #764
	add	hl, sp
	ld	a, (hl)
	ld	hl, #794
	add	hl, sp
	ld	(hl), a
	ld	hl, #765
	add	hl, sp
	ld	a, (hl)
	ld	hl, #795
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
	ld	hl, #795
	add	hl, sp
	ld	(hl), e
;main.c:285: cursor_tile_y -= 1;
	ld	hl, #767
	add	hl, sp
	ld	a, (hl)
	ld	hl, #792
	add	hl, sp
	ld	(hl), a
;main.c:283: if (was_input_depressed(&input_state, btn_up))
	ld	hl, #795
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00126$
;main.c:285: cursor_tile_y -= 1;
	ld	hl, #792
	add	hl, sp
	ld	a, (hl)
	dec	a
	ld	hl, #767
	add	hl, sp
	ld	(hl), a
	jp	00127$
00126$:
;main.c:287: else if (was_input_depressed(&input_state, btn_down))
	ld	hl, #764
	add	hl, sp
	ld	a, (hl)
	ld	hl, #794
	add	hl, sp
	ld	(hl), a
	ld	hl, #765
	add	hl, sp
	ld	a, (hl)
	ld	hl, #795
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
	jr	Z, 00123$
;main.c:289: cursor_tile_y += 1;
	ld	hl, #792
	add	hl, sp
	ld	a, (hl)
	inc	a
	ld	hl, #767
	add	hl, sp
	ld	(hl), a
	jr	00127$
00123$:
;main.c:291: else if (was_input_depressed(&input_state, btn_left))
	ld	hl, #764
	add	hl, sp
	ld	a, (hl)
	ld	hl, #794
	add	hl, sp
	ld	(hl), a
	ld	hl, #765
	add	hl, sp
	ld	a, (hl)
	ld	hl, #795
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
;main.c:293: cursor_tile_x -= 1;
	ld	hl, #766
	add	hl, sp
	ld	a, (hl)
	ld	hl, #792
	add	hl, sp
	ld	(hl), a
;main.c:291: else if (was_input_depressed(&input_state, btn_left))
	ld	a, e
	or	a, a
	jr	Z, 00120$
;main.c:293: cursor_tile_x -= 1;
	ld	a, (hl)
	dec	a
	ld	hl, #766
	add	hl, sp
	ld	(hl), a
	jr	00127$
00120$:
;main.c:295: else if (was_input_depressed(&input_state, btn_right))
	ld	hl, #764
	add	hl, sp
	ld	a, (hl)
	ld	hl, #794
	add	hl, sp
	ld	(hl), a
	ld	hl, #765
	add	hl, sp
	ld	a, (hl)
	ld	hl, #795
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
	jr	Z, 00127$
;main.c:297: cursor_tile_x += 1;
	ld	hl, #792
	add	hl, sp
	ld	a, (hl)
	inc	a
	ld	hl, #766
	add	hl, sp
	ld	(hl), a
00127$:
;main.c:302: ? 19
	ld	hl, #766
	add	hl, sp
	ld	a, (hl)
	inc	a
	jr	NZ, 00210$
	ld	hl, #794
	add	hl, sp
	ld	a, #0x13
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
	jr	00211$
00210$:
;main.c:304: ? 0
	ld	a, #0x13
	ld	hl, #766
	add	hl, sp
	sub	a, (hl)
	jr	NC, 00212$
	xor	a, a
	ld	hl, #794
	add	hl, sp
	ld	(hl+), a
	ld	(hl), a
	jr	00213$
00212$:
;main.c:305: : cursor_tile_x;
	ld	hl, #766
	add	hl, sp
	ld	a, (hl)
	ld	hl, #794
	add	hl, sp
	ld	(hl+), a
	ld	(hl), #0x00
00213$:
00211$:
	ld	hl, #794
	add	hl, sp
	ld	a, (hl)
	ld	hl, #766
	add	hl, sp
;main.c:309: ? 17
	ld	(hl+), a
	ld	a, (hl)
	inc	a
	jr	NZ, 00214$
	ld	hl, #794
	add	hl, sp
	ld	a, #0x11
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
	jr	00215$
00214$:
;main.c:311: ? 0
	ld	a, #0x11
	ld	hl, #767
	add	hl, sp
	sub	a, (hl)
	jr	NC, 00216$
	xor	a, a
	ld	hl, #794
	add	hl, sp
	ld	(hl+), a
	ld	(hl), a
	jr	00217$
00216$:
;main.c:312: : cursor_tile_y;
	ld	hl, #767
	add	hl, sp
	ld	a, (hl)
	ld	hl, #794
	add	hl, sp
	ld	(hl+), a
	ld	(hl), #0x00
00217$:
00215$:
	ld	hl, #794
	add	hl, sp
	ld	a, (hl)
	ld	hl, #767
	add	hl, sp
	ld	(hl), a
;main.c:314: update_cursor_position(cursor_tile_x, cursor_tile_y);
	ld	a, (hl-)
	ld	d, a
	ld	e, (hl)
	push	de
	call	_update_cursor_position
	pop	hl
;main.c:317: if (was_input_depressed(&input_state, btn_b))
	ld	hl, #764
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
	jp	Z, 00137$
;main.c:319: uint16_t board_index = cursor_tile_x + (cursor_tile_y * 20);
	ld	hl, #766
	add	hl, sp
	ld	a, (hl+)
	ld	c, a
	ld	b, #0x00
	ld	a, (hl)
	ld	hl, #794
	add	hl, sp
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, bc
;main.c:320: uint16_t tile_data = board[board_index];
	add	hl, hl
	ld	c, l
	ld	b, h
	ld	hl, #770
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, #791
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #790
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	hl, #787
	add	hl, sp
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
;main.c:321: uint8_t is_alive = tile_data & k_tile_is_alive_mask;
	ld	hl, #_k_tile_is_alive_mask
	ld	a, (hl+)
	ld	c, (hl)
	ld	hl, #787
	add	hl, sp
	ld	b, (hl)
	and	a, b
	ld	hl, #795
	add	hl, sp
	ld	(hl), a
;main.c:323: if (!is_alive)
	ld	a, (hl)
	or	a, a
	jp	NZ, 00131$
;main.c:325: if (next_available_sprite_index < 39)
	inc	hl
	ld	a, (hl)
	sub	a, #0x27
	jp	NC, 00132$
;main.c:328: uint8_t sprite_index = available_sprites[next_available_sprite_index];
	ld	hl,#0x300
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #796
	add	hl, sp
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	hl, #795
	add	hl, sp
;main.c:329: next_available_sprite_index++;
	ld	(hl+), a
	inc	(hl)
;main.c:332: update_tile_sprite(sprite_index, k_live_tile_index);
	ld	a, (#_k_live_tile_index)
	push	af
	inc	sp
	ld	hl, #796
	add	hl, sp
	ld	a, (hl)
	push	af
	inc	sp
	call	_update_tile_sprite
	pop	hl
;main.c:333: update_tile_position(sprite_index, cursor_tile_x, cursor_tile_y);
	ld	hl, #767
	add	hl, sp
	ld	a, (hl-)
	ld	d, a
	ld	e, (hl)
	push	de
	ld	hl, #797
	add	hl, sp
	ld	a, (hl)
	push	af
	inc	sp
	call	_update_tile_position
	add	sp, #3
;main.c:336: tile_data |= sprite_index << 8;
	ld	hl, #795
	add	hl, sp
	ld	a, (hl-)
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl-)
	dec	hl
	ld	(hl-), a
	ld	(hl), #0x00
	ld	hl, #787
	add	hl, sp
	ld	a, (hl)
	ld	hl, #794
	add	hl, sp
	ld	(hl), a
	ld	hl, #788
	add	hl, sp
	ld	a, (hl)
	ld	hl, #795
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl)
	ld	hl, #791
	add	hl, sp
	or	a, (hl)
	ld	hl, #787
	add	hl, sp
	ld	(hl), a
	ld	hl, #795
	add	hl, sp
	ld	a, (hl)
	ld	hl, #792
	add	hl, sp
	or	a, (hl)
	ld	hl, #788
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl)
	ld	hl, #794
	add	hl, sp
	ld	(hl), a
	ld	hl, #788
	add	hl, sp
	ld	a, (hl)
	ld	hl, #795
	add	hl, sp
	ld	(hl), a
;main.c:339: tile_data |= k_tile_is_alive_mask;
	ld	a, (#_k_tile_is_alive_mask)
	ld	hl, #791
	add	hl, sp
	ld	(hl), a
	ld	a, (#_k_tile_is_alive_mask + 1)
	ld	hl, #792
	add	hl, sp
	ld	(hl+), a
	inc	hl
	ld	a, (hl)
	ld	hl, #791
	add	hl, sp
	or	a, (hl)
	ld	hl, #787
	add	hl, sp
	ld	(hl), a
	ld	hl, #795
	add	hl, sp
	ld	a, (hl)
	ld	hl, #792
	add	hl, sp
	or	a, (hl)
	ld	hl, #788
	add	hl, sp
	ld	(hl), a
	jp	00132$
00131$:
;main.c:345: uint8_t sprite_index = (tile_data & k_tile_sprite_index_mask) >> 8;
	ld	a, (#_k_tile_sprite_index_mask)
	ld	hl, #791
	add	hl, sp
	ld	(hl), a
	ld	a, (#_k_tile_sprite_index_mask + 1)
	ld	hl, #792
	add	hl, sp
	ld	(hl), a
	ld	hl, #787
	add	hl, sp
	ld	a, (hl)
	ld	hl, #791
	add	hl, sp
	and	a, (hl)
	ld	hl, #794
	add	hl, sp
	ld	(hl), a
	ld	hl, #788
	add	hl, sp
	ld	a, (hl)
	ld	hl, #792
	add	hl, sp
	and	a, (hl)
	ld	hl, #795
	add	hl, sp
	ld	(hl), a
;main.c:348: update_tile_sprite(sprite_index, k_empty_tile_index);
	ld	a, (#_k_empty_tile_index)
	push	af
	inc	sp
	ld	hl, #796
	add	hl, sp
	ld	a, (hl)
	push	af
	inc	sp
	call	_update_tile_sprite
	pop	hl
;main.c:349: update_tile_position(sprite_index, 21, 19);
	ld	hl, #0x1315
	push	hl
	ld	hl, #797
	add	hl, sp
	ld	a, (hl)
	push	af
	inc	sp
	call	_update_tile_position
	add	sp, #3
;main.c:352: next_available_sprite_index--;
	ld	hl, #796
	add	hl, sp
	dec	(hl)
;main.c:353: available_sprites[next_available_sprite_index] = sprite_index;
	ld	hl,#0x300
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #796
	add	hl, sp
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, #795
	add	hl, sp
	ld	a, (hl)
	ld	(bc), a
;main.c:356: tile_data &= ~k_tile_sprite_index_mask;
	ld	a, (#_k_tile_sprite_index_mask)
	ld	hl, #794
	add	hl, sp
	ld	(hl), a
	ld	a, (#_k_tile_sprite_index_mask + 1)
	ld	hl, #795
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl)
	cpl
	ld	hl, #791
	add	hl, sp
	ld	(hl), a
	ld	hl, #795
	add	hl, sp
	ld	a, (hl)
	cpl
	ld	hl, #792
	add	hl, sp
	ld	(hl), a
	ld	hl, #787
	add	hl, sp
	ld	a, (hl)
	ld	hl, #791
	add	hl, sp
	and	a, (hl)
	ld	hl, #794
	add	hl, sp
	ld	(hl), a
	ld	hl, #788
	add	hl, sp
	ld	a, (hl)
	ld	hl, #792
	add	hl, sp
	and	a, (hl)
	ld	hl, #795
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl)
	ld	hl, #791
	add	hl, sp
	ld	(hl), a
	ld	hl, #795
	add	hl, sp
	ld	a, (hl)
	ld	hl, #792
	add	hl, sp
	ld	(hl), a
;main.c:359: tile_data &= ~k_tile_is_alive_mask;
	ld	a, (#_k_tile_is_alive_mask)
	ld	hl, #794
	add	hl, sp
	ld	(hl), a
	ld	a, (#_k_tile_is_alive_mask + 1)
	ld	hl, #795
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl)
	cpl
	ld	(hl+), a
	ld	a, (hl)
	cpl
	ld	(hl), a
	ld	hl, #791
	add	hl, sp
	ld	a, (hl)
	ld	hl, #794
	add	hl, sp
	and	a, (hl)
	ld	hl, #787
	add	hl, sp
	ld	(hl), a
	ld	hl, #792
	add	hl, sp
	ld	a, (hl)
	ld	hl, #795
	add	hl, sp
	and	a, (hl)
	ld	hl, #788
	add	hl, sp
	ld	(hl), a
00132$:
;main.c:363: board[board_index] = tile_data;
	ld	hl,#0x315
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #787
	add	hl, sp
	ld	a, (hl+)
	ld	(de), a
	inc	de
	ld	a, (hl)
	ld	(de), a
00137$:
;main.c:368: wait_vbls_done(1);
	ld	a, #0x01
	push	af
	inc	sp
	call	_wait_vbls_done
	inc	sp
	jp	00139$
;main.c:370: }
	ld	hl, #797
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
