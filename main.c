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
	execution_state_active	= 0,
};

const uint8_t k_execution_state_active_mask = 1 << execution_state_active;

// ------------------------------------------------------------------------------------

const uint8_t k_tile_sprite_index_mask	= 0x3F; // 0011 1111
const uint8_t k_tile_is_alive_mask		= 0x40; // 0100 0000
const uint8_t k_tile_was_alive_mask		= 0x80; // 1000 0000

// ------------------------------------------------------------------------------------

const uint8_t k_empty_tile_index		= 0;
const uint8_t k_live_tile_index			= 1;
const uint8_t k_cursor_empty_tile_index	= 2;
const uint8_t k_cursor_live_tile_index	= 3;

// ------------------------------------------------------------------------------------

const uint8_t k_cursor_sprite_index		= 0;

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
	uint8_t board[20][18];

	// pool our available sprites
	uint8_t available_sprites[39];
	uint8_t next_available_sprite_index = 0;

	// initialise available sprites
	for (uint8_t i = 0; i < 39; ++i)
	{
		available_sprites[i] = i + 1;
		update_tile_sprite(i + 1, k_live_tile_index);
		update_tile_position(i + 1, 0, 19);
	}

	// clear board
	for (uint8_t x = 0; x < 20; ++x)
	{
		for (uint8_t y = 0; y < 18; ++y)
		{
			board[x][y] = 0x00;
		}
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
			for (uint8_t x = 0; x < 20; ++x)
			{
				for (uint8_t y = 0; y < 18; ++y)
				{
					uint8_t tile_data = board[x][y];

					// reset the was_alive flag, then set the was_alive flag to the last frame's is_alive flag
					board[x][y] = (tile_data & ~k_tile_was_alive_mask) | ((tile_data & k_tile_is_alive_mask) << 1);
				}
			}

			// run game of life
			for (uint8_t x = 0; x < 20; ++x)
			{
				for (uint8_t y = 0; y < 18; ++y)
				{
					uint8_t tile_data = board[x][y];
					uint8_t neighbour_count = 0;

					// north
					neighbour_count += y > 0 && (board[x][y - 1] & k_tile_was_alive_mask) != 0x00;

					// north-east
					neighbour_count += x < 19 && y > 0 && (board[x + 1][y - 1] & k_tile_was_alive_mask) != 0x00;

					// east
					neighbour_count += x < 19 && (board[x + 1][y] & k_tile_was_alive_mask) != 0x00;

					// south-east
					neighbour_count += x < 19 && y < 17 && (board[x + 1][y + 1] & k_tile_was_alive_mask) != 0x00;

					// south
					neighbour_count +=y < 17 && (board[x][y + 1] & k_tile_was_alive_mask) != 0x00;

					// south-west
					neighbour_count += x > 0 && y < 17 && (board[x - 1][y + 1] & k_tile_was_alive_mask) != 0x00;

					// west
					neighbour_count += x > 0 && (board[x - 1][y] & k_tile_was_alive_mask) != 0x00;

					// north-west
					neighbour_count += x > 0 && y > 0 && (board[x - 1][y - 1] & k_tile_was_alive_mask) != 0x00;

					// a dead tile with exactly 3 live neighbours comes to life, otherwise it remains dead
					uint8_t is_alive = (tile_data & k_tile_is_alive_mask) != 0x00;
					uint8_t come_to_life = !is_alive && neighbour_count == 3;

					// a live tile with < 2 live neighbours dies
					// a live tile with > 3 live neighbours dies
					// a live tile with 2 or 3 live neighbours lives on
					uint8_t remain_alive = is_alive && neighbour_count >= 2 && neighbour_count <= 3;

					// un-set tile is alive mask, re-set if tile should remain alive or come to life
					tile_data = (tile_data & ~k_tile_is_alive_mask) | (((come_to_life | remain_alive) != 0x00) << 6);

					// get updated is_alive and was_alive flags
					is_alive = (tile_data & k_tile_is_alive_mask) != 0x00;
					uint8_t was_alive = (tile_data & k_tile_was_alive_mask) != 0x00;

					// update sprite state if anything has changed
					if (!was_alive && is_alive)
					{
						// tile has come alive
						if (next_available_sprite_index < 39)
						{
							// assign a new sprite index from the pool
							tile_data |= available_sprites[next_available_sprite_index];
							next_available_sprite_index++;

							// update this sprite to the correct tile sprite and position
							update_tile_position(tile_data & k_tile_sprite_index_mask, x, y);
						}
						else
						{
							// we have no availale sprites, cull this tile
							tile_data &= ~k_tile_is_alive_mask;
						}
					}
					else if (was_alive && !is_alive)
					{
						// move the sprite off-screen
						update_tile_position(tile_data & k_tile_sprite_index_mask, 0, 19);

						// return the sprite to the pool
						next_available_sprite_index--;
						available_sprites[next_available_sprite_index] = tile_data & k_tile_sprite_index_mask;

						// un-set the sprite index this tile is using
						tile_data &= ~k_tile_sprite_index_mask;
					}

					board[x][y] = tile_data;
				}
			}

			// debugging --------------------------------------
			// stop after first update of all tiles
			//execution_state &= ~k_execution_state_active_mask;
			//update_cursor_sprite(k_cursor_empty_tile_index);
			// -------------------------------------- debugging
		}
		else
		{
			// move cursor using d-pad
			cursor_tile_y -= was_input_depressed(&input_state, btn_up);
			cursor_tile_y += was_input_depressed(&input_state, btn_down);
			cursor_tile_x -= was_input_depressed(&input_state, btn_left);
			cursor_tile_x += was_input_depressed(&input_state, btn_right);

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
				uint8_t tile_data = board[cursor_tile_x][cursor_tile_y];
				uint8_t is_alive = tile_data & k_tile_is_alive_mask;

				if (!is_alive)
				{
					if (next_available_sprite_index < 39)
					{
						// take a new sprite index from the pool
						tile_data |= available_sprites[next_available_sprite_index];
						next_available_sprite_index++;

						// update this sprite to the correct tile sprite and position
						update_tile_position(tile_data & k_tile_sprite_index_mask, cursor_tile_x, cursor_tile_y);

						// set our is_alive bit
						tile_data |= k_tile_is_alive_mask;
					}
				}
				else
				{
					// move the sprite off-screen
					update_tile_position(tile_data & k_tile_sprite_index_mask, 0, 19);

					// return the sprite to the pool
					next_available_sprite_index--;
					available_sprites[next_available_sprite_index] = tile_data & k_tile_sprite_index_mask;

					// un-set the sprite index from this tile
					tile_data &= ~k_tile_sprite_index_mask;

					// un-set our is_alive bit
					tile_data &= ~k_tile_is_alive_mask;
				}

				// update the board
				board[cursor_tile_x][cursor_tile_y] = tile_data;
			}
		}

		// wait for the next vertical blank
		wait_vbls_done(1);
	}
}