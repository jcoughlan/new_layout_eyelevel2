#ifndef MATRIX_33_H
#define MATRIX_33_H

#include "Maths.h"

#ifdef __cplusplus
class Matrix33
{
public:
	
	Matrix33();
	~Matrix33();
	
	float	i[3][3];
	void identity();
	const Matrix33& operator=(const Matrix33 &mat);
	
	float *operator[](int row);
    const float *operator[](int row) const;
	
	Matrix33 operator*(const Matrix33 &mat);
	
	Vector3 operator*(const Vector3 &vec);
	
	void			Scale( float s );
	
	const Matrix33& LoadIdentity();
	const Matrix33& Transpose();
	const Matrix33& Invert();
	const Matrix33& Normalise();
	
	const Matrix33& SetTrans( const float &x, const float &y, const float &z );
	const Matrix33&	SetTrans( const Vector3& vec );
	const Matrix33& SetRot2D( const float &angle );
	const Matrix33& SetRot3D( float yaw, float pitch, float roll );
	const Matrix33& SetRot3D( const Vector3& vec );
};

inline void Matrix33::identity()
{
    i[0][0] = 1.0f, i[0][1] = 0.0f, i[0][2] = 0.0f;
    i[1][0] = 0.0f, i[1][1] = 1.0f, i[1][2] = 0.0f;
    i[2][0] = 0.0f, i[2][1] = 0.0f, i[2][2] = 1.0f;
}

inline float *Matrix33::operator[](int row)
{
    return i[row];
}

inline const float *Matrix33::operator[](int row) const
{
    return i[row];
}
#endif
#endif // MATRIX_33_H