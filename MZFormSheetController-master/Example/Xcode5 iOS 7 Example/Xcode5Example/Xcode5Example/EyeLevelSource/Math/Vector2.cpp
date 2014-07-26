
#include "Maths.h"


const Vector2 Vector2::ZERO( 0.0f, 0.0f );

Vector2::Vector2()
{
	i[0] = 0;
	i[1] = 0;
}

Vector2::Vector2( float x, float y )
{
	i[0] = x;
	i[1] = y; 
}

void Vector2::Set( float _x, float _y )
{
	x = _x;
	y = _y;
}	

void Vector2::Clamp( float fMin, float fMax )
{
	if (i[0] > fMax) i[0] = fMax;
	if (i[1] > fMax) i[1] = fMax;
	if (i[0] < fMin) i[0] = fMin;
	if (i[1] < fMin) i[1] = fMin;
}

float Vector2::DProd( const Vector2& v ) const
{
	return (i[0]*v.i[0] + i[1]*v.i[1]);
}

float Vector2::Length() const
{
	return sqrt(i[0]*i[0] + i[1]*i[1]);
}

float Vector2::LengthSqrd() const
{
	return (i[0]*i[0] + i[1]*i[1]);
}

Vector2 Vector2::Normal() const
{
	float Len = Length();
	if (Len > 0.0f)
	{
		return Vector2( *this * (1.0f / Len) );
	}
	else
	{
		return Vector2(0.0f,0.0f);
	}
}

float Vector2::Normalise()
{
	float Len = Length();
	if (Len > 0.0f)
	{
		float fInvLength = 1.0f / Len;
		i[0] *= fInvLength;
		i[1] *= fInvLength;
	}
	else
	{
		i[0] = 0.0f;
		i[1] = 0.0f;
	}
	return Len;
}

float& Vector2::operator[]	( int val )
{
	return i[val];
}

Vector2	Vector2::operator *	( float s ) const
{
	return Vector2(	i[0]*s, i[1]*s );
}

const Vector2& Vector2::operator *= ( float s )
{
	i[0] *= s;
	i[1] *= s;
	
	return *this;
}

const Vector2& Vector2::operator = ( const Vector2& v )
{
	i[0] = v.i[0];
	i[1] = v.i[1];
	return *this;
}

Vector2	Vector2::operator +	( const Vector2& v ) const
{
	return Vector2( i[0] + v.i[0], i[1] + v.i[1] );
}

Vector2	Vector2::operator -	( const Vector2& v ) const
{
	return Vector2( i[0] - v.i[0], i[1] - v.i[1] );
}

const Vector2& Vector2::operator +=	( const Vector2& v )
{
	i[0] += v.i[0];
	i[1] += v.i[1];
	return *this;
}

const Vector2& Vector2::operator -=	( const Vector2& v )
{
	i[0] -= v.i[0];
	i[1] -= v.i[1];
	return *this;
}

const Vector2& Vector2::operator *=	( const Vector2& v )
{
	i[0] *= v.i[0];
	i[1] *= v.i[1];
	return *this;
}

bool Vector2::operator == ( const Vector2& v ) const
{
	return (i[0] == v.i[0]) && (i[1] == v.i[1]);
}

bool	Vector2::operator != ( const Vector2& v ) const
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

void	Vector2::Rotate( float fAngle )
{
	float fX = x;
	x = fX*cosf( fAngle ) - y*sinf( fAngle );
	y = fX*sinf( fAngle ) + y*cosf( fAngle );
}

//Vector2 operator ( const IVector2 &v )
Vector2 IVector2ToVector2( const IVector2 &v )
{
	Vector2 r;
	r.x = (float)(v.x);
	r.y = (float)(v.y);
	return r;
}

//IVector2 operator ( const Vector2 &v )
IVector2 Vector2ToIVector2( const Vector2 &v )
{
	IVector2 r;
	r.x = (int)(v.x + 0.5f);
	r.y = (int)(v.y + 0.5f);
	return r;
}

//\=====================================================================================
///
//\=====================================================================================
float Vector2::PerpDot( const Vector2& vec ) const 
{
	return ( x*vec.y - y*vec.x);
}

//\=====================================================================================
///
//\=====================================================================================
float PerpDot( const Vector2& vecA, const Vector2& vecB )
{
	return  vecA.PerpDot(vecB);
}
