#ifndef VECTOR_MATHS_H
#define VECTOR_MATHS_H

//#include "Maths.h"

class IVector2
	{
	public:
		
		IVector2();
		IVector2(int x, int y);
		
		float		Length();
		float		LengthSqrd();
		
		int&		operator[]	( int val );
		const int& 	operator[]	( int val ) const;
		IVector2	operator +	( const IVector2& v );
		IVector2	operator -	( const IVector2& v );
		IVector2&	operator =	( const IVector2& v );
		bool		operator == ( const IVector2& v ) const;
		bool		operator != ( const IVector2& v ) const;
		
		union
		{
			struct 
			{
				int x;
				int y;
			};
			struct 
			{
				int i[2];
			};
		};
	};

class IVector3
	{
	public:
		
		IVector3();
		IVector3(int x, int y, int z) { i[0] = x; i[1] = y; i[2] = z; }
		float		Length();
		float		LengthSqrd();
		int&		operator[]	( int val );
		const int&	operator[]	( int val ) const;
		IVector3	operator +	( const IVector3& v );
		IVector3	operator -	( const IVector3& v );
		IVector3	operator *	( const IVector3& v );
		IVector3&	operator =	( const IVector3& v );
		bool		operator == ( const IVector3& v ) const;
		//IVector3&	operator =	( IVector3& v );
		//bool		operator == ( IVector3& v );
		bool		operator != ( const IVector3& v ) const;
		
		union
		{
			struct 
			{
				int x;
				int y;
				int z;
			};
			struct 
			{
				int i[3];
			};
		};
	};

class RGBE
	{
	public:
		
		unsigned char i[4];
	};


// Misc structures

struct PiRect
{
	float fTop;
	float fBottom;
	float fLeft;
	float fRight;
	
	PiRect();
	PiRect( float fLeft, float fRight, float fTop, float fBottom );
	
	void ClampToRect( PiRect& rect );
};


// Misc functions

float	Random();
float	RandomSigned();

void	Clamp( float& f, float fMin, float fMax );



// Period parameters  
#define Nq 624
#define Mq 397
#define MATRIX_A 0x9908b0df		// constant vector a
#define UPPER_MASK 0x80000000	// most significant w-r bits
#define LOWER_MASK 0x7fffffff	// least significant r bits

// Tempering parameters
#define TEMPERING_MASK_B 0x9d2c5680
#define TEMPERING_MASK_C 0xefc60000
#define TEMPERING_SHIFT_U(y)  (y >> 11)
#define TEMPERING_SHIFT_S(y)  (y << 7)
#define TEMPERING_SHIFT_T(y)  (y << 15)
#define TEMPERING_SHIFT_L(y)  (y >> 18)

extern unsigned long mt[Nq];
extern int mti;

// initializing the array with a NONZERO seed
void sgenrand(unsigned long seed);
unsigned long genrand(void);

inline double rb_random()
{
	return (double)genrand() * 2.3283064365386963e-10;	// reals: [0,1)-interval
}


#endif // VECTOR_MATHS_H
