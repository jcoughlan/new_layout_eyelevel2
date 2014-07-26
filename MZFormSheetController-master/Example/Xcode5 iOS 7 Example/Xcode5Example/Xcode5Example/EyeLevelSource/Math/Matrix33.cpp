
#include "Maths.h"

Matrix33::Matrix33()
{
	i[0][0] = 1.0;
	i[0][1] = 0.0;
	i[0][2] = 0.0;
	i[1][0] = 0.0;
	i[1][1] = 1.0;
	i[1][2] = 0.0;
	i[2][0] = 0.0;
	i[2][1] = 0.0;
	i[2][2] = 1.0;
}


Matrix33::~Matrix33()
{
	
}


const Matrix33& Matrix33::LoadIdentity()
{
	i[0][0] = 1.0;
	i[0][1] = 0.0;
	i[0][2] = 0.0;
	i[1][0] = 0.0;
	i[1][1] = 1.0;
	i[1][2] = 0.0;
	i[2][0] = 0.0;
	i[2][1] = 0.0;
	i[2][2] = 1.0;
	
	return *this;
}

void			Matrix33::Scale( float s )
{
	for (int k=0; k<3; k++)
	{
		for (int l=0; l<3; l++)
		{
			i[k][l] *= s;
		}
	}
}

const Matrix33& Matrix33::SetTrans( const float &x, const float &y, const float &z )
{
	LoadIdentity();
	
	i[2][0] = x;
	i[2][1] = y;
	i[2][2] = z;
	
	return *this;
}

const Matrix33&	Matrix33::SetTrans( const Vector3& vec )
{
	LoadIdentity();
	
	i[2][0] = vec.x;
	i[2][1] = vec.y;
	i[2][2] = vec.z;
	
	return *this;
}

const Matrix33& Matrix33::SetRot2D(const float &angle)
{
	
	i[0][0] = cosf(angle);
	i[0][1] = sinf(angle);
	i[0][2] = 0.0;
	i[1][0] = -sinf(angle);
	i[1][1] = cosf(angle);
	i[1][2] = 0.0;
	i[2][0] = 0.0;
	i[2][1] = 0.0;
	i[2][2] = 1.0;
	
	return *this;
}

const Matrix33& Matrix33::SetRot3D( const Vector3& vec )
{
	return SetRot3D( vec.x, vec.y, vec.z );
}

const Matrix33& Matrix33::SetRot3D( float yaw, float pitch, float roll )
{
	this->LoadIdentity();
	
	Matrix33 rot;
	
	rot.LoadIdentity();
	rot.i[0][0] = (float)cosf( roll );
	rot.i[1][0] = (float)sinf( roll );
	rot.i[0][1] = (float)-sinf( roll );
	rot.i[1][1] = (float)cosf( roll );
	(*this) = (*this) * rot;
	
	rot.LoadIdentity();	
	rot.i[1][1] = (float)cosf( pitch );
	rot.i[2][1] = (float)sinf( pitch );
	rot.i[1][2] = (float)-sinf( pitch );
	rot.i[2][2] = (float)cosf( pitch );
	(*this) = (*this) * rot;
	
	rot.LoadIdentity();	
	rot.i[0][0] = (float)cosf( yaw );
	rot.i[2][0] = (float)-sinf( yaw );
	rot.i[0][2] = (float)sinf( yaw );
	rot.i[2][2] = (float)cosf( yaw );
	(*this) = (*this) * rot;
	
	return *this;
}

const Matrix33& Matrix33::Normalise(void)
{
	Vector3 vRight( i[0][0], i[0][1], i[0][2] );
	Vector3 vUp( i[1][0], i[1][1], i[1][2] );
	Vector3 vOut( i[2][0], i[2][1], i[2][2] );
	
	// make all axes orthogonal
	vOut   = Cross(vUp, vRight);
	vRight = Cross( vOut, vUp );
	
	// normalize
	
	vOut.Normalise();
	vRight.Normalise();
	vUp.Normalise();
	
	i[0][0] = vRight.x; 
	i[1][0] = vUp.x; 
	i[2][0] = vOut.x;
	
	i[0][1] = vRight.y; 
	i[1][1] = vUp.y; 
	i[2][1] = vOut.y;
	
	i[0][2] = vRight.z; 
	i[1][2] = vUp.z; 
	i[2][2] = vOut.z;
	
	return *this;
}

const Matrix33& Matrix33::operator=(const Matrix33 &mat)
{
	
	i[0][0] = mat.i[0][0];
	i[0][1] = mat.i[0][1];
	i[0][2] = mat.i[0][2];
	i[1][0] = mat.i[1][0];
	i[1][1] = mat.i[1][1];
	i[1][2] = mat.i[1][2];
	i[2][0] = mat.i[2][0];
	i[2][1] = mat.i[2][1];
	i[2][2] = mat.i[2][2];
	
	return *this;
}


Vector3 Matrix33::operator*(const Vector3 &vec)
{
	Vector3 result;
	
	result.x = (vec.x * i[0][0]) + (vec.y * i[1][0]) + (vec.z * i[2][0]);
	result.y = (vec.x * i[0][1]) + (vec.y * i[1][1]) + (vec.z * i[2][1]);
	result.z = (vec.x * i[0][2]) + (vec.y * i[1][2]) + (vec.y * i[2][2]);
	
	return result;
}


Matrix33 Matrix33::operator*(const Matrix33 &mat2)
{
	Matrix33	result;
	
	result.i[0][0] = (i[0][0] * mat2.i[0][0]) + (i[0][1] * mat2.i[1][0]) + (i[0][2] * mat2.i[2][0]);
	result.i[0][1] = (i[0][0] * mat2.i[0][1]) + (i[0][1] * mat2.i[1][1]) + (i[0][2] * mat2.i[2][1]);
	result.i[0][2] = (i[0][0] * mat2.i[0][2]) + (i[0][1] * mat2.i[1][2]) + (i[0][2] * mat2.i[2][2]);
	
	result.i[1][0] = (i[1][0] * mat2.i[0][0]) + (i[1][1] * mat2.i[1][0]) + (i[1][2] * mat2.i[2][0]);
	result.i[1][1] = (i[1][0] * mat2.i[0][1]) + (i[1][1] * mat2.i[1][1]) + (i[1][2] * mat2.i[2][1]);
	result.i[1][2] = (i[1][0] * mat2.i[0][2]) + (i[1][1] * mat2.i[1][2]) + (i[1][2] * mat2.i[2][2]);
	
	result.i[2][0] = (i[2][0] * mat2.i[0][0]) + (i[2][1] * mat2.i[1][0]) + (i[2][2] * mat2.i[2][0]);
	result.i[2][1] = (i[2][0] * mat2.i[0][1]) + (i[2][1] * mat2.i[1][1]) + (i[2][2] * mat2.i[2][1]);
	result.i[2][2] = (i[2][0] * mat2.i[0][2]) + (i[2][1] * mat2.i[1][2]) + (i[2][2] * mat2.i[2][2]);
	
	return result;
}


const Matrix33& Matrix33::Invert()
{
	Matrix33 result;
	
	float d = (i[0][0] *	(i[2][2] * i[1][1] - i[2][1] * i[1][2] ) -
			   i[1][0] *	(i[2][2] * i[0][1] - i[2][1] * i[0][2] ) +
			   i[2][0] *	(i[1][2] * i[0][1] - i[1][1] * i[0][2] )    );
	
	if (d == 0.0f)
	{
		d = 1.0f;
	}
	
	float d_inv = 1.0f / d;
	
	result.i[0][0] =  d_inv *(i[2][2]*i[1][1] - i[2][1]*i[1][2]);
	result.i[0][1] = -d_inv *(i[2][2]*i[0][1] - i[2][1]*i[0][2]);
	result.i[0][2] =  d_inv *(i[1][2]*i[0][1] - i[1][1]*i[0][2]);
	result.i[1][0] = -d_inv *(i[2][2]*i[1][0] - i[2][0]*i[1][2]);
	result.i[1][1] =  d_inv *(i[2][2]*i[0][0] - i[2][0]*i[0][2]);
	result.i[1][2] = -d_inv *(i[1][2]*i[0][0] - i[1][0]*i[0][2]);
	result.i[2][0] =  d_inv *(i[2][1]*i[1][0] - i[2][0]*i[1][1]);
	result.i[2][1] = -d_inv *(i[2][1]*i[0][0] - i[2][0]*i[0][1]);
	result.i[2][2] =  d_inv *(i[1][1]*i[0][0] - i[1][0]*i[0][1]);
	
	(*this) = result;
	
	return *this;
}


const Matrix33& Matrix33::Transpose()
{
	int k, l;
	
	Matrix33 mat = (*this);
	
	for (k=0; k<3; k++)
	{
		for (l=0; l<3; l++)
		{
			i[k][l] = mat.i[l][k];
		}
	}
	
	return *this;
}

