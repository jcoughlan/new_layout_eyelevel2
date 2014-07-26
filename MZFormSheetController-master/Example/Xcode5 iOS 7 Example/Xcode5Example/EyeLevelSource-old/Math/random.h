/*
 *  Math.h
 *  Azzurri Quiz
 *
 *  Created by Jamie Stewart on 1/06/10.
 *  Copyright 2010 Fluid Pixel. All rights reserved.
 *
 */

#ifndef _RANDOM_H
#define _RANDOM_H

#include "math.h"
//#include "stdlib.h"

#ifdef __cplusplus
extern "C"
{
#endif
	
	float	RandomFloat();
	void	SetSeed(long* seed);
	long	GetSeed();
	
#ifdef __cplusplus
}
#endif


#endif // _RANDOM_H