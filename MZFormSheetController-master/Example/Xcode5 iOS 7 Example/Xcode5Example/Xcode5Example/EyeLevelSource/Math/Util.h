/*
 *  CollisionDetection.h
 *  Describer
 *
 *  Created by Stuart Varrall on 15/10/2009.
 *  Copyright 2009 Fluid Pixel Ltd. All rights reserved.
 *
 */

#ifndef __COLLISION_DETECTION_H__
#define __COLLISION_DETECTION_H__
#ifdef __cplusplus
#include "Quaternion.h"
#include "Vector3.h"

float RandomFloat(long *idum);

class Collisions
{
public:	
	static bool RaySphereIntersect(const Vector3 &p, const Vector3 &d, float r, float  &i1, float &i2);
	
};
#endif
#endif