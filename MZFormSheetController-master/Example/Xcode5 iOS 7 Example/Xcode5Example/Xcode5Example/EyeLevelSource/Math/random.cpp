#include "random.h"

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
static long g_seed;

void	SetSeed(long* seed)
{
	g_seed = *seed;
}

long	GetSeed()
{
	return g_seed;
}

float RandomFloat()
{
	int j;
	long k;
	static	long iy = 0;
	static long iv[NTAB];
	float temp;
	
	
	if (g_seed <= 0 || !iy)
	{
		/*
		 * Initialize.
		 */	
		if (-(g_seed) < 1) 
		{
			g_seed = 1;
		}
		/* Be sure to prevent idum = 0. */
		else	
		{
			g_seed =	-(g_seed);
		}
		
		for (j = NTAB + 7; j >= 0; j--)
		{	
			/* 
			 * Load the shuffle table (after 8 warm - ups).
			 */
			k = (g_seed) / IQ;
			g_seed = IA * (g_seed - k * IQ) - IR * k;
			if (g_seed < 0)
			{
				g_seed += IM;
			}
			if (j < NTAB)
			{
				iv[j] =	g_seed;
			}
		}
		
		iy = iv[0];
	}
	
	/* 
	 * Start here when not initializing.
	 */
	
	k = (g_seed) / IQ;
	
	/*	
	 Compute	idum = (IA * idum) % IM	without overflows by Schrage's method.
	 */
	g_seed = IA * (g_seed - k * IQ) - IR * k;
	if (g_seed < 0) 
	{
		g_seed += IM;
	}
	
	/*
	 * Will be in the range 0..NTAB -1.
	 */ 
	j = iy / NDIV;
	
	/*	
	 * Output previously stored value and refill the shuffle table
	 */
	iy = iv[j];
	iv[j] = g_seed;
	
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
