#ifndef QUATERNION_H
#define QUATERNION_H

//#include "Maths.h"
#include "Vector3.h"
class Matrix33;
class Matrix4;

class Quaternion
	{
	public:
		
		float	w;
		Vector3	v;
		
		Quaternion();
		Quaternion( float x, float y, float z, float w );
		Quaternion( Vector3& v, float w );
		~Quaternion();
		
		void				identity();
		void				Normalise();
		float				Magnitude()  const;
		Vector3				GetVector();
		float				GetScalar();
		
		Vector3				GetRotationAxis()  const;
		float				GetRotationAngle()  const;
		
		void				ConstructFromAxisAngle( const Vector3& vAxis, float fAngle );
		void				GetRotationAxisAngle( Vector3& vAxis, float& fAngle );
		void				ConstructFromEulerAngles( float yaw, float pitch, float roll );
		void				GetRotationMatrix( Matrix33& m )  const;
		void				GetRotationMatrix( Matrix4& m )  const;
		void				GetEulerAngles( float &yaw, float &pitch, float &roll )  const;
		void				CreateMatrix(Matrix4 &pMatrix);
		void				fromMatrix(const Matrix33 &m);
		void				fromMatrix(const Matrix4 &m);
		Matrix33			toMatrix3() const;
		Matrix4			toMatrix4() const;
		const Quaternion&	RotateByQuat( const Quaternion& q );
		Vector3				RotateVec	( const Vector3& vec )  const;
		
		Quaternion			operator * ( float s )  const;
		Quaternion			operator / ( float s )  const;
		
		Quaternion			operator + ( const Quaternion& q ) const;
		Quaternion			operator - ( const Quaternion& q ) const;
		Quaternion			operator * ( const Quaternion& q ) const;
		
		const Quaternion&	operator +=	( const Quaternion& q );
		const Quaternion&	operator -=	( const Quaternion& q );
		const Quaternion&	operator *=	( float s );
		Quaternion			operator ~	()  const;
        
        //XNA-IFIED METHODS - more user friendly..
        
        static const Quaternion IDENTITY;
        
        static Quaternion CreateFromYawPitchRoll( float yaw, float pitch, float roll );
        
	};

Quaternion			operator * ( const Quaternion& q, const Vector3& vec );
Quaternion			operator * ( const Vector3& vec, const Quaternion& q );

inline void Quaternion::identity()
{
    w = 1.0f, v.x = v.y = v.z = 0.0f;
}

#endif // QUATERNION_H