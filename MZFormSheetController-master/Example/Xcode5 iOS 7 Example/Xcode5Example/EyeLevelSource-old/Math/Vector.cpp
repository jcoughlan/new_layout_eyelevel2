
#include "Maths.h"


unsigned long mt[Nq];	// the array for the state vector
int mti=Nq+1;			// mti==N+1 means mt[N] is not initialized

IVector2::IVector2()
{
	i[0] = 0;
	i[1] = 0;
}

IVector2::IVector2( int x, int y )
{
	i[0] = x;
	i[1] = y; 
}

float IVector2::Length()
{
	return sqrt( (float)(i[0]*i[0] + i[1]*i[1]) );
}

float IVector2::LengthSqrd()
{
	return (float)(i[0]*i[0] + i[1]*i[1]);
}

int& IVector2::operator[]	( int val )
{
	return i[val];
}

const int& IVector2::operator[]	( int val ) const
{
	return i[val];
}

IVector2	IVector2::operator +	( const IVector2& v )
{
	return IVector2( i[0] + v.i[0], i[1] + v.i[1] );
}

IVector2	IVector2::operator -	( const IVector2& v )
{
	return IVector2( i[0] - v.i[0], i[1] - v.i[1] );
}

IVector2&	IVector2::operator =	( const IVector2& v )
{
	i[0] = v.i[0];
	i[1] = v.i[1];
	return *this;
}

bool	IVector2::operator == ( const IVector2& v ) const
{
	if ((i[0] == v.i[0]) && (i[1] == v.i[1]))
	{
		return true;
	}
	else
	{
		return false;
	}
}

bool	IVector2::operator != ( const IVector2& v ) const
{
	if ((i[0] == v.i[0]) && (i[1] == v.i[1]))
	{
		return false;
	}
	else
	{
		return true;
	}
}

IVector3::IVector3()
{
	i[0] = 0;
	i[1] = 0;
	i[2] = 0;
}

float IVector3::Length()
{
	return sqrt((float)( (this->x * this->x)+(this->y * this->y)+(this->z * this->z) ));
}

float IVector3::LengthSqrd()
{
	return (float)((this->x * this->x)+(this->y * this->y)+(this->z * this->z));
}

int& IVector3::operator[]	( int val )
{
	return i[val];
}

const int& IVector3::operator[]	( int val ) const
{
	return i[val];
}

IVector3	IVector3::operator +	( const IVector3& v )
{
	return IVector3( i[0] + v.i[0], i[1] + v.i[1], i[2] + v.i[2] );
}

IVector3	IVector3::operator -	( const IVector3& v )
{
	return IVector3( i[0] - v.i[0], i[1] - v.i[1], i[2] - v.i[2] );
}

IVector3&	IVector3::operator =	( const IVector3& v )
{
	i[0] = v.i[0];
	i[1] = v.i[1];
	i[2] = v.i[2];
	return *this;
}

bool	IVector3::operator == ( const IVector3& v ) const
{
	if ((i[0] == v.i[0]) && (i[1] == v.i[1]) && (i[2] == v.i[2]))
	{
		return true;
	}
	else
	{
		return false;
	}
}

bool	IVector3::operator != ( const IVector3& v ) const
{
	if ((i[0] == v.i[0]) && (i[1] == v.i[1]) && (i[2] == v.i[2]))
	{
		return false;
	}
	else
	{
		return true;
	}
}

PiRect::PiRect()
{
	fTop = 0.0f;
	fBottom = 0.0f;
	fLeft = 0.0f;
	fRight = 0.0f;
}

PiRect::PiRect( float Left, float Right, float Top, float Bottom )
{
	fTop = Top;
	fBottom = Bottom;
	fLeft = Left;
	fRight = Right;
}

void PiRect::ClampToRect( PiRect& rect )
{
	if (fTop > rect.fTop) fTop = rect.fTop;
	if (fBottom < rect.fBottom) fBottom = rect.fBottom;
	if (fRight > rect.fRight) fRight = rect.fRight;
	if (fLeft < rect.fLeft) fLeft = rect.fLeft;
}


float Random()
{
	float num = (float)rand() / (float)RAND_MAX;
	
	return num;
}

float RandomSigned()
{
	float num = (float)rand() / (float)RAND_MAX;
	
	return (num - 0.5f) * 2.0f;
}

void Clamp( float& f, float fMin, float fMax )
{
	if (f > fMax) f = fMax;
	if (f < fMin) f = fMin;
}

void sgenrand(unsigned long seed)
{
	int i;
	
	for (i = 0; i < Nq; i++)
	{
		mt[i] = seed & 0xffff0000;
		seed = 69069 * seed + 1;
		mt[i] |= (seed & 0xffff0000) >> 16;
		seed = 69069 * seed + 1;
	}
	mti = Nq;
}

unsigned long genrand()
{
	unsigned long y;
	static unsigned long mag01[2]={0x0, MATRIX_A};
	/* mag01[x] = x * MATRIX_A	for x=0,1 */
	
	if (mti >= Nq)
	{	/* generate N words at one time */
		
		int kk;
		
		if (mti == Nq+1)		/* if sgenrand() has not been called, */
			sgenrand(4357);		/* a default initial seed is used	*/
		
		for (kk=0;kk<Nq-Mq;kk++)
		{
			y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
			mt[kk] = mt[kk+Mq] ^ (y >> 1) ^ mag01[y & 0x1];
		}
		for (;kk<Nq-1;kk++)
		{
			y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
			mt[kk] = mt[kk+(Mq-Nq)] ^ (y >> 1) ^ mag01[y & 0x1];
		}
		y = (mt[Nq-1]&UPPER_MASK)|(mt[0]&LOWER_MASK);
		mt[Nq-1] = mt[Mq-1] ^ (y >> 1) ^ mag01[y & 0x1];
		
		mti = 0;
	}
	
	y = mt[mti++];
	y ^= TEMPERING_SHIFT_U(y);
	y ^= TEMPERING_SHIFT_S(y) & TEMPERING_MASK_B;
	y ^= TEMPERING_SHIFT_T(y) & TEMPERING_MASK_C;
	y ^= TEMPERING_SHIFT_L(y);
	
	return y; 
}