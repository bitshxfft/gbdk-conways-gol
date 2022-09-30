#ifndef __UTILITY_H__
#define __UTILITY_H__

#include <gb\gb.h>

void wait_vbls_done(uint8_t num_loops)
{
	for (uint8_t loop_counter = 0; loop_counter < num_loops; ++loop_counter)
	{
		wait_vbl_done();
	}
}

#endif // __UTILITY_H__