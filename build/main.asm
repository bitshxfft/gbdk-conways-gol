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
	.globl _update_cursor_position
	.globl _update_cursor_sprite
	.globl _is_input_held
	.globl _was_input_released
	.globl _was_input_depressed
	.globl _update_input_state
	.globl _set_sprite_data
	.globl _set_bkg_tiles
	.globl _set_bkg_data
	.globl _joypad
	.globl _sprites
	.globl _background_tiles
	.globl _background_map
	.globl _highlight_sprite_index
	.globl _highlight_live_tile_index
	.globl _highlight_empty_tile_index
	.globl _live_tile_index
	.globl _empty_tile_index
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
_background_map::
	.ds 360
_background_tiles::
	.ds 32
_sprites::
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
	add	sp, #-3
;input.h:34: is->previous_state = is->current_state;
	ldhl	sp,	#5
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#6
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
;input.h:37: is->current_state = (button_state == J_A) << btn_a;
	ldhl	sp,	#7
	ld	a, (hl)
	sub	a, #0x10
	ld	a, #0x01
	jr	Z, 00104$
	xor	a, a
00104$:
;input.h:38: is->current_state |= (button_state == J_B) << btn_b;
	ld	(bc), a
	ld	e, a
	ldhl	sp,	#7
	ld	a, (hl)
	sub	a, #0x20
	ld	a, #0x01
	jr	Z, 00106$
	xor	a, a
00106$:
	add	a, a
	or	a, e
	ld	e, a
	ld	(bc), a
;input.h:39: is->current_state |= (button_state == J_UP) << btn_up;
	ldhl	sp,	#7
	ld	a, (hl)
	sub	a, #0x04
	ld	a, #0x01
	jr	Z, 00108$
	xor	a, a
00108$:
	add	a, a
	add	a, a
	or	a, e
	ld	e, a
	ld	(bc), a
;input.h:40: is->current_state |= (button_state == J_DOWN) << btn_down;
	ldhl	sp,	#7
	ld	a, (hl)
	sub	a, #0x08
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
;input.h:41: is->current_state |= (button_state == J_LEFT) << btn_left;
	ldhl	sp,	#7
	ld	a, (hl)
	sub	a, #0x02
	ld	a, #0x01
	jr	Z, 00112$
	xor	a, a
00112$:
	swap	a
	and	a, #0xf0
	or	a, e
	ld	e, a
	ld	(bc), a
;input.h:42: is->current_state |= (button_state == J_RIGHT) << btn_right;
	ldhl	sp,	#7
	ld	a, (hl)
	dec	a
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
;input.h:43: is->current_state |= (button_state == J_START) << btn_start;
	ldhl	sp,	#7
	ld	a, (hl)
	sub	a, #0x80
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
;input.h:44: is->current_state |= (button_state == J_SELECT) << btn_select;
	ldhl	sp,	#7
	ld	a, (hl)
	sub	a, #0x40
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
	add	sp, #3
	ret
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
;main.c:46: void update_cursor_sprite(uint8_t tile_index)
;	---------------------------------
; Function update_cursor_sprite
; ---------------------------------
_update_cursor_sprite::
;main.c:48: set_sprite_tile(highlight_sprite_index, tile_index);
	ldhl	sp,	#2
	ld	c, (hl)
	ld	hl, #_highlight_sprite_index
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
;main.c:48: set_sprite_tile(highlight_sprite_index, tile_index);
;main.c:49: }
	ret
_s_execution_state_active_mask:
	.db #0x02	; 2
_s_tile_is_alive_mask:
	.db #0x01	; 1
_s_tile_was_alive_mask:
	.db #0x02	; 2
_s_tile_is_north_row_mask:
	.db #0x04	; 4
_s_tile_is_south_row_mask:
	.db #0x08	; 8
_s_tile_is_west_column_mask:
	.db #0x10	; 16
_s_tile_is_east_column_mask:
	.db #0x20	; 32
_empty_tile_index:
	.db #0x00	; 0
_live_tile_index:
	.db #0x01	; 1
_highlight_empty_tile_index:
	.db #0x02	; 2
_highlight_live_tile_index:
	.db #0x03	; 3
_highlight_sprite_index:
	.db #0x00	; 0
;main.c:51: void update_cursor_position(uint8_t tile_x, uint8_t tile_y)
;	---------------------------------
; Function update_cursor_position
; ---------------------------------
_update_cursor_position::
;main.c:55: SCREEN_MIN_Y + (tile_y * SPRITE_TILE_HEIGHT));
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
;main.c:54: SCREEN_MIN_X + (tile_x * SPRITE_TILE_WIDTH),
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
	ld	hl, #_highlight_sprite_index
;main.c:55: SCREEN_MIN_Y + (tile_y * SPRITE_TILE_HEIGHT));
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
;main.c:55: SCREEN_MIN_Y + (tile_y * SPRITE_TILE_HEIGHT));
;main.c:56: }
	ret
;main.c:60: int main()
;	---------------------------------
; Function main
; ---------------------------------
_main::
	ld	hl, #-393
	add	hl, sp
	ld	sp, hl
;main.c:67: input_state.previous_state = 0x00;
	ldhl	sp,	#0
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
;main.c:68: input_state.current_state = 0x00;
	ldhl	sp,	#0
	ld	a, l
	ld	d, h
	ld	hl, #367
	add	hl, sp
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
;main.c:69: input_state.held_buttons = 0x00;
	ld	a, (hl-)
	ld	b, a
	inc	bc
	xor	a, a
	ld	(bc), a
	ld	a, (hl+)
	ld	c, a
;main.c:70: input_state.depressed_buttons = 0x00;
	ld	a, (hl-)
	ld	b, a
	inc	bc
	inc	bc
	xor	a, a
	ld	(bc), a
	ld	a, (hl+)
	ld	c, a
;main.c:71: input_state.released_buttons = 0x00;
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
;main.c:74: uint8_t execution_state = 0x00;
	ld	hl, #390
	add	hl, sp
	ld	(hl), #0x00
;main.c:76: uint8_t highlight_tile_position[2] = { 10, 9 };
	ldhl	sp,	#5
	ld	a, l
	ld	d, h
	ld	hl, #369
	add	hl, sp
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x0a
	ld	hl,#0x171
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ld	hl, #373
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #372
	add	hl, sp
	ld	(hl-), a
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x09
;main.c:83: for (i = 0; i < 360; ++i)
	ldhl	sp,	#7
	ld	a, l
	ld	d, h
	ld	hl, #373
	add	hl, sp
	ld	(hl+), a
	ld	(hl), d
	xor	a, a
	ld	hl, #391
	add	hl, sp
	ld	(hl+), a
	ld	(hl), a
00123$:
;main.c:85: uint8_t tile_data = 0x00;
	ld	c, #0x00
;main.c:86: tile_data |= (i < 20 ? s_tile_is_north_row_mask : 0x00);
	ld	hl, #391
	add	hl, sp
	ld	a, (hl)
	ld	hl, #385
	add	hl, sp
	ld	(hl), a
	ld	hl, #392
	add	hl, sp
	ld	a, (hl)
	ld	hl, #386
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	sub	a, #0x14
	ld	a, (hl)
	sbc	a, #0x00
	jr	NC, 00133$
	ld	a, (#_s_tile_is_north_row_mask)
	ld	b, #0x00
	jr	00134$
00133$:
	xor	a, a
	ld	b, a
00134$:
	or	a, c
	ld	hl, #387
	add	hl, sp
;main.c:87: tile_data |= (i >= 340 ? s_tile_is_south_row_mask : 0x00);
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	sub	a, #0x54
	ld	a, (hl)
	sbc	a, #0x01
	jr	C, 00135$
	ld	a, (#_s_tile_is_south_row_mask)
	ld	hl, #388
	add	hl, sp
	ld	(hl+), a
	ld	(hl), #0x00
	jr	00136$
00135$:
	xor	a, a
	ld	hl, #388
	add	hl, sp
	ld	(hl+), a
	ld	(hl), a
00136$:
	ld	hl, #388
	add	hl, sp
	ld	a, (hl-)
	or	a, (hl)
;main.c:88: tile_data |= (i % 20 == 0 ? s_tile_is_west_column_mask : 0x00);
	dec	hl
	dec	hl
	ld	c, a
	push	bc
	ld	de, #0x0014
	push	de
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	call	__moduint
	add	sp, #4
	pop	bc
	ld	a, d
	or	a, e
	jr	NZ, 00137$
	ld	a, (#_s_tile_is_west_column_mask)
	jr	00138$
00137$:
	xor	a, a
00138$:
	or	a, c
	ld	c, a
;main.c:89: tile_data |= (i % 20== 19 ? s_tile_is_east_column_mask : 0x00);
	ld	a, e
	sub	a, #0x13
	or	a, d
	jr	NZ, 00139$
	ld	a, (#_s_tile_is_east_column_mask)
	jr	00140$
00139$:
	xor	a, a
00140$:
	or	a, c
	ld	c, a
;main.c:90: board[i] = tile_data;
	ld	hl,#0x175
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #391
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, c
	ld	(de), a
;main.c:83: for (i = 0; i < 360; ++i)
	ld	hl, #391
	add	hl, sp
	inc	(hl)
	jr	NZ, 00352$
	inc	hl
	inc	(hl)
00352$:
	ld	hl, #391
	add	hl, sp
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, c
	sub	a, #0x68
	ld	a, b
	sbc	a, #0x01
	jp	C, 00123$
;main.c:94: set_sprite_data(0, 3, sprites);
	ld	de, #_sprites
	push	de
	ld	hl, #0x300
	push	hl
	call	_set_sprite_data
	add	sp, #4
;main.c:95: set_bkg_data(0, 2, background_tiles);
	ld	de, #_background_tiles
	push	de
	ld	hl, #0x200
	push	hl
	call	_set_bkg_data
	add	sp, #4
;main.c:98: set_bkg_tiles(0, 0, 20, 18, background_map);
	ld	de, #_background_map
	push	de
	ld	hl, #0x1214
	push	hl
	xor	a, a
	rrca
	push	af
	call	_set_bkg_tiles
	add	sp, #6
;main.c:101: update_cursor_sprite(highlight_empty_tile_index);
	ld	a, (#_highlight_empty_tile_index)
	push	af
	inc	sp
	call	_update_cursor_sprite
	inc	sp
;main.c:102: update_cursor_position(highlight_tile_position[0], highlight_tile_position[1]);
	ld	hl,#0x173
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	dec	hl
	ld	d, a
	ld	a, (de)
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	push	bc
	inc	sp
	push	af
	inc	sp
	call	_update_cursor_position
	pop	hl
;main.c:104: SHOW_BKG;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x01
	ldh	(_LCDC_REG + 0), a
;main.c:105: SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;main.c:106: DISPLAY_ON;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;main.c:108: while (1)
00121$:
;main.c:110: update_input_state(&input_state, joypad());
	call	_joypad
	ld	a, e
	ld	hl, #367
	add	hl, sp
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	push	af
	inc	sp
	push	bc
	call	_update_input_state
	add	sp, #3
;main.c:113: if (was_input_released(&input_state, btn_start))
	ld	hl, #367
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
	jr	Z, 00103$
;main.c:115: execution_state ^= s_execution_state_active_mask;
	ld	hl, #_s_execution_state_active_mask
	ld	c, (hl)
	ld	hl, #390
	add	hl, sp
	ld	a, (hl)
	xor	a, c
	ld	(hl), a
;main.c:117: (execution_state & s_execution_state_active_mask) == s_execution_state_active_mask
	ld	a, (hl)
	and	a, c
	sub	a, c
	jr	NZ, 00141$
;main.c:118: ? empty_tile_index
	ld	a, (#_empty_tile_index)
	jr	00142$
00141$:
;main.c:119: : highlight_empty_tile_index);
	ld	a, (#_highlight_empty_tile_index)
00142$:
	push	af
	inc	sp
	call	_update_cursor_sprite
	inc	sp
00103$:
;main.c:123: if ((execution_state & s_execution_state_active_mask) == s_execution_state_active_mask)
	ld	hl, #_s_execution_state_active_mask
	ld	c, (hl)
	ld	hl, #390
	add	hl, sp
	ld	a, (hl)
	and	a, c
	sub	a, c
	jp	NZ,00118$
;main.c:126: for (uint16_t i = 0; i < 360; ++i)
	ld	bc, #0x0000
00126$:
	ld	e, c
	ld	d, b
	ld	a, e
	sub	a, #0x68
	ld	a, d
	sbc	a, #0x01
	jr	NC, 00104$
;main.c:128: uint8_t tile_data = board[i];
	ld	hl, #373
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	h, a
;	spillPairReg hl
;	spillPairReg hl
;main.c:130: board[i] = (tile_data & ~s_tile_was_alive_mask) | ((tile_data & s_tile_is_alive_mask) << tile_was_alive);
	ld	a, (_s_tile_was_alive_mask)
;	spillPairReg hl
;	spillPairReg hl
	cpl
	and	a, h
	ld	l, a
;	spillPairReg hl
;	spillPairReg hl
	push	hl
	ld	a, (#_s_tile_is_alive_mask)
	pop	hl
	and	a, h
	add	a, a
	or	a, l
	ld	(de), a
;main.c:126: for (uint16_t i = 0; i < 360; ++i)
	inc	bc
	jr	00126$
00104$:
;main.c:134: for (uint16_t i = 0; i < 360; ++i)
	xor	a, a
	ld	hl, #391
	add	hl, sp
	ld	(hl+), a
	ld	(hl), a
00129$:
	ld	hl, #391
	add	hl, sp
	ld	a, (hl)
	ld	hl, #375
	add	hl, sp
	ld	(hl), a
	ld	hl, #392
	add	hl, sp
	ld	a, (hl)
	ld	hl, #376
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	sub	a, #0x68
	ld	a, (hl)
	sbc	a, #0x01
	jp	NC, 00121$
;main.c:136: uint8_t tile_data = board[i];
	ld	hl,#0x187
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #373
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, #379
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #378
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
;main.c:137: uint8_t neighbour_count = 0;
	ld	(hl+), a
	ld	(hl), #0x00
;main.c:139: uint8_t is_not_north = (tile_data & s_tile_is_north_row_mask) == 0x00;
	ld	a, (#_s_tile_is_north_row_mask)
	ld	hl, #379
	add	hl, sp
	and	a,(hl)
	ld	a, #0x01
	jr	Z, 00358$
	xor	a, a
00358$:
	ld	hl, #381
	add	hl, sp
	ld	(hl), a
;main.c:140: uint8_t is_not_east = (tile_data & s_tile_is_east_column_mask) == 0x00;
	ld	a, (#_s_tile_is_east_column_mask)
	ld	hl, #379
	add	hl, sp
	and	a,(hl)
	ld	a, #0x01
	jr	Z, 00360$
	xor	a, a
00360$:
	ld	hl, #382
	add	hl, sp
	ld	(hl), a
;main.c:141: uint8_t is_not_south = (tile_data & s_tile_is_south_row_mask) == 0x00;
	ld	a, (#_s_tile_is_south_row_mask)
	ld	hl, #379
	add	hl, sp
	and	a,(hl)
	ld	a, #0x01
	jr	Z, 00362$
	xor	a, a
00362$:
	ld	hl, #383
	add	hl, sp
	ld	(hl), a
;main.c:142: uint8_t is_not_west = (tile_data & s_tile_is_west_column_mask) == 0x00;
	ld	a, (#_s_tile_is_west_column_mask)
	ld	hl, #379
	add	hl, sp
	and	a,(hl)
	ld	a, #0x01
	jr	Z, 00364$
	xor	a, a
00364$:
	ld	hl, #384
	add	hl, sp
	ld	(hl), a
;main.c:130: board[i] = (tile_data & ~s_tile_was_alive_mask) | ((tile_data & s_tile_is_alive_mask) << tile_was_alive);
	ld	a, (#_s_tile_was_alive_mask)
	ld	hl, #385
	add	hl, sp
	ld	(hl), a
;main.c:145: neighbour_count += is_not_north
	ld	hl, #381
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00143$
;main.c:146: && (board[i - 20] & s_tile_was_alive_mask) != 0x00;
	ld	hl,#0x177
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
	ld	hl, #387
	add	hl, sp
	ld	(hl-), a
	ld	a, e
	ld	(hl+), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #373
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, #390
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #389
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	hl, #385
	add	hl, sp
	and	a,(hl)
	jr	NZ, 00144$
00143$:
	xor	a, a
	jr	00145$
00144$:
	ld	a, #0x01
00145$:
	ld	hl, #380
	add	hl, sp
	ld	c, (hl)
	add	a, c
	ld	hl, #389
	add	hl, sp
	ld	(hl), a
;main.c:149: neighbour_count += is_not_north	&& is_not_east
	ld	hl, #381
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00146$
	inc	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00146$
;main.c:150: && (board[i - 19] & s_tile_was_alive_mask) != 0x00;
	ld	hl,#0x177
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
	ld	b, a
	ld	c, e
	ld	hl, #373
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	hl, #385
	add	hl, sp
	and	a,(hl)
	jr	NZ, 00147$
00146$:
	xor	a, a
	jr	00148$
00147$:
	ld	a, #0x01
00148$:
	ld	hl, #389
	add	hl, sp
	ld	c, (hl)
	add	a, c
	ld	c, a
;main.c:153: neighbour_count += is_not_east
	ld	hl, #382
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00152$
;main.c:154: && (board[i + 1] & s_tile_was_alive_mask) != 0x00;
	ld	hl, #375
	add	hl, sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	inc	de
	ld	hl, #373
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	hl, #385
	add	hl, sp
	and	a,(hl)
	jr	NZ, 00153$
00152$:
	xor	a, a
	jr	00154$
00153$:
	ld	a, #0x01
00154$:
	add	a, c
	ld	c, a
;main.c:157: neighbour_count += is_not_south && is_not_east
	ld	hl, #383
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00155$
	dec	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00155$
;main.c:158: && (board[i + 21] & s_tile_was_alive_mask) != 0x00;
	ld	hl,#0x177
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0015
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, #373
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	hl, #385
	add	hl, sp
	and	a,(hl)
	jr	NZ, 00156$
00155$:
	xor	a, a
	jr	00157$
00156$:
	ld	a, #0x01
00157$:
	add	a, c
	ld	c, a
;main.c:161: neighbour_count += is_not_south
	ld	hl, #383
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00161$
;main.c:162: && (board[i + 20] & s_tile_was_alive_mask) != 0x00;
	ld	hl,#0x177
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0014
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, #373
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	hl, #385
	add	hl, sp
	and	a,(hl)
	jr	NZ, 00162$
00161$:
	xor	a, a
	jr	00163$
00162$:
	ld	a, #0x01
00163$:
	add	a, c
	ld	c, a
;main.c:165: neighbour_count += is_not_south && is_not_west
	ld	hl, #383
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00164$
	inc	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00164$
;main.c:166: && (board[i + 19] & s_tile_was_alive_mask) != 0x00;
	ld	hl,#0x177
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0013
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, #373
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	hl, #385
	add	hl, sp
	and	a,(hl)
	jr	NZ, 00165$
00164$:
	xor	a, a
	jr	00166$
00165$:
	ld	a, #0x01
00166$:
	add	a, c
	ld	hl, #383
	add	hl, sp
;main.c:169: neighbour_count += is_not_west
	ld	(hl+), a
	ld	a, (hl)
	or	a, a
	jr	Z, 00170$
;main.c:170: && (board[i - 1] & s_tile_was_alive_mask) != 0x00;
	ld	hl,#0x177
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
	ld	hl, #387
	add	hl, sp
	ld	(hl-), a
	ld	a, e
	ld	(hl+), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #373
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, #390
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #389
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	hl, #385
	add	hl, sp
	and	a,(hl)
	jr	NZ, 00171$
00170$:
	xor	a, a
	jr	00172$
00171$:
	ld	a, #0x01
00172$:
	ld	hl, #383
	add	hl, sp
	ld	c, (hl)
	add	a, c
	ld	hl, #389
	add	hl, sp
	ld	(hl), a
;main.c:173: neighbour_count += is_not_north && is_not_west
	ld	hl, #381
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00173$
	ld	hl, #384
	add	hl, sp
	ld	a, (hl)
	or	a, a
	jr	Z, 00173$
;main.c:174: && (board[i - 21] & s_tile_was_alive_mask) != 0x00;
	ld	hl,#0x177
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
	ld	hl, #388
	add	hl, sp
	ld	(hl-), a
	ld	(hl), e
	ld	hl,#0x175
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #387
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, #385
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #384
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	hl, #388
	add	hl, sp
	ld	(hl), a
	ld	a, (hl)
	ld	hl, #385
	add	hl, sp
	and	a,(hl)
	jr	NZ, 00174$
00173$:
	ld	hl, #388
	add	hl, sp
	ld	(hl), #0x00
	jr	00175$
00174$:
	ld	hl, #388
	add	hl, sp
	ld	(hl), #0x01
00175$:
	ld	hl, #388
	add	hl, sp
	ld	a, (hl+)
	ld	c, (hl)
	add	a, c
	ld	hl, #386
	add	hl, sp
	ld	(hl), a
;main.c:177: uint8_t is_alive = (tile_data & s_tile_is_alive_mask) != 0x00;
	ld	a, (#_s_tile_is_alive_mask)
	ld	hl, #389
	add	hl, sp
	ld	(hl), a
	ld	hl, #379
	add	hl, sp
	ld	a, (hl)
	ld	hl, #389
	add	hl, sp
	and	a, (hl)
	dec	hl
	sub	a, #0x01
	ld	a, #0x00
	rla
	xor	a, #0x01
	ld	(hl), a
;main.c:178: uint8_t come_to_life = !is_alive && neighbour_count == 3;
	ld	a, (hl)
	or	a, a
	jr	NZ, 00179$
	dec	hl
	dec	hl
	ld	a, (hl)
	sub	a, #0x03
	jr	Z, 00180$
00179$:
	xor	a, a
	jr	00181$
00180$:
	ld	a, #0x01
00181$:
	ld	hl, #387
	add	hl, sp
;main.c:183: uint8_t remain_alive = is_alive && neighbour_count >= 2 && neighbour_count <= 3;
	ld	(hl+), a
	ld	a, (hl)
	or	a, a
	jr	Z, 00182$
	dec	hl
	dec	hl
	ld	a, (hl)
	sub	a, #0x02
	jr	C, 00182$
	ld	a, #0x03
	sub	a, (hl)
	jr	NC, 00183$
00182$:
	ld	hl, #388
	add	hl, sp
	ld	(hl), #0x00
	jr	00184$
00183$:
	ld	hl, #388
	add	hl, sp
	ld	(hl), #0x01
00184$:
;main.c:186: board[i] = (tile_data & ~s_tile_is_alive_mask)
	ld	hl, #389
	add	hl, sp
	ld	a, (hl)
	cpl
	ld	(hl), a
	ld	a, (hl)
	ld	hl, #379
	add	hl, sp
	and	a, (hl)
	ld	hl, #389
	add	hl, sp
;main.c:187: | ((come_to_life | remain_alive) << tile_is_alive);
	ld	(hl-), a
	ld	a, (hl-)
	or	a, (hl)
	inc	hl
	ld	(hl), a
	ld	a, (hl+)
	or	a, (hl)
	ld	c, a
	ld	hl, #377
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), c
;main.c:134: for (uint16_t i = 0; i < 360; ++i)
	ld	hl, #391
	add	hl, sp
	inc	(hl)
	jp	NZ,00129$
	inc	hl
	inc	(hl)
	jp	00129$
00118$:
;main.c:195: if (was_input_depressed(&input_state, btn_up))
	ld	hl, #367
	add	hl, sp
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, #0x02
	push	af
	inc	sp
	push	bc
	call	_was_input_depressed
	add	sp, #3
	ld	a, e
	or	a, a
	jr	Z, 00115$
;main.c:197: highlight_tile_position[1] -= 1;
	ld	hl,#0x173
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	dec	c
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	ld	(hl), c
	jr	00116$
00115$:
;main.c:199: else if (was_input_depressed(&input_state, btn_down))
	ld	hl, #367
	add	hl, sp
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, #0x03
	push	af
	inc	sp
	push	bc
	call	_was_input_depressed
	add	sp, #3
	ld	a, e
	or	a, a
	jr	Z, 00112$
;main.c:201: highlight_tile_position[1] += 1;
	ld	hl,#0x173
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	c
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	ld	(hl), c
	jr	00116$
00112$:
;main.c:203: else if (was_input_depressed(&input_state, btn_left))
	ld	hl, #367
	add	hl, sp
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, #0x04
	push	af
	inc	sp
	push	bc
	call	_was_input_depressed
	add	sp, #3
	ld	a, e
	or	a, a
	jr	Z, 00109$
;main.c:205: highlight_tile_position[0] -= 1;
	ld	hl,#0x171
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	dec	c
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	ld	(hl), c
	jr	00116$
00109$:
;main.c:207: else if (was_input_depressed(&input_state, btn_right))
	ld	hl, #367
	add	hl, sp
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, #0x05
	push	af
	inc	sp
	push	bc
	call	_was_input_depressed
	add	sp, #3
	ld	a, e
	or	a, a
	jr	Z, 00116$
;main.c:209: highlight_tile_position[0] += 1;
	ld	hl,#0x171
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	c
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	ld	(hl), c
00116$:
;main.c:212: update_cursor_position(highlight_tile_position[0], highlight_tile_position[1]);
	ld	hl,#0x173
	add	hl,sp
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	dec	hl
	ld	d, a
	ld	a, (de)
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	push	bc
	inc	sp
	push	af
	inc	sp
	call	_update_cursor_position
	pop	hl
	jp	00121$
;main.c:215: }
	ld	hl, #393
	add	hl, sp
	ld	sp, hl
	ret
	.area _CODE
	.area _INITIALIZER
__xinit__background_map:
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
__xinit__background_tiles:
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
__xinit__sprites:
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
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
