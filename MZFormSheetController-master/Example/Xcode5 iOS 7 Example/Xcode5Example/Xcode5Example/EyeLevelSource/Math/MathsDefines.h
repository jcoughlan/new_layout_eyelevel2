#ifndef PI_MATHS_DEFINES_H
#define PI_MATHS_DEFINES_H


#ifdef WINDOWS
#define PI_INLINE __forceinline
#else
#define PI_INLINE
#endif

#define EPSILON 1.0e-3

#define AT_EPSILON( f ) ( fabsf(f) < EPSILON ? 0.0 : f )
#define	MPS_TO_MPH		60.0f * 60.0f / 1604.0f

#define PI			3.1415926538f	 
#define PI2   		1.570796327f	
#define PI4   		0.785398163f	 
#define PI8   		0.392699081f

#define RAD_2_DEG(a)	((float)a * 180.0f/PI)
#define DEG_2_RAD		0.01745329252f

#define CLAMP( x, min, max ) ( (x) > (max) ? (max) : ( (x) < (min) ? (min) : (x) ) )

#define SMOOTHSTEP( x ) CLAMP( (x)*(x)*(3.0f - 2.0f*(x)), 0.0f, 1.0f )

//#define MIN(a,b)		(((a) < (b)) ? (a):(b))
//#define MAX(a,b)		(((a) > (b)) ? (a):(b))	

#define LERP(origin,dest,t)		(((dest)*(t))+((origin)*(1.0f-(t))))				// t = time

#define EASEIN(t)		(sin(t*PI2))							// returns 0.0 to 1.0	- sine 0 to 90 
#define EASEOUT(t)		(sin(t*-PI2)*-1.0f)						// returns 0.0 to 1.0	- sine 0 to -90

#define SQUARE(a)		((a)*(a))
#define CUBE(a)			((a)*(a)*(a))

#endif // PI_MATHS_DEFINES_H