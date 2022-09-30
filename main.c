#include <gb/gb.h>
#include <rand.h>
#include "background-map.h"
#include "background-tiles.h"
#include "constants.h"
#include "input.h"
#include "sprites.h"

enum e_execution_state_masks
{
	execution_state_active	= 1,
};

static const uint8_t s_execution_state_active_mask = 1 << execution_state_active;

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

static const uint8_t s_tile_is_alive_mask = 1 << tile_is_alive;
static const uint8_t s_tile_was_alive_mask = 1 << tile_was_alive;
static const uint8_t s_tile_is_north_row_mask = 1 << tile_is_north_row;
static const uint8_t s_tile_is_south_row_mask = 1 << tile_is_south_row;
static const uint8_t s_tile_is_west_column_mask = 1 << tile_is_west_column;
static const uint8_t s_tile_is_east_column_mask = 1 << tile_is_east_column;

// ------------------------------------------------------------------------------------

const uint8_t empty_tile_index = 0;
const uint8_t live_tile_index = 1;
const uint8_t highlight_empty_tile_index = 2;
const uint8_t highlight_live_tile_index = 3;

// ------------------------------------------------------------------------------------

const uint8_t highlight_sprite_index = 0;

void update_cursor_sprite(uint8_t tile_index)
{
	set_sprite_tile(highlight_sprite_index, tile_index);
}

void update_cursor_position(uint8_t tile_x, uint8_t tile_y)
{
	move_sprite(highlight_sprite_index,
		SCREEN_MIN_X + (tile_x * SPRITE_TILE_WIDTH),
		SCREEN_MIN_Y + (tile_y * SPRITE_TILE_HEIGHT));
}

// ------------------------------------------------------------------------------------

int main()
{
	// initialise our iterator, used multiple places
	uint16_t i = 0;

	// create our input state object
	struct input_state input_state;
	input_state.previous_state = 0x00;
	input_state.current_state = 0x00;
	input_state.held_buttons = 0x00;
	input_state.depressed_buttons = 0x00;
	input_state.released_buttons = 0x00;

	// execution state
	uint8_t execution_state = 0x00;

	uint8_t highlight_tile_position[2] = { 10, 9 };

	// screen width: 160 pixels, 20 tiles
	// screen height: 144 pixels, 18 tiles
	// total tiles: 360
	uint8_t board[360];

	for (i = 0; i < 360; ++i)
	{
		uint8_t tile_data = 0x00;
		tile_data |= (i < 20 ? s_tile_is_north_row_mask : 0x00);
		tile_data |= (i >= 340 ? s_tile_is_south_row_mask : 0x00);
		tile_data |= (i % 20 == 0 ? s_tile_is_west_column_mask : 0x00);
		tile_data |= (i % 20== 19 ? s_tile_is_east_column_mask : 0x00);
		board[i] = tile_data;
	}

	// load sprites
	set_sprite_data(0, 3, sprites);
	set_bkg_data(0, 2, background_tiles);

	// initialise background
	set_bkg_tiles(0, 0, 20, 18, background_map);

	// initialise cursor
	update_cursor_sprite(highlight_empty_tile_index);
	update_cursor_position(highlight_tile_position[0], highlight_tile_position[1]);

	SHOW_BKG;
	SHOW_SPRITES;
	DISPLAY_ON;

	while (1)
	{
		update_input_state(&input_state, joypad());

		// toggle execution state on start being pressed
		if (was_input_released(&input_state, btn_start))
		{
			execution_state ^= s_execution_state_active_mask;
			update_cursor_sprite(
				(execution_state & s_execution_state_active_mask) == s_execution_state_active_mask
					? empty_tile_index
					: highlight_empty_tile_index);
		}

		// game of life
		if ((execution_state & s_execution_state_active_mask) == s_execution_state_active_mask)
		{
			// set previous states
			for (uint16_t i = 0; i < 360; ++i)
			{
				uint8_t tile_data = board[i];
				// un-set the was_alive bit and re-set with the last frame's is_alive bit
				board[i] = (tile_data & ~s_tile_was_alive_mask) | ((tile_data & s_tile_is_alive_mask) << tile_was_alive);
			}

			// run game of life
			for (uint16_t i = 0; i < 360; ++i)
			{
				uint8_t tile_data = board[i];
				uint8_t neighbour_count = 0;

				uint8_t is_not_north = (tile_data & s_tile_is_north_row_mask) == 0x00;
				uint8_t is_not_east = (tile_data & s_tile_is_east_column_mask) == 0x00;
				uint8_t is_not_south = (tile_data & s_tile_is_south_row_mask) == 0x00;
				uint8_t is_not_west = (tile_data & s_tile_is_west_column_mask) == 0x00;

				// north
				neighbour_count += is_not_north
					&& (board[i - 20] & s_tile_was_alive_mask) != 0x00;

				// north-east
				neighbour_count += is_not_north	&& is_not_east
					&& (board[i - 19] & s_tile_was_alive_mask) != 0x00;

				// east
				neighbour_count += is_not_east
					&& (board[i + 1] & s_tile_was_alive_mask) != 0x00;

				// south-east
				neighbour_count += is_not_south && is_not_east
					&& (board[i + 21] & s_tile_was_alive_mask) != 0x00;

				// south
				neighbour_count += is_not_south
					&& (board[i + 20] & s_tile_was_alive_mask) != 0x00;

				// south-west
				neighbour_count += is_not_south && is_not_west
					&& (board[i + 19] & s_tile_was_alive_mask) != 0x00;

				// west
				neighbour_count += is_not_west
					&& (board[i - 1] & s_tile_was_alive_mask) != 0x00;

				// north-west
				neighbour_count += is_not_north && is_not_west
					&& (board[i - 21] & s_tile_was_alive_mask) != 0x00;

				// a dead tile with exactly 3 live neighbours comes to life, otherwise it remains dead
				uint8_t is_alive = (tile_data & s_tile_is_alive_mask) != 0x00;
				uint8_t come_to_life = !is_alive && neighbour_count == 3;

				// a live tile with < 2 live neighbours dies
				// a live tile with > 3 live neighbours dies
				// a live tile with 2 or 3 live neighbours lives on
				uint8_t remain_alive = is_alive && neighbour_count >= 2 && neighbour_count <= 3;

				// un-set tile is alive mask re-set if tile should remain alive or come to life
				board[i] = (tile_data & ~s_tile_is_alive_mask)
							| ((come_to_life | remain_alive) << tile_is_alive);
			}

			// #SD: TODO - draw/update sprites
		}
		else
		{
			// move highlight using d-pad
			if (was_input_depressed(&input_state, btn_up))
			{
				highlight_tile_position[1] -= 1;
			}
			else if (was_input_depressed(&input_state, btn_down))
			{
				highlight_tile_position[1] += 1;
			}
			else if (was_input_depressed(&input_state, btn_left))
			{
				highlight_tile_position[0] -= 1;
			}
			else if (was_input_depressed(&input_state, btn_right))
			{
				highlight_tile_position[0] += 1;
			}

			update_cursor_position(highlight_tile_position[0], highlight_tile_position[1]);
		}
	}
}