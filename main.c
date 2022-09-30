#include <gb/gb.h>
#include <rand.h>
#include "background-map.h"
#include "background-tiles.h"
#include "constants.h"
#include "input.h"
#include "sprites.h"
#include "utility.h"

// ------------------------------------------------------------------------------------

enum e_execution_state_masks
{
	execution_state_active	= 1,
};

const uint8_t k_execution_state_active_mask = 1 << execution_state_active;

// ------------------------------------------------------------------------------------

enum e_tile_state_masks
{
	tile_is_alive		= 0,
	tile_was_alive		= 1,
	tile_is_north_row	= 2,
	tile_is_south_row	= 3,
	tile_is_west_column	= 4,
	tile_is_east_column	= 5,
};

const uint16_t k_tile_is_alive_mask = 1 << tile_is_alive;
const uint16_t k_tile_was_alive_mask = 1 << tile_was_alive;
const uint16_t s_tile_is_north_row_mask = 1 << tile_is_north_row;
const uint16_t k_tile_is_south_row_mask = 1 << tile_is_south_row;
const uint16_t k_tile_is_west_column_mask = 1 << tile_is_west_column;
const uint16_t k_tile_is_east_column_mask = 1 << tile_is_east_column;
const uint16_t k_tile_sprite_index_mask = 0xFF00; // 1111 1111 0000 0000

// ------------------------------------------------------------------------------------

const uint8_t k_empty_tile_index = 0;
const uint8_t k_live_tile_index = 1;
const uint8_t k_cursor_empty_tile_index = 2;
const uint8_t k_cursor_live_tile_index = 3;

// ------------------------------------------------------------------------------------

const uint8_t k_cursor_sprite_index = 0;

// ------------------------------------------------------------------------------------

void update_cursor_sprite(uint8_t tile_index)
{
	set_sprite_tile(k_cursor_sprite_index, tile_index);
}

void update_cursor_position(uint8_t tile_x, uint8_t tile_y)
{
	move_sprite(k_cursor_sprite_index,
		SCREEN_MIN_X + (tile_x * SPRITE_TILE_WIDTH),
		SCREEN_MIN_Y + (tile_y * SPRITE_TILE_HEIGHT));
}

void update_tile_sprite(uint8_t sprite_index, uint8_t tile_index)
{
	set_sprite_tile(sprite_index, tile_index);
}

void update_tile_position(uint8_t tile_index, uint8_t tile_x, uint8_t tile_y)
{
	move_sprite(tile_index,
		SCREEN_MIN_X + (tile_x * SPRITE_TILE_WIDTH),
		SCREEN_MIN_Y + (tile_y * SPRITE_TILE_HEIGHT));
}

// ------------------------------------------------------------------------------------

int main()
{
	// create our input state object
	struct input_state input_state;
	input_state.previous_state = 0x00;
	input_state.current_state = 0x00;
	input_state.held_buttons = 0x00;
	input_state.depressed_buttons = 0x00;
	input_state.released_buttons = 0x00;

	// execution state
	uint8_t execution_state = 0x00;

	// cursor position
	uint8_t cursor_tile_x = 10;
	uint8_t cursor_tile_y = 9;

	// screen width: 160 pixels, 20 tiles
	// screen height: 144 pixels, 18 tiles
	// total tiles: 360
	uint16_t board[360];

	// pool our available sprites
	uint8_t available_sprites[39];
	uint8_t next_available_sprite_index = 0;

	for (uint8_t i = 0; i < 39; ++i)
	{
		available_sprites[i] = i + 1;
		update_tile_sprite(i + 1, k_empty_tile_index);
		update_tile_position(i + 1, 21, 19);
	}

	for (uint16_t i = 0; i < 360; ++i)
	{
		uint16_t tile_data = 0x0000;
		tile_data |= (i < 20 ? s_tile_is_north_row_mask : 0x0000);
		tile_data |= (i >= 340 ? k_tile_is_south_row_mask : 0x0000);
		tile_data |= (i % 20 == 0 ? k_tile_is_west_column_mask : 0x0000);
		tile_data |= (i % 20 == 19 ? k_tile_is_east_column_mask : 0x0000);
		board[i] = tile_data;
	}

	// load sprites
	set_sprite_data(0, 3, k_sprites);
	set_bkg_data(0, 2, k_background_tiles);

	// initialise background
	set_bkg_tiles(0, 0, 20, 18, k_background_map);

	// initialise cursor
	update_cursor_sprite(k_cursor_empty_tile_index);
	update_cursor_position(cursor_tile_x, cursor_tile_y);

	SHOW_BKG;
	SHOW_SPRITES;
	DISPLAY_ON;

	while (1)
	{
		// update input state
		update_input_state(&input_state, joypad());

		// toggle execution state on start being pressed
		if (was_input_released(&input_state, btn_start))
		{
			execution_state ^= k_execution_state_active_mask;

			update_cursor_sprite(
				(execution_state & k_execution_state_active_mask) == k_execution_state_active_mask
					? k_empty_tile_index
					: k_cursor_empty_tile_index);
		}

		// game of life
		if ((execution_state & k_execution_state_active_mask) == k_execution_state_active_mask)
		{
			// set previous states
			for (uint16_t i = 0; i < 360; ++i)
			{
				uint8_t tile_data = board[i];

				// reset the was_alive flag
				tile_data &= ~k_tile_was_alive_mask;
				// update was_alive flag with the last frame's is_alive flag
				tile_data |= ((tile_data & k_tile_is_alive_mask) << tile_was_alive);

				board[i] = tile_data;
			}

			// run game of life
			for (uint16_t i = 0; i < 360; ++i)
			{
				uint16_t tile_data = board[i];
				uint8_t neighbour_count = 0;

				uint16_t is_not_north_row = (tile_data & s_tile_is_north_row_mask) == 0x00;
				uint16_t is_not_east_col = (tile_data & k_tile_is_east_column_mask) == 0x00;
				uint16_t is_not_south_row = (tile_data & k_tile_is_south_row_mask) == 0x00;
				uint16_t is_not_west_col = (tile_data & k_tile_is_west_column_mask) == 0x00;

				// north
				neighbour_count += is_not_north_row
					&& ((board[i - 20] & k_tile_was_alive_mask) != 0x00);

				// north-east
				neighbour_count += is_not_north_row	&& is_not_east_col
					&& ((board[i - 19] & k_tile_was_alive_mask) != 0x00);

				// east
				neighbour_count += is_not_east_col
					&& ((board[i + 1] & k_tile_was_alive_mask) != 0x00);

				// south-east
				neighbour_count += is_not_south_row && is_not_east_col
					&& ((board[i + 21] & k_tile_was_alive_mask) != 0x00);

				// south
				neighbour_count += is_not_south_row
					&& ((board[i + 20] & k_tile_was_alive_mask) != 0x00);

				// south-west
				neighbour_count += is_not_south_row && is_not_west_col
					&& ((board[i + 19] & k_tile_was_alive_mask) != 0x00);

				// west
				neighbour_count += is_not_west_col
					&& ((board[i - 1] & k_tile_was_alive_mask) != 0x00);

				// north-west
				neighbour_count += is_not_north_row && is_not_west_col
					&& ((board[i - 21] & k_tile_was_alive_mask) != 0x00);

				// a dead tile with exactly 3 live neighbours comes to life, otherwise it remains dead
				uint8_t is_alive = (tile_data & k_tile_is_alive_mask) != 0x00;
				uint8_t come_to_life = !is_alive && neighbour_count == 3;

				// a live tile with < 2 live neighbours dies
				// a live tile with > 3 live neighbours dies
				// a live tile with 2 or 3 live neighbours lives on
				uint8_t remain_alive = is_alive && neighbour_count >= 2 && neighbour_count <= 3;

				// un-set tile is alive mask, re-set if tile should remain alive or come to life
				tile_data &= ~k_tile_is_alive_mask;
				tile_data |= (come_to_life | remain_alive) << tile_is_alive;

				// get updated is_alive and was_alive flags
				is_alive = (tile_data & k_tile_is_alive_mask) != 0x00;
				uint8_t was_alive = (tile_data & k_tile_was_alive_mask) != 0x00;

				// update sprite state if anything has changed
				if (!was_alive && is_alive)
				{
					// tile has come alive
					if (next_available_sprite_index < 39)
					{
						// take a new sprite index from the pool
						uint8_t sprite_index = available_sprites[next_available_sprite_index];
						next_available_sprite_index++;

						// update this sprite to the correct tile sprite and position
						update_tile_sprite(sprite_index, k_live_tile_index);
						update_tile_position(sprite_index, i % 20, i / 20);

						// update the tile index in use
						tile_data |= sprite_index << 8;
					}
					else
					{
						// we have no availale sprites, cull this tile
						tile_data &= ~k_tile_is_alive_mask;
					}
				}
				else if (was_alive && !is_alive)
				{
					// debug - don't kill tiles
					tile_data |= k_tile_is_alive_mask;
					// \debug

//					// get the sprite index that was being used by this tile
//					uint8_t sprite_index = (tile_data & k_tile_sprite_index_mask) >> 8;
//
//					// update it to the empty tile sprite
//					update_tile_sprite(sprite_index, k_empty_tile_index);
//
//					// return the sprite to the pool
//					next_available_sprite_index--;
//					available_sprites[next_available_sprite_index] = sprite_index;
//
//					// un-set the sprite index from this tile
//					tile_data &= ~k_tile_sprite_index_mask;
				}

				board[i] = tile_data;
			}

			// debugging --------------------------------------
			// stop after first update of all tiles
			execution_state &= ~k_execution_state_active_mask;
			update_cursor_sprite(k_cursor_empty_tile_index);
			// -------------------------------------- debugging
		}
		else
		{
			// move cursor using d-pad
			if (was_input_depressed(&input_state, btn_up))
			{
				cursor_tile_y -= 1;
			}
			else if (was_input_depressed(&input_state, btn_down))
			{
				cursor_tile_y += 1;
			}
			else if (was_input_depressed(&input_state, btn_left))
			{
				cursor_tile_x -= 1;
			}
			else if (was_input_depressed(&input_state, btn_right))
			{
				cursor_tile_x += 1;
			}

			// wrap cursor x position
			cursor_tile_x = cursor_tile_x == 255
				? 19
				: cursor_tile_x > 19
					? 0
					: cursor_tile_x;

			// wrap cursor y position
			cursor_tile_y = cursor_tile_y == 255
				? 17
				: cursor_tile_y > 17
					? 0
					: cursor_tile_y;

			update_cursor_position(cursor_tile_x, cursor_tile_y);

			// place tiles
			if (was_input_depressed(&input_state, btn_b))
			{
				uint16_t board_index = cursor_tile_x + (cursor_tile_y * 20);
				uint16_t tile_data = board[board_index];
				uint8_t is_alive = tile_data & k_tile_is_alive_mask;

				if (!is_alive)
				{
					if (next_available_sprite_index < 39)
					{
						// take a new sprite index from the pool
						uint8_t sprite_index = available_sprites[next_available_sprite_index];
						next_available_sprite_index++;

						// update this sprite to the correct tile sprite and position
						update_tile_sprite(sprite_index, k_live_tile_index);
						update_tile_position(sprite_index, cursor_tile_x, cursor_tile_y);

						// update the tile index in use
						tile_data |= sprite_index << 8;

						// set our is_alive bit
						tile_data |= k_tile_is_alive_mask;
					}
				}
				else
				{
					// get the sprite index that was being used by this tile
					uint8_t sprite_index = (tile_data & k_tile_sprite_index_mask) >> 8;

					// update it to the empty tile sprite
					update_tile_sprite(sprite_index, k_empty_tile_index);
					update_tile_position(sprite_index, 21, 19);

					// return the sprite to the pool
					next_available_sprite_index--;
					available_sprites[next_available_sprite_index] = sprite_index;

					// un-set the sprite index from this tile
					tile_data &= ~k_tile_sprite_index_mask;

					// un-set our is_alive bit
					tile_data &= ~k_tile_is_alive_mask;
				}

				// update the board
				board[board_index] = tile_data;
			}
		}

		// wait for the next vertical blank
		wait_vbls_done(1);
	}
}