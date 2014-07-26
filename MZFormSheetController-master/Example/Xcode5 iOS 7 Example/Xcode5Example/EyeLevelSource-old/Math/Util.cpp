/*
 *  CollisionDetection.cpp
 *  Describer
 *
 *  Created by Stuart Varrall on 15/10/2009.
 *  Copyright 2009 Fluid Pixel Ltd. All rights reserved.
 *
 */

#include "Util.h"
#include "Maths.h"


//
// Ray-sphere intersection. 
// p=(ray origin position - sphere position),
// d=ray direction,
// r=sphere radius,
// Output:
// i1=first intersection distance,
// i2=second intersection distance
// i1<=i2
// i1>=0
// returns true if intersection found,false otherwise.
// 
bool Collisions::RaySphereIntersect(const Vector3 &p, const Vector3 &d, float r, float  &i1, float &i2)
{
	
	float det,b;
	b = -Dot(p,d);
	det = b*b - p.LengthSqrd() + r*r;
	if (det<0)
	{
		i1 = -1.f;
		i2 = -1.f;
		return false;
	}
	det= sqrt(det);
	i1= b - det;
	i2= b + det;
	// intersecting with ray?
	if(i2<0) return false;
	if(i1<0) i1=0;
	return true;
}

#define IA 16807
#define IM 2147483647
#define AM (1.0 / IM)
#define IQ 127773
#define IR 2836
#define NTAB 32
#define NDIV (1 + (IM - 1) / NTAB)
#define EPS 1.2e-7
#define RNMX (1.0 - EPS)

/* 
 Minimal random number generator of Park and Miller with Bays - Durham shuffle and added safeguards. Returns a uniform random deviate between 0.0 and 1.0 (exclusive of the endpoint values). Call with idum a negative integer to initialize; thereafter, do not alter idum between successive deviates in a sequence. RNMX should approximate
 the largest floating value that is less than 1.
 */

float RandomFloat(long *idum)
{
	int j;
	long k;
	static	long iy = 0;
	static long iv[NTAB];
	float temp;
	
	
	if (*idum <= 0 || !iy)
	{
		/*
		 * Initialize.
		 */	
		if (-(*idum) < 1) 
		{
			*idum = 1;
		}
		/* Be sure to prevent idum = 0. */
		else	
		{
			*idum =	-(*idum);
		}
		
		for (j = NTAB + 7; j >= 0; j--)
		{	
			/* 
			 * Load the shuffle table (after 8 warm - ups).
			 */
			k = (*idum) / IQ;
			*idum = IA * (*idum - k * IQ) - IR * k;
			if (*idum < 0)
			{
				*idum += IM;
			}
			if (j < NTAB)
			{
				iv[j] =	*idum;
			}
		}
		
		iy = iv[0];
	}
	
	/* 
	 * Start here when not initializing.
	 */
	
	k = (*idum) / IQ;
	
	/*	
	 Compute	idum = (IA * idum) % IM	without overflows by Schrage's method.
	 */
	* idum = IA * (*idum - k * IQ) - IR * k;
	if (*idum < 0) 
	{
		*idum += IM;
	}
	
	/*
	 * Will be in the range 0..NTAB -1.
	 */ 
	j = iy / NDIV;
	
	/*	
	 * Output previously stored value and refill the shuffle table
	 */
	iy = iv[j];
	iv[j] = *idum;
	
	/* 
	 * Because users don't expect endpoint values
	 */
	
	if ((temp = AM * iy) > RNMX)
	{
		return RNMX;
	}
	else
	{
		return temp;
	}
	
}