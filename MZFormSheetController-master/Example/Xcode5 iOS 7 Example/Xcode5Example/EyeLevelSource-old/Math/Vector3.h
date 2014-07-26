#ifndef VECTOR_3_H
#define VECTOR_3_H

///#include "math.h"
//#include "Maths.h"

#define EQUALS_EPSILON 1.1f

class Vector3 
{
	
public:
	// ---3D Vector Functions---
	Vector3();
	Vector3( float x, float y, float z );
	~Vector3();
	
	/// Constants 
	static const Vector3 ZERO;
    static const Vector3 ONE;
    
    static const Vector3 FORWARD;
    static const Vector3 UP;
    static const Vector3 RIGHT;
    static const Vector3 BACKWARD;
    static const Vector3 DOWN;
    static const Vector3 LEFT;
    
    static const Vector3 UNITX;
    static const Vector3 UNITY;
    static const Vector3 UNITZ;
	
	void  Set(float x, float y, float z);
	
	float&		operator[]	( int val );
	
	Vector3 operator + (Vector3 v1)const;
	void operator += ( Vector3 v1 );
	void operator -= ( Vector3 v1 );
	Vector3 operator - (Vector3 v1)const;
	Vector3 operator * (Vector3 v1)const;
	Vector3 operator * (float f)const;
	
	
	friend Vector3 operator*(float lhs, const Vector3 &rhs);
	friend Vector3 operator/(  const Vector3& lhs, float rhs );
	friend Vector3 operator-(const Vector3 &v);
	
	void operator *=(float f);
	void operator /=(float f);
	void operator /=(Vector3 v1);
    bool operator ==(const Vector3& rhs);
    bool operator !=(const Vector3& rhs);
    
	float Length() const;
	float LengthSqrd() const;
	
	Vector3 Cross( Vector3 v1);
	friend Vector3	Cross( const Vector3& vecA, const Vector3& vecB );
	Vector3 Normal() const;
	void Normalise();
	float			Dot	( const Vector3& vec )const;
	friend float	Dot ( const Vector3& vecA, const Vector3& vecB );
	float			PerpDot	( const Vector3& vec )const;
	friend float	PerpDot ( const Vector3& vecA, const Vector3& vecB );
	const Vector3		GetUnit() const;
    
	void  RotateX(float fAngle);
	void  RotateY(float fAngle);
	void  RotateZ(float fAngle);
    
	
    static Vector3 geographicCoordToWorldCoord( double latitude, double longitude, double altitude );
    static Vector3 worldCoordToGeographicCoord( Vector3 worldCoord );
    
	union
	{
		struct 
		{
			float x;
			float y;
			float z;
		};
		struct 
		{
			float i[3];
		};
	};
	
};

inline Vector3 operator/(  const Vector3& lhs, float rhs )
{
	return Vector3( lhs.x / rhs, lhs.y / rhs, lhs.z / rhs );
}

inline Vector3 operator*(float lhs, const Vector3 &rhs)
{
    return Vector3(lhs * rhs.x, lhs * rhs.y, lhs * rhs.z);
}

inline Vector3 operator-(const Vector3 &v)
{
    return Vector3(-v.x, -v.y, -v.z);
}


#endif // VECTOR_3_H