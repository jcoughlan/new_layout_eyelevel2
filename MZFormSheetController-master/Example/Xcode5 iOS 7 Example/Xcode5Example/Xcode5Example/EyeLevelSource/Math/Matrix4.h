#ifndef	_MATRIX4_H_
#define	_MATRIX4_H_
#ifdef __cplusplus
#include "Vector3.h"
#include "Matrix33.h"
#include "Quaternion.h"

class Matrix4
	{
	public:
		union
		{
			float			m[4][4];
			struct 
			{
				float		m_11, m_12, m_13, m_14;
				float		m_21, m_22, m_23, m_24;
				float		m_31, m_32, m_33, m_34;
				float		m_41, m_42, m_43, m_44;
			};
		};
		
		/// Constants 
		static const Matrix4 ZERO;
		static const Matrix4 IDENTITY;
		static const Matrix4 ONE;

		
		//Constructors
		Matrix4();
		Matrix4( const float* mat );
		Matrix4( float m11, float m12, float m13, float m14,
				 float m21, float m22, float m23, float m24,
				 float m31, float m32, float m33, float m34,
				 float m41, float m42, float m43, float m44 );
		//Destructor
		~Matrix4();
		
		//Operators
		// Access operators
		float&				operator () ( int iRow, int iCol );
		float				operator () ( int iRow, int iCol ) const;
		
		// Cols & Rows Access
		void				SetCol( int iCol, const Vector3& vCol );
		void				SetRow( int iRow, const Vector3& vRow );
		void				GetCol( int iCol, Vector3& vCol ) const;
		void				GetRow( int iRow, Vector3& vRow ) const;
        const Vector3      GetCol( int iCol ) const;
        const Vector3      GetRow( int iRow ) const;
		
		// Casting operators
		operator float* ();
		operator const float* () const;
		
		float *operator[](int row);
		const float *operator[](int row) const;
		
		// Neg operator
		const Matrix4		operator - () const;
		
		// Add & Sub operators
		const Matrix4		operator +  ( const Matrix4& mat ) const;
		const Matrix4		operator -  ( const Matrix4& mat ) const;
		const Matrix4&		operator += ( const Matrix4& mat );
		const Matrix4&		operator -= ( const Matrix4& mat );
		
		// Mul operators	
		const Matrix4        operator * ( float k ) const;
		friend const Matrix4 operator * ( float k, const Matrix4& mat );
		const Matrix4        operator * ( const Matrix4& mat ) const;
		const Vector3        operator * ( const Vector3& vec ) const;
		friend const Vector3 operator * ( const Vector3& vec, const Matrix4& mat );
		
		
		const Matrix4&		operator *= ( float k );
		const Matrix4&		operator *= ( const Matrix4& mat );
		
		// General matrix functions
		void				Identity();
		void				Zero();
		void				Translate( const Vector3& vec );
		void				GetTranslate( Vector3& vec );
		void				Scale( const Vector3& vec );
		void				Scale( float k );
		void				ReNormalise(); //Function to renormalise scale of matrix.
		void				Transpose();
		void				GetTranspose( Matrix4 &mat ) const;
		bool				Inverse();
		bool				GetInverse( Matrix4 &mat ) const;
		
		void  				RotateX( float fAngle );
		void  				RotateY( float fAngle );
		void  				RotateZ( float fAngle );
		void  				RotateXYZ( const Vector3& euAngles );
		void  				RotateYXZ( const Vector3& euAngles );
		void  				RotateZXY( const Vector3& euAngles );
		void  				RotateZYX( const Vector3& euAngles );
		
		void				RotateLHS( const Vector3& vVector, float fAngle );
		void				RotateRHS( const Vector3& vVector, float fAngle );
		
		void				RemoveZRotation(); //Basic GramSchmidt function to orthonormalise a matrix.
        
		// D3D metrics methods
		void				LookAtD3D( const Vector3& vEye, const Vector3& vLook, const Vector3& vUp );
		bool				ProjectionRightD3D( float fRadFovY, float fAspectRatio,
											   float fZNear, float fZFar );
		bool				ProjectionRightInfinityD3D( float fRadFovY, float fAspectRatio,
													   float fZNear, float fEpsilon = 0.001f );	
		bool				ProjectionLeftD3D( float fRadFovY, float fAspectRatio,
											  float fZNear, float fZFar );
		bool				ProjectionLeftInfinityD3D( float fRadFovY, float fAspectRatio,
													  float fZNear, float fEpsilon = 0.001f );
        
        //MORE USER FRIENDLY IMPL COPYING MICROSOFTS XNA NAMING ( http://msdn.microsoft.com/en-us/library/microsoft.xna.framework.matrix_members.aspx )
        static Matrix4      CreateFromYawPitchRoll( float yaw, float pitch, float roll );
        static Matrix4      CreateTranslation( const Vector3& position );
        static Matrix4      CreateScale( const Vector3& xyzScale );
        static Matrix4      CreateScale( float uniformScale );
        static Matrix4      CreateRotationX( float rads );
        static Matrix4      CreateRotationY( float rads );
        static Matrix4      CreateRotationZ( float rads );
        static Matrix4      CreateFromQuaternion( const Quaternion& quat );
        static Matrix4      CreatePerspective( float fieldOfViewRadians, float aspectRatio, float near, float far);
        static Matrix4      CreatePerspective( float fovHorizonal, float fovVertical, float aspectRatio, float near, float far );
        static Matrix4      CreateOrthographic( float left, float right, float top, float bottom, float near, float far );
        
        
        
	private:
		
	};


//\=====================================================================================
/// Default Constructor
//\=====================================================================================
inline Matrix4::Matrix4()
{
	
}

//\=====================================================================================
///
//\=====================================================================================
inline Matrix4::Matrix4( const float* mat ) : 
m_11( mat[ 0] ), m_12( mat[ 1] ), m_13( mat[ 2] ), m_14( mat[ 3] ),
m_21( mat[ 4] ), m_22( mat[ 5] ), m_23( mat[ 6] ), m_24( mat[ 7] ),
m_31( mat[ 8] ), m_32( mat[ 9] ), m_33( mat[10] ), m_34( mat[11] ),
m_41( mat[12] ), m_42( mat[13] ), m_43( mat[14] ), m_44( mat[15] )
{
	
}

//\=====================================================================================
///
//\=====================================================================================
inline Matrix4::Matrix4( float m11, float m12, float m13, float m14,
						  float m21, float m22, float m23, float m24,
						  float m31, float m32, float m33, float m34,
						  float m41, float m42, float m43, float m44 ) :
m_11( m11 ), m_12( m12 ), m_13( m13 ), m_14( m14 ),
m_21( m21 ), m_22( m22 ), m_23( m23 ), m_24( m24 ),
m_31( m31 ), m_32( m32 ), m_33( m33 ), m_34( m34 ),
m_41( m41 ), m_42( m42 ), m_43( m43 ), m_44( m44 )
{
}

//\=====================================================================================
///
//\=====================================================================================
/*INLINE Matrix4::Matrix4( const Matrix3& mat ) :
 m_11( mat.m_11 ), m_12( mat.m_12 ), m_13( mat.m_13 ), m_14( 0.0f ),
 m_21( mat.m_21 ), m_22( mat.m_22 ), m_23( mat.m_23 ), m_24( 0.0f ),
 m_31( mat.m_31 ), m_32( mat.m_32 ), m_33( mat.m_33 ), m_34( 0.0f ),
 m_41(     0.0f ), m_42(     0.0f ), m_43(     0.0f ), m_44( 1.0f ) 
 {
 
 }*/

//\=====================================================================================
///
//\=====================================================================================
inline float& Matrix4::operator()( int iRow, int iCol )
{
	return m[iRow][iCol];
}

//\=====================================================================================
///
//\=====================================================================================
inline float Matrix4::operator()( int iRow, int iCol ) const
{
	return m[iRow][iCol];
}
//\=====================================================================================
///
//\=====================================================================================
inline float *Matrix4::operator[](int row)
{
    return m[row];
}
//\=====================================================================================
///
//\=====================================================================================
inline const float *Matrix4::operator[](int row) const
{
    return m[row];
}
//\=====================================================================================
///
//\=====================================================================================
inline void Matrix4::SetCol( int iCol, const Vector3& vCol )
{
	m[0][iCol] = vCol.x;
	m[1][iCol] = vCol.y;
	m[2][iCol] = vCol.z;
}

//\=====================================================================================
/// 
//\=====================================================================================
inline void Matrix4::SetRow( int iRow, const Vector3& vRow )
{
	m[iRow][0] = vRow.x;
	m[iRow][1] = vRow.y;
	m[iRow][2] = vRow.z;
}

//\=====================================================================================
/// 
//\=====================================================================================
inline void Matrix4::GetCol( int iCol, Vector3& vCol ) const
{
	vCol.x = m[0][iCol];
	vCol.y = m[1][iCol];
	vCol.z = m[2][iCol];
}

//\=====================================================================================
///
//\=====================================================================================
inline void Matrix4::GetRow( int iRow, Vector3& vRow ) const
{
	vRow.x = m[iRow][0];
	vRow.y = m[iRow][1];
	vRow.z = m[iRow][2];
}


inline const Vector3      Matrix4::GetCol( int iCol ) const
{
    return Vector3( m[0][iCol], m[1][iCol], m[2][iCol] );
}

inline const Vector3      Matrix4::GetRow( int iRow ) const
{
    return Vector3( m[iRow][0], m[iRow][1], m[iRow][2] );
}

//\=====================================================================================
///
//\=====================================================================================
inline Matrix4::operator float*()
{
	return static_cast<float*>( &m_11 );
}

//\=====================================================================================
///
//\=====================================================================================
inline Matrix4::operator const float*() const
{
	return static_cast<const float*>( &m_11 );
}

//\=====================================================================================
///
//\=====================================================================================
inline const Matrix4 Matrix4::operator-() const 
{
	return Matrix4( -m_11, -m_12, -m_13, -m_14,
					-m_21, -m_22, -m_23, -m_24,
					-m_31, -m_32, -m_33, -m_34,
					-m_41, -m_42, -m_43, -m_44 );
}

//\=====================================================================================
///
//\=====================================================================================
inline const Matrix4 Matrix4::operator+( const Matrix4& mat ) const
{
	return Matrix4( m_11+mat.m_11, m_12+mat.m_12, m_13+mat.m_13, m_14+mat.m_14,
					m_21+mat.m_21, m_22+mat.m_22, m_23+mat.m_23, m_24+mat.m_24,
					m_31+mat.m_31, m_32+mat.m_32, m_33+mat.m_33, m_34+mat.m_34,
					m_41+mat.m_41, m_42+mat.m_42, m_43+mat.m_43, m_44+mat.m_44 );
}

//\=====================================================================================
///
//\=====================================================================================
inline const Matrix4 Matrix4::operator-( const Matrix4& mat ) const
{
	return Matrix4( m_11-mat.m_11, m_12-mat.m_12, m_13-mat.m_13, m_14-mat.m_14,
					m_21-mat.m_21, m_22-mat.m_22, m_23-mat.m_23, m_24-mat.m_24,
					m_31-mat.m_31, m_32-mat.m_32, m_33-mat.m_33, m_34-mat.m_34,
					m_41-mat.m_41, m_42-mat.m_42, m_43-mat.m_43, m_44-mat.m_44 );
}

//\=====================================================================================
///
//\=====================================================================================
inline const Matrix4& Matrix4::operator+=( const Matrix4& mat )
{
	m_11 += mat.m_11; m_12 += mat.m_12; m_13 += mat.m_13;	m_14 += mat.m_14;
	m_21 += mat.m_21; m_22 += mat.m_22; m_23 += mat.m_23;	m_24 += mat.m_24;
	m_31 += mat.m_31; m_32 += mat.m_32; m_33 += mat.m_33;	m_34 += mat.m_34;
	m_41 += mat.m_41; m_42 += mat.m_42; m_43 += mat.m_43;	m_44 += mat.m_44;
	return *this;
}

//\=====================================================================================
///
//\=====================================================================================
inline const Matrix4& Matrix4::operator-=( const Matrix4& mat )
{
	m_11 -= mat.m_11; m_12 -= mat.m_12;	m_13 -= mat.m_13; m_14 -= mat.m_14;
	m_21 -= mat.m_21; m_22 -= mat.m_22;	m_23 -= mat.m_23; m_24 -= mat.m_24;
	m_31 -= mat.m_31; m_32 -= mat.m_32;	m_33 -= mat.m_33; m_34 -= mat.m_34;
	m_41 -= mat.m_41; m_42 -= mat.m_42;	m_43 -= mat.m_43; m_44 -= mat.m_44;
	return *this;
}

//\=====================================================================================
///
//\=====================================================================================
inline const Matrix4 Matrix4::operator*( float k ) const
{
	return Matrix4( m_11*k, m_12*k, m_13*k, m_14*k,
					m_21*k, m_22*k, m_23*k, m_24*k,
					m_31*k, m_32*k, m_33*k, m_34*k,
					m_41*k, m_42*k, m_43*k, m_44*k );
}

//\=====================================================================================
///
//\=====================================================================================
inline const Matrix4 operator*( float k, const Matrix4& mat )
{
	return mat*k;
}

//\=====================================================================================
///
//\=====================================================================================
inline const Vector3 Matrix4::operator*( const Vector3& vec ) const
{
	Vector3 V;
	V.x = m_11*vec.x + m_12*vec.y + m_13*vec.z + m_14;
	V.x = AT_EPSILON(V.x);
	
	V.y = m_21*vec.x + m_22*vec.y + m_23*vec.z + m_24;
	V.y = AT_EPSILON(V.y);
	
	V.z = m_31*vec.x + m_32*vec.y + m_33*vec.z + m_34;
	V.z = AT_EPSILON(V.z);
	return V;
}

//\=====================================================================================
///
//\=====================================================================================
inline const Vector3 operator*( const Vector3& vec, const Matrix4& mat )
{
	Vector3 V;
	V.x = vec.x*mat.m_11 + vec.y*mat.m_21 + vec.z*mat.m_31 + mat.m_41;
	V.x = AT_EPSILON(V.x);
	
	V.y = vec.x*mat.m_12 + vec.y*mat.m_22 + vec.z*mat.m_32 + mat.m_42;
	V.y = AT_EPSILON(V.y);
	
	V.z = vec.x*mat.m_13 + vec.y*mat.m_23 + vec.z*mat.m_33 + mat.m_43;
	V.z = AT_EPSILON(V.z);
	return V;
}



//\=====================================================================================
///
//\=====================================================================================
inline const Matrix4& Matrix4::operator*=( float k )
{
	m_11 *= k; m_12 *= k; m_13 *= k; m_14 *= k;
	m_21 *= k; m_22 *= k; m_23 *= k; m_24 *= k;
	m_31 *= k; m_32 *= k; m_33 *= k; m_34 *= k;
	m_41 *= k; m_42 *= k; m_43 *= k; m_44 *= k;
	return *this;
}

//\=====================================================================================
///
//\=====================================================================================
inline const Matrix4& Matrix4::operator*=( const Matrix4& mat )
{
	*this = (*this)*mat;
	return *this;
}

//\=====================================================================================
///
//\=====================================================================================
inline void Matrix4::Identity()
{
	m_11 = 1.0f; m_12 = 0.0f; m_13 = 0.0f; m_14 = 0.0f;
	m_21 = 0.0f; m_22 = 1.0f; m_23 = 0.0f; m_24 = 0.0f;
	m_31 = 0.0f; m_32 = 0.0f; m_33 = 1.0f; m_34 = 0.0f;
	m_41 = 0.0f; m_42 = 0.0f; m_43 = 0.0f; m_44 = 1.0f;
}

//\=====================================================================================
///
//\=====================================================================================
inline void Matrix4::Zero()
{
	m_11 = 0.0f; m_12 = 0.0f; m_13 = 0.0f; m_14 = 0.0f;
	m_21 = 0.0f; m_22 = 0.0f; m_23 = 0.0f; m_24 = 0.0f;
	m_31 = 0.0f; m_32 = 0.0f; m_33 = 0.0f; m_34 = 0.0f;
	m_41 = 0.0f; m_42 = 0.0f; m_43 = 0.0f; m_44 = 0.0f;
}

//\=====================================================================================
///
//\=====================================================================================
inline void Matrix4::Translate( const Vector3& vec )
{
	m_11 =  1.0f; m_12 =  0.0f; m_13 =  0.0f; m_14 = 0.0f;
	m_21 =  0.0f; m_22 =  1.0f; m_23 =  0.0f; m_24 = 0.0f;
	m_31 =  0.0f; m_32 =  0.0f; m_33 =  1.0f; m_34 = 0.0f;
	m_41 = vec.x; m_42 = vec.y; m_43 = vec.z; m_44 = 1.0f;
}

//\=====================================================================================
///
//\=====================================================================================
inline void Matrix4::GetTranslate( Vector3& vec )
{
	vec.x = m_41;
	vec.y = m_42;
	vec.z = m_43;
}

//\=====================================================================================
///
//\=====================================================================================
inline void Matrix4::Scale( const Vector3& vec )
{
	m[0][0] *= vec.x; m[1][0] *= vec.x; m[2][0] *= vec.x;
	m[0][1] *= vec.y; m[1][1] *= vec.y; m[2][1] *= vec.y;
	m[0][2] *= vec.z; m[1][2] *= vec.z; m[2][2] *= vec.z;
	
	//m_11 = vec.x; m_12 =  0.0f; m_13 =  0.0f; m_14 = 0.0f;
	//m_21 =  0.0f; m_22 = vec.y; m_23 =  0.0f; m_24 = 0.0f;
	//m_31 =  0.0f; m_32 =  0.0f; m_33 = vec.z; m_34 = 0.0f;
	//m_41 =  0.0f; m_42 =  0.0f; m_43 =  0.0f; m_44 = 1.0f;
}

//\=====================================================================================
///
//\=====================================================================================
inline void Matrix4::Scale( float k )
{
	Scale( Vector3( k, k, k ) );
}
//\=====================================================================================
///
//\=====================================================================================
inline void Matrix4::ReNormalise()
{
	Vector3 vX = Vector3( m[0][0], m[1][0], m[2][0] );
	Vector3 vY = Vector3( m[0][1], m[1][1], m[2][1] );
	Vector3 vZ = Vector3( m[0][2], m[1][2], m[2][2] );
	vX.Normalise();
	vY.Normalise();
	vZ.Normalise();
	m[0][0] = vX.x; m[1][0] = vX.y; m[2][0] = vX.z;
	m[0][1] = vY.x; m[1][1] = vY.y; m[2][1] = vY.z;
	m[0][2] = vZ.x; m[1][2] = vZ.y; m[2][2] = vZ.z;
	
}
//\=====================================================================================
///
//\=====================================================================================
inline void Matrix4::Transpose()
{
	float k;
	k = m_12; m_12 = m_21; m_21 = k;
	k = m_13; m_13 = m_31; m_31 = k;
	k = m_23; m_23 = m_32; m_32 = k;	
	k = m_14; m_14 = m_41; m_41 = k;	
	k = m_24; m_24 = m_42; m_42 = k;
	k = m_34; m_34 = m_43; m_43 = k;
}

//\=====================================================================================
///
//\=====================================================================================
inline void Matrix4::GetTranspose( Matrix4 &mat ) const
{
	mat.m_11 = m_11; mat.m_12 = m_21; mat.m_13 = m_31; mat.m_14 = m_41;
	mat.m_21 = m_12; mat.m_22 = m_22; mat.m_23 = m_32; mat.m_24 = m_42;
	mat.m_31 = m_13; mat.m_32 = m_23; mat.m_33 = m_33; mat.m_34 = m_43;
	mat.m_41 = m_14; mat.m_42 = m_24; mat.m_43 = m_34; mat.m_44 = m_44;
}

//\=====================================================================================
///
//\=====================================================================================
inline void Matrix4::RotateX( float fAngle )
{
	const float co = cosf( fAngle );
	const float si = sinf( fAngle );
	m_11 = 1.0f; m_12 = 0.0f; m_13 = 0.0f; m_14 = 0.0f;
	m_21 = 0.0f; m_22 =   co; m_23 =   -si; m_24 = 0.0f;
	m_31 = 0.0f; m_32 =   si; m_33 =   co; m_34 = 0.0f;
	m_41 = 0.0f; m_42 = 0.0f; m_43 = 0.0f; m_44 = 1.0f;
}

//\=====================================================================================
///
//\=====================================================================================
inline void Matrix4::RotateY( float fAngle )
{
	const float co = cosf( fAngle );
	const float si = sinf( fAngle );
	m_11 =   co; m_12 = 0.0f; m_13 =   si; m_14 = 0.0f;
	m_21 = 0.0f; m_22 = 1.0f; m_23 = 0.0f; m_24 = 0.0f;
	m_31 =  -si; m_32 = 0.0f; m_33 =   co; m_34 = 0.0f;
	m_41 = 0.0f; m_42 = 0.0f; m_43 = 0.0f; m_44 = 1.0f;
}

//\=====================================================================================
///
//\=====================================================================================
inline void Matrix4::RotateZ( float fAngle )
{
	const float co = cosf( fAngle );
	const float si = sinf( fAngle );
	m_11 =   co; m_12 =  -si; m_13 = 0.0f; m_14 = 0.0f;
	m_21 =   si; m_22 =   co; m_23 = 0.0f; m_24 = 0.0f;
	m_31 = 0.0f; m_32 = 0.0f; m_33 = 1.0f; m_34 = 0.0f;
	m_41 = 0.0f; m_42 = 0.0f; m_43 = 0.0f; m_44 = 1.0f;
}

//\=====================================================================================
///
//\=====================================================================================
inline void Matrix4::RotateXYZ( const Vector3& euAngles )
{
	Matrix4 XM, YM, ZM;
	XM.RotateX( euAngles.x );
	YM.RotateY( euAngles.y );
	ZM.RotateZ( euAngles.z );
	*this = XM*YM*ZM;
}

//\=====================================================================================
///
//\=====================================================================================
inline void Matrix4::RotateYXZ( const Vector3& euAngles )
{
	Matrix4 XM, YM, ZM;
	YM.RotateY( euAngles.y );
	XM.RotateX( euAngles.x );
	ZM.RotateZ( euAngles.z );
	*this = YM*XM*ZM;
}

//\=====================================================================================
///
//\=====================================================================================
inline void Matrix4::RotateZXY( const Vector3& euAngles )
{
	Matrix4 XM, YM, ZM;
	ZM.RotateZ( euAngles.z );
	XM.RotateX( euAngles.x );
	YM.RotateY( euAngles.y );
	*this = ZM*XM*YM;
}

//\=====================================================================================
///
//\=====================================================================================
inline void Matrix4::RotateZYX( const Vector3& euAngles )
{
	Matrix4 XM, YM, ZM;
	ZM.RotateZ( euAngles.z );
	YM.RotateY( euAngles.y );
	XM.RotateX( euAngles.x );
	*this = ZM*YM*XM;
}
#endif
#endif //__MATRIX4_H__