
#include "Maths.h"


Vector4::Vector4()
{
	i[0] = 0.0f;
	i[1] = 0.0f;
	i[2] = 0.0f;
	i[3] = 0.0f;
}

Vector4::Vector4(float x, float y, float z, float w)
{
	i[0] = x;
	i[1] = y;
	i[2] = z;
	i[3] = w;
}

Vector4::Vector4(float* pInit)
{
	i[0] = pInit[0];
	i[1] = pInit[1];
	i[2] = pInit[2];
	i[3] = pInit[3];
}

Vector4::~Vector4()
{
	
}


void Vector4::Set(float x, float y, float z, float w)
{
	i[0] = x;
	i[1] = y;
	i[2] = z;
	i[3] = w;
}

Vector3 Vector4::CastVector3()
{
	Vector3 v;
	
	v.x = i[0];
	v.y = i[1];
	v.z = i[2];
	
	return v;
}

const Vector4& Vector4::Normalise()
{
	float length = (float)sqrt((i[0] * i[0]) + (i[1] * i[1]) + (i[2] * i[2]) + (i[3] * i[3]));
	
	i[0] /= length;
	i[1] /= length;
	i[2] /= length;
	i[3] /= length;
	
	return *this;
}


Vector4 Vector4::XProd(const Vector4 &vec)
{
	Vector4 result;
	
	result.i[0] = (i[1] * vec.i[2]) -  (i[2] * vec.i[1]);
	result.i[1] = (i[2] * vec.i[0]) -  (i[0] * vec.i[2]);
	result.i[2] = (i[0] * vec.i[1]) -  (i[1] * vec.i[0]);
	result.i[3] = 1.0f;
	
	return result;
}


float& Vector4::operator[](int val)
{
	return i[val];
}


const Vector4& Vector4::operator=(const Vector4 &vec)
{
	i[0] = vec.i[0];
	i[1] = vec.i[1];
	i[2] = vec.i[2];
	i[3] = vec.i[3];
	
	return *this;
}


const Vector4& Vector4::operator+=(const Vector4 &vec)
{
	i[0] += vec.i[0];
	i[1] += vec.i[1];
	i[2] += vec.i[2];
	i[3] += vec.i[3];
	
	return *this;
}

const Vector4& Vector4::operator-=(const Vector4 &vec)
{
	i[0] -= vec.i[0];
	i[1] -= vec.i[1];
	i[2] -= vec.i[2];
	i[3] -= vec.i[3];
	
	return *this;
}


const Vector4& Vector4::operator*=(const Vector4 &vec)
{
	i[0] *= vec.i[0];
	i[1] *= vec.i[1];
	i[2] *= vec.i[2];
	i[3] *= vec.i[3];
	
	return *this;
}


const Vector4& Vector4::operator/=(const Vector4 &vec)
{
	i[0] /= vec.i[0];
	i[1] /= vec.i[1];
	i[2] /= vec.i[2];
	i[3] /= vec.i[3];
	
	return *this;
}


Vector4 Vector4::operator*(const float &num)
{
	Vector4 vec;
	
	vec.i[0] = i[0] * num; 
	vec.i[1] = i[1] * num;
	vec.i[2] = i[2] * num;
	vec.i[3] = i[3] * num;
	
	return vec;
}


Vector4 Vector4::operator/(const float &num)
{
	Vector4 vec;
	
	vec.i[0] = i[0] / num; 
	vec.i[1] = i[1] / num;
	vec.i[2] = i[2] / num;
	vec.i[3] = i[3] / num;
	
	return vec;
}


Vector4 Vector4::operator*(const Vector4 &vec)
{
	Vector4 result;
	
	result.i[0] = i[0] * vec.i[0];
	result.i[1] = i[1] * vec.i[1];
	result.i[2] = i[2] * vec.i[2];
	result.i[3] = i[3] * vec.i[3];
	
	return result;
}


Vector4 Vector4::operator/(const Vector4 &vec)
{
	Vector4 result;
	
	result.i[0] = i[0] / vec.i[0];
	result.i[1] = i[1] / vec.i[1];
	result.i[2] = i[2] / vec.i[2];
	result.i[3] = i[3] / vec.i[3];
	
	return result;
}


Vector4 Vector4::operator+(const Vector4 &vec)
{
	Vector4 result;
	
	result.i[0] = i[0] + vec.i[0];
	result.i[1] = i[1] + vec.i[1];
	result.i[2] = i[2] + vec.i[2];
	result.i[3] = i[3] + vec.i[3];
	
	return result;
}


Vector4 Vector4::operator-(const Vector4 &vec)
{
	Vector4 result;
	
	result.i[0] = i[0] - vec.i[0];
	result.i[1] = i[1] - vec.i[1];
	result.i[2] = i[2] - vec.i[2];
	result.i[3] = i[3] - vec.i[3];
	
	return result;
}


const Vector4& Vector4::Homogonise()
{
	i[0] /= i[3];
	i[1] /= i[3];
	i[2] /= i[3];
	i[3] = 1.0f;
	
	return *this;
}
