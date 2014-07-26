
#include "Maths.h"


const Vector3 Vector3::ZERO( 0.0f, 0.0f, 0.0f );
const Vector3 Vector3::ONE( 1.f, 1.f, 1.f );

const Vector3 Vector3::FORWARD( 0.f, 0.f, 1.f );
const Vector3 Vector3::UP( 0.f, 1.f , 0.f );
const Vector3 Vector3::RIGHT( 1.f, 0.f , 0.f );
const Vector3 Vector3::BACKWARD( - Vector3::FORWARD );
const Vector3 Vector3::DOWN( - Vector3::UP );
const Vector3 Vector3::LEFT( - Vector3::RIGHT );

const Vector3 Vector3::UNITX( 1.f, 0.f, 0.f);
const Vector3 Vector3::UNITY( 0.f, 1.f, 0.f );
const Vector3 Vector3::UNITZ( 0.f, 0.f, 1.f );

Vector3::Vector3()
{
}

Vector3::Vector3( float x, float y, float z )
{
	this->x = x;
	this->y = y;
	this->z = z;
}

Vector3::~Vector3()
{
}

void Vector3::Set(float fX, float fY, float fZ )
{
	x = fX;
	y = fY;
	z = fZ;
}

float& Vector3::operator[]	( int val )
{
	return i[val];
}

// ---Adding 3D Vectors---
Vector3 Vector3::operator +( Vector3 v1 )const
{
	Vector3 vec3Result;
	vec3Result.x = this->x + v1.x;
	vec3Result.y = this->y + v1.y;
	vec3Result.z = this->z + v1.z;
	return vec3Result;
}
void Vector3::operator += ( Vector3 v1 )
{
	x += v1.x;
	y += v1.y;
	z += v1.z;
}
// ---Subtractin 3D Vectors---
Vector3 Vector3::operator -( Vector3 v1 )const
{
	Vector3 vec3Result;
	vec3Result.x = this->x - v1.x;
	vec3Result.y = this->y - v1.y;
	vec3Result.z = this->z - v1.z;
	return vec3Result;
}

void Vector3::operator -= ( Vector3 v1 )
{
	x -= v1.x;
	y -= v1.y;
	z -= v1.z;
}
// ---Multiplying... Its Greased Lightning---
Vector3 Vector3::operator *( Vector3 v1 )const
{
	Vector3 vec3Result;
	vec3Result.x = this->x * v1.x;
	vec3Result.y = this->y * v1.y;
	vec3Result.z = this->z * v1.z;
	return vec3Result;
}
Vector3 Vector3::operator *( float f)const
{
	Vector3 v3Res;
	v3Res.x = this->x * f;
	v3Res.y = this->y * f;
	v3Res.z = this->z * f;
	return v3Res;
}

void Vector3::operator *=(float scalar)
{
	x *= scalar;
	y *= scalar;
	z *= scalar;
}

void Vector3::operator /=(float scalar)
{
	x /= scalar;
	y /= scalar;
	z /= scalar;
}

void Vector3::operator /=(Vector3 v1)
{
	x = ( fabsf(v1.x) < EPSILON )? 0.f : x/v1.x;
	y = ( fabsf(v1.y) < EPSILON )? 0.f : y/v1.y;
	z = ( fabsf(v1.z) < EPSILON )? 0.f : z/v1.z;
}

bool Vector3::operator ==( const Vector3& rhs )
{
    return i[0] == rhs.i[0] && i[1] == rhs.i[1] && i[2] == rhs.i[2];
}

bool Vector3::operator !=( const Vector3& rhs )
{
    return !(*this == rhs);
}
// ---Cross Product of two Vector3
Vector3 Vector3::Cross(Vector3 v1)
{
	return Vector3( y * v1.z - z * v1.y,
				   z * v1.x - x * v1.z,
				   x * v1.y - y * v1.x );
}
Vector3 Cross( const Vector3& vecA, const Vector3& vecB )
{
	return  Vector3( vecA.y*vecB.z - vecA.z*vecB.y,
					vecA.z*vecB.x - vecA.x*vecB.z,
					vecA.x*vecB.y - vecA.y*vecB.x );
}
// ---Getting the Length of Vector3
float Vector3::Length() const
{
	float length = sqrt( (this->x * this->x)+(this->y * this->y)+(this->z * this->z) );
	return length;
}

float Vector3::LengthSqrd() const
{
	return ((this->x * this->x)+(this->y * this->y)+(this->z * this->z));
}

Vector3 Vector3::Normal() const
{
	float length = Length();
	if (length > 0.0f)
	{
		return Vector3( this->x / length, this->y / length, this->z / length );
	}
	else
	{
		return Vector3( 0, 0, 0 );
	}
}

void Vector3::Normalise()
{
	float length = Length();
	if( length == 0 )
	{
		this->x = 0.f;
		this->y = 0.f;
		this->z = 0.f;
	}
	else
	{
		this->x = this->x / length;
		this->y = this->y / length;
		this->z = this->z / length;
	}
}
//\=====================================================================================
///
//\=====================================================================================
const Vector3 Vector3::GetUnit() const
{
	Vector3 unit = *this;
	unit.Normalise();
	return unit;
}
//\=====================================================================================
///
//\=====================================================================================
float Vector3::Dot( const Vector3& vec ) const 
{
	return ( x*vec.x + y*vec.y + z*vec.z );
}

//\=====================================================================================
///
//\=====================================================================================
float Dot( const Vector3& vecA, const Vector3& vecB )
{
	return  vecA.Dot(vecB);
}
//\=====================================================================================
///
//\=====================================================================================
float Vector3::PerpDot( const Vector3& vec ) const 
{
	return ( x*vec.y - y*vec.x);
}

//\=====================================================================================
///
//\=====================================================================================
float PerpDot( const Vector3& vecA, const Vector3& vecB )
{
	return  vecA.PerpDot(vecB);
}

void  Vector3::RotateX(float fAngle)
{
	float fY = y;
	y = fY*cosf( fAngle ) - z*sinf( fAngle );
	z = fY*sinf( fAngle ) + z*cosf( fAngle );
}
void  Vector3::RotateY(float fAngle)
{
	float fX = x;
	x = fX*cosf( fAngle ) +  z*sinf( fAngle );
	z =  z*cosf( fAngle ) - fX*sinf( fAngle );
}
void  Vector3::RotateZ(float fAngle)
{
	float fX = x;
	x = fX*cosf( fAngle ) - y*sinf( fAngle );
	y = fX*sinf( fAngle ) + y*cosf( fAngle );
}

double calculateDistanceBetweenTwoLocations(double lat1 , double lon1, double lat2, double lon2)
{
    float R = 6371; // km
    double dLat = (lat2-lat1)*DEG_2_RAD;
    double dLon = (lon2-lon1)*DEG_2_RAD;
    lat1 = lat1*DEG_2_RAD;
    lat2 = lat2*DEG_2_RAD;
    
    double a = sin(dLat/2) * sin(dLat/2) + sin(dLon/2) * sin(dLon/2) * cos(lat1) * cos(lat2); 
    double c = 2 * atan2(sqrt(a), sqrt(1-a)); 
    double d = R * c;
    
    return d * 1000; //to metres
}


Vector3 Vector3::geographicCoordToWorldCoord( double latitude, double longitude, double altitude )
{
    double dLat = calculateDistanceBetweenTwoLocations(0 ,0, latitude, 0) * (latitude < 0 ? -1 : 1 );

    double dLong = calculateDistanceBetweenTwoLocations(0, 0, 0, longitude) * (longitude < 0 ? -1 : 1 );
    
    return Vector3( dLong  , altitude,  -dLat );
}

Vector3 Vector3::worldCoordToGeographicCoord( Vector3 worldCoord )
{
    Vector3 ret = Vector3();
    
    float metresBetweenEquatorAndSouthPole = calculateDistanceBetweenTwoLocations(0, 0, 90, 0);
    float metresPerLatitudeDegree = metresBetweenEquatorAndSouthPole/90;
    
    ret.x = worldCoord.x / metresPerLatitudeDegree;
    
    double metresBetweenEquatorAndEast = calculateDistanceBetweenTwoLocations(0, 0, 0, 180);
    double metresPerLongitudeDegree = metresBetweenEquatorAndEast/180;
    
    ret.z = -( worldCoord.z / metresPerLongitudeDegree );
    
    ret.y = worldCoord.y;
    
    return ret;
    
}