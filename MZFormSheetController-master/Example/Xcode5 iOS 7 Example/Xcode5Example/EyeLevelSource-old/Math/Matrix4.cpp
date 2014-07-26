#include "Maths.h"

//\=====================================================================================
/// Statics
//\=====================================================================================
// Constants
const Matrix4 Matrix4::ZERO
(
 0.0f, 0.0f, 0.0f, 0.0f, 
 0.0f, 0.0f, 0.0f, 0.0f,
 0.0f, 0.0f, 0.0f, 0.0f,
 0.0f, 0.0f, 0.0f, 0.0f
);
const Matrix4 Matrix4::IDENTITY
(
 1.0f, 0.0f, 0.0f, 0.0f, 
 0.0f, 1.0f, 0.0f, 0.0f,
 0.0f, 0.0f, 1.0f, 0.0f,
 0.0f, 0.0f, 0.0f, 1.0f
);
const Matrix4 Matrix4::ONE
(
 1.0f, 1.0f, 1.0f, 1.0f, 
 1.0f, 1.0f, 1.0f, 1.0f,
 1.0f, 1.0f, 1.0f, 1.0f,
 1.0f, 1.0f, 1.0f, 1.0f
);




//\=====================================================================================
///
//\=====================================================================================
const Matrix4 Matrix4::operator*( const Matrix4& mat ) const
{
	Matrix4 matAns;
	matAns.m_11 = m_11*mat.m_11 + m_12*mat.m_21 + m_13*mat.m_31 + m_14*mat.m_41;
	matAns.m_12 = m_11*mat.m_12 + m_12*mat.m_22 + m_13*mat.m_32 + m_14*mat.m_42;
	matAns.m_13 = m_11*mat.m_13 + m_12*mat.m_23 + m_13*mat.m_33 + m_14*mat.m_43;
	matAns.m_14 = m_11*mat.m_14 + m_12*mat.m_24 + m_13*mat.m_34 + m_14*mat.m_44;
	matAns.m_21 = m_21*mat.m_11 + m_22*mat.m_21 + m_23*mat.m_31 + m_24*mat.m_41;
	matAns.m_22 = m_21*mat.m_12 + m_22*mat.m_22 + m_23*mat.m_32 + m_24*mat.m_42;
	matAns.m_23 = m_21*mat.m_13 + m_22*mat.m_23 + m_23*mat.m_33 + m_24*mat.m_43;
	matAns.m_24 = m_21*mat.m_14 + m_22*mat.m_24 + m_23*mat.m_34 + m_24*mat.m_44;
	matAns.m_31 = m_31*mat.m_11 + m_32*mat.m_21 + m_33*mat.m_31 + m_34*mat.m_41;
	matAns.m_32 = m_31*mat.m_12 + m_32*mat.m_22 + m_33*mat.m_32 + m_34*mat.m_42;
	matAns.m_33 = m_31*mat.m_13 + m_32*mat.m_23 + m_33*mat.m_33 + m_34*mat.m_43;
	matAns.m_34 = m_31*mat.m_14 + m_32*mat.m_24 + m_33*mat.m_34 + m_34*mat.m_44;
	matAns.m_41 = m_41*mat.m_11 + m_42*mat.m_21 + m_43*mat.m_31 + m_44*mat.m_41;
	matAns.m_42 = m_41*mat.m_12 + m_42*mat.m_22 + m_43*mat.m_32 + m_44*mat.m_42;
	matAns.m_43 = m_41*mat.m_13 + m_42*mat.m_23 + m_43*mat.m_33 + m_44*mat.m_43;
	matAns.m_44 = m_41*mat.m_14 + m_42*mat.m_24 + m_43*mat.m_34 + m_44*mat.m_44;
	return matAns;
}

Matrix4::~Matrix4()
{
}

//\=====================================================================================
/// Calculates the inverse matrix.
//  This method assumes column4 == [0,0,0,1]
//\=====================================================================================
bool Matrix4::Inverse()
{	
	const float fDet = m_11*(m_22*m_33 - m_23*m_32) +
	m_12*(m_23*m_31 - m_21*m_33) +
	m_13*(m_21*m_32 - m_22*m_31);
	
	if( fDet != 0.0f )
	{	
		const float fInvDet = ( 1.f/fDet );
		
		Matrix4 mat = *this;
		m_11 = (mat.m_22*mat.m_33 - mat.m_23*mat.m_32)*fInvDet;
		m_12 = (mat.m_13*mat.m_32 - mat.m_12*mat.m_33)*fInvDet;
		m_13 = (mat.m_12*mat.m_23 - mat.m_13*mat.m_22)*fInvDet;
		m_14 = 0.0f;
		
		m_21 = (mat.m_23*mat.m_31 - mat.m_21*mat.m_33)*fInvDet;
		m_22 = (mat.m_11*mat.m_33 - mat.m_13*mat.m_31)*fInvDet;
		m_23 = (mat.m_13*mat.m_21 - mat.m_11*mat.m_23)*fInvDet;
		m_24 = 0.0f;
		
		m_31 = (mat.m_21*mat.m_32 - mat.m_22*mat.m_31)*fInvDet;
		m_32 = (mat.m_12*mat.m_31 - mat.m_11*mat.m_32)*fInvDet;
		m_33 = (mat.m_11*mat.m_22 - mat.m_12*mat.m_21)*fInvDet;
		m_34 = 0.0f;
		
		m_41 = (mat.m_21*(mat.m_33*mat.m_42 - mat.m_32*mat.m_43) +
				mat.m_22*(mat.m_31*mat.m_43 - mat.m_33*mat.m_41) +
				mat.m_23*(mat.m_32*mat.m_41 - mat.m_31*mat.m_42))*fInvDet;
		m_42 = (mat.m_11*(mat.m_32*mat.m_43 - mat.m_33*mat.m_42) +
				mat.m_12*(mat.m_33*mat.m_41 - mat.m_31*mat.m_43) +
				mat.m_13*(mat.m_31*mat.m_42 - mat.m_32*mat.m_41))*fInvDet;
		m_43 = (mat.m_11*(mat.m_23*mat.m_42 - mat.m_22*mat.m_43) +
				mat.m_12*(mat.m_21*mat.m_43 - mat.m_23*mat.m_41) +
				mat.m_13*(mat.m_22*mat.m_41 - mat.m_21*mat.m_42))*fInvDet;
		m_44 = 1.0f;
		
		return true;
	}
	else
	{
		return false;
	}
}

//\=====================================================================================
/// Gets the inverse matrix.
/// This method assumes column4 == [0,0,0,1]
//\=====================================================================================
bool Matrix4::GetInverse( Matrix4 &mat ) const
{	
	const float fDet = m_11*(m_22*m_33 - m_23*m_32) +
	m_12*(m_23*m_31 - m_21*m_33) +
	m_13*(m_21*m_32 - m_22*m_31);
	
	if( fDet != 0.0f )
	{	
		const float fInvDet = (fDet != 0.0f) ? (1.f/fDet) : 1.00e+12f;
		
		//CMatrix4 matInv;
		mat.m_11 = (m_22*m_33 - m_23*m_32)*fInvDet;
		mat.m_12 = (m_13*m_32 - m_12*m_33)*fInvDet;
		mat.m_13 = (m_12*m_23 - m_13*m_22)*fInvDet;
		mat.m_14 = 0.0f;
		
		mat.m_21 = (m_23*m_31 - m_21*m_33)*fInvDet;
		mat.m_22 = (m_11*m_33 - m_13*m_31)*fInvDet;
		mat.m_23 = (m_13*m_21 - m_11*m_23)*fInvDet;
		mat.m_24 = 0.0f;
		
		mat.m_31 = (m_21*m_32 - m_22*m_31)*fInvDet;
		mat.m_32 = (m_12*m_31 - m_11*m_32)*fInvDet;
		mat.m_33 = (m_11*m_22 - m_12*m_21)*fInvDet;
		mat.m_34 = 0.0f;
		
		mat.m_41 = (m_21*(m_33*m_42 - m_32*m_43) +
					m_22*(m_31*m_43 - m_33*m_41) +
					m_23*(m_32*m_41 - m_31*m_42))*fInvDet;
		mat.m_42 = (m_11*(m_32*m_43 - m_33*m_42) +
					m_12*(m_33*m_41 - m_31*m_43) +
					m_13*(m_31*m_42 - m_32*m_41))*fInvDet;
		mat.m_43 = (m_11*(m_23*m_42 - m_22*m_43) +
					m_12*(m_21*m_43 - m_23*m_41) +
					m_13*(m_22*m_41 - m_21*m_42))*fInvDet;
		mat.m_44 = 1.0f;
		
		return true;
	}
	else
	{
		return false;
	}
}

//\=====================================================================================
/// RotateLHS
//\=====================================================================================
void Matrix4::RotateLHS( const Vector3& vVector, float fAngle )
{
	const float co	= cosf( fAngle );
	const float ico	= 1 - cosf(fAngle);
	const float si	= sinf( fAngle );
	const float x	= vVector.x;
	const float y	= vVector.y;
	const float z	= vVector.z;
	//Where c = cos (theta), s = sin (theta), t = 1-cos (theta), and <X,Y,Z> is the unit vector representing the arbitary axis
	//tXX + c						tXY+sZ							tXZ - sY							0
	//tXY - sZ						tYY + c							tYZ + sX							0
	//tXZ + sY						tYZ - sX						tZZ + c								0
	// 0							0								0									1
	m_11 =  ico*x*z + co;			m_12 =  ico*x*y + si*z;			m_13 = ico*x*z - si*y;			m_14 = 0.0f;
	m_21 =	ico*x*y - si*z;			m_22 =  ico*y*y + co;			m_23 = ico*y*z + si*x;			m_24 = 0.0f;
	m_31 =	ico*x*z + si*y;			m_32 =	ico*y*z - si*x;			m_33 = ico*z*z + co;			m_34 = 0.0f;
	m_41 =	0.0f;					m_42 =	0.0f;					m_43 = 0.0f;					m_44 = 1.0f;
}

//\=====================================================================================
/// RotateRHS
//\=====================================================================================
void Matrix4::RotateRHS( const Vector3& vVector, float fAngle )
{
	const float co	= cosf( fAngle );
	const float ico	= 1 - cosf(fAngle);
	const float si	= sinf( fAngle );
	const float x	= vVector.x;
	const float y	= vVector.y;
	const float z	= vVector.z;
	//Where c = cos (theta), s = sin (theta), t = 1-cos (theta), and <X,Y,Z> is the unit vector representing the arbitary axis
	//tXX + c						tXY-sZ							tXY + sY							0
	//tXY + sZ						tYY + c							tYZ - sX							0
	//tXZ - sY						tYZ + sX						tZZ + c								0
	//0								0									0								1
	m_11 =  ico*x*x + co;			m_12 =  ico*x*y - si*z;			m_13 = ico*x*y + si*y;			m_14 = 0.0f;
	m_21 =	ico*x*y + si*z;			m_22 =  ico*y*y + co;			m_23 = ico*y*z - si*x;			m_24 = 0.0f;
	m_31 =	ico*x*z - si*y;			m_32 =	ico*y*z + si*x;			m_33 = ico*z*z + co;			m_34 = 0.0f;
	m_41 =	0.0f;					m_42 =	0.0f;					m_43 = 0.0f;					m_44 = 1.0f;
}

//\=====================================================================================
/// Sets View matrix following the D3D way:
///
///  |   rx     ux     lx    0 |    --> r = Right vector
///  |   ry     uy     ly    0 |	   --> u = Up vector
///  |   rz     uz     lz    0 |	   --> l = Look vector
///  | -(r.e) -(u.e) -(l.e)  1 |	   --> e = Eye position
///
//\=====================================================================================
void Matrix4::LookAtD3D( const Vector3& vEye, 
						 const Vector3& vLook, 
						 const Vector3& vUp )
{		
	Vector3 vRight;
	Vector3 vLook2;
	Vector3 vUp2;
	
	vLook2 = vLook.GetUnit();
	vRight = Cross( vUp, vLook2 );
	vRight.Normalise();
	vUp2 = Cross( vLook2, vRight );
	vUp2.Normalise();
	
	m_11 = vRight.x; m_12 = vUp2.x; m_13 = vLook2.x; m_14 = 0.0f;
	m_21 = vRight.y; m_22 = vUp2.y; m_23 = vLook2.y; m_24 = 0.0f;
	m_31 = vRight.z; m_32 = vUp2.z; m_33 = vLook2.z; m_34 = 0.0f;
	
	m_41 = -Dot( vEye, vRight );
	m_42 = -Dot( vEye, vUp2 );
	m_43 = -Dot( vEye, vLook2 );
	m_44 =  1.0f;		
}

//\=====================================================================================
/// Sets Projection matrix following the right-handed D3D way:
///
///  |    w      0      0     0 |    --> w = aspect-ratio * tan(fovy/2)
///  |    0      h      0     0 |    --> h = cot(fovy/2) 
///  |    0      0     -Q    -1 |    --> Q = zf/(zf-zn)
///  |    0      0    -zn*Q   0 |
///
//\=====================================================================================
bool Matrix4::ProjectionRightD3D( float fRadFovY,
								  float fAspectRatio,
								  float fZNear,
								  float fZFar )
{	
	const float si = sinf( fRadFovY*0.5f );
	const float co = cosf( fRadFovY*0.5f );
	
	if( fabsf( fZFar-fZNear ) < 0.01f )
	{
		return false;
	}
	if( fabsf( si ) < 0.01f )
	{
		return false;
	}
	
	const float h = co/si;
	const float w = fAspectRatio*h;	
	const float Q = fZFar/(fZFar-fZNear);
	
	m_11 =    w; m_12 = 0.0f; m_13 =      0.0f; m_14 =  0.0f;
	m_21 = 0.0f; m_22 =    h; m_23 =      0.0f; m_24 =  0.0f;
	m_31 = 0.0f; m_32 = 0.0f; m_33 =        -Q; m_34 = -1.0f;
	m_41 = 0.0f; m_42 = 0.0f; m_43 = -fZNear*Q; m_44 =  0.0f;
	
	return true;
}

//\=====================================================================================
/// Sets Projection matrix with zfar at infinity following the left-handed
/// (native) D3D way:
///
///  |    w      0       0       0 |    --> w = aspect-ratio * tan(fovy/2)
///  |    0      h       0       0 |    --> h = cot(fovy/2) 
///  |    0      0     eps-1    -1 |    --> eps
///  |    0      0   zn*( eps-1)  0 |    
///
//\=====================================================================================
bool Matrix4::ProjectionRightInfinityD3D( float fRadFovY,
										  float fAspectRatio,
										  float fZNear,
										  float fEpsilon )
{
	const float si = sinf( fRadFovY*0.5f );
	const float co = cosf( fRadFovY*0.5f );
	
	if( fabsf( si ) < 0.01f )
	{
		return false;
	}
	
	const float h = co/si;
	const float w = fAspectRatio*h;		
	
	m_11 =    w; m_12 = 0.0f; m_13 =                   0.0f; m_14 =  0.0f;
	m_21 = 0.0f; m_22 =    h; m_23 =                   0.0f; m_24 =  0.0f;
	m_31 = 0.0f; m_32 = 0.0f; m_33 =          fEpsilon-1.0f; m_34 = -1.0f;
	m_41 = 0.0f; m_42 = 0.0f; m_43 = fZNear*(fEpsilon-1.0f); m_44 =  0.0f;
	
	return true;
}

//\=====================================================================================
/// Sets Projection matrix following the left-handed (native) D3D way:
///
///  |    w      0      0     0 |    --> w = aspect-ratio * tan(fovy/2)
///  |    0      h      0     0 |    --> h = cot(fovy/2) 
///  |    0      0      Q     1 |    --> Q = zf/(zf-zn)
///  |    0      0    -zn*Q   0 |
///
//\=====================================================================================
bool Matrix4::ProjectionLeftD3D( float fRadFovY,
								 float fAspectRatio,
								 float fZNear,
								 float fZFar )
{	
	const float si = sinf( fRadFovY*0.5f );
	const float co = cosf( fRadFovY*0.5f );
	
    if( fabsf( fZFar-fZNear ) < 0.01f )
	{
		return false;
	}
	if( fabsf( si ) < 0.01f )
	{
		return false;
	}
	
	const float h = co/si;
	const float w = fAspectRatio*h;	
	const float Q = fZFar/(fZFar-fZNear);
	
	m_11 =    w; m_12 = 0.0f; m_13 =      0.0f; m_14 = 0.0f;
	m_21 = 0.0f; m_22 =    h; m_23 =      0.0f; m_24 = 0.0f;
	m_31 = 0.0f; m_32 = 0.0f; m_33 =         Q; m_34 = 1.0f;
	m_41 = 0.0f; m_42 = 0.0f; m_43 = -fZNear*Q; m_44 = 0.0f;
	
	return true;
}

//\=====================================================================================
/// Sets Projection matrix with zfar at infinity following the left-handed
/// (native) D3D way:
///
///  |    w      0       0       0 |    --> w = aspect-ratio * tan(fovy/2)
///  |    0      h       0       0 |    --> h = cot(fovy/2) 
///  |    0      0     1-eps     1 |    --> eps
///  |    0      0   zn*( eps-1)  0 |    
///
//\=====================================================================================
bool Matrix4::ProjectionLeftInfinityD3D( float fRadFovY,
										 float fAspectRatio,
										 float fZNear,
										 float fEpsilon )
{
	const float si = sinf( fRadFovY*0.5f );
	const float co = cosf( fRadFovY*0.5f );
	
	if( fabsf( si ) < 0.01f )
	{
		return false;
	}
	
	const float h = co/si;
	const float w = fAspectRatio*h;		
	
	m_11 =    w; m_12 = 0.0f; m_13 =                   0.0f; m_14 = 0.0f;
	m_21 = 0.0f; m_22 =    h; m_23 =                   0.0f; m_24 = 0.0f;
	m_31 = 0.0f; m_32 = 0.0f; m_33 =          1.0f-fEpsilon; m_34 = 1.0f;
	m_41 = 0.0f; m_42 = 0.0f; m_43 = fZNear*(fEpsilon-1.0f); m_44 = 0.0f;
	
	return true;
}


Matrix4      Matrix4::CreateRotationX( float rads )
{
    Matrix4 ret( Matrix4::IDENTITY );
    
    ret.RotateX( rads );
    
    return ret;
}

Matrix4      Matrix4::CreateRotationY( float rads )
{
    Matrix4 ret( Matrix4::IDENTITY );
    
    ret.RotateY( rads );
    
    return ret;
}

Matrix4      Matrix4::CreateRotationZ( float rads )
{
    Matrix4 ret( Matrix4::IDENTITY );
    
    ret.RotateZ( rads );
    
    return ret;
}

Matrix4      Matrix4::CreateTranslation( const Vector3& position )
{
    Matrix4 ret( Matrix4::IDENTITY );
    
    ret.Translate( position );
    
    return ret;
}

Matrix4      Matrix4::CreateScale( const Vector3& xyzScale )
{
    Matrix4 ret( Matrix4::IDENTITY );
    
    ret.Scale( xyzScale );
    
    return ret;
}

Matrix4      Matrix4::CreateFromYawPitchRoll( float yaw, float pitch, float roll )
{
    Matrix4 ret( Matrix4::IDENTITY );
    
    ret.RotateZYX( Vector3( pitch, yaw, roll ) ); 
    
    return ret;
}

Matrix4      Matrix4::CreateScale( float uniformScale )
{
    Matrix4 ret( Matrix4::IDENTITY );

    ret.Scale( uniformScale );
    
    return ret;
}

Matrix4      Matrix4::CreateFromQuaternion( const Quaternion& quat )
{
    Matrix4 ret = Matrix4();
    quat.GetRotationMatrix( ret );
    return ret;
}

//\=====================================================================================
/// Sets Ortho Projection matrix 
/// OpenGL way:
///
///  |  2/r-l    0       0    -r+l/r-l |   
///  |    0    2/t-b     0    -t+b/t-b |   
///  |    0      0     -2/f-n -f+n/f-n |   
///  |    0      0		 0		  1    |    
///
//\=====================================================================================
Matrix4 Matrix4::CreateOrthographic( float left, float right, float top, float bottom, float near, float far )
{
    
	float       deltaX = right - left;
	float       deltaY = top - bottom;
	float       deltaZ = far - near;
	
	return Matrix4( 2.0f/deltaX, 0.f, 0.f, 0.f,
                   0.f, 2.0f/deltaY, 0.0f, 0.f,
                   0.f,0.f,-2.f/deltaZ,0.f,
                   -((right+left)/deltaX), -((top+bottom)/deltaY), -((far+near)/deltaZ), 1.0f);
                   
}

Matrix4 Matrix4::CreatePerspective( float fieldOfViewRadians, float aspectRatio, float near, float far )
{
    
    float size = near * tanf( fieldOfViewRadians  / 2.0);
    float left = -size, right = size, bottom = -size / aspectRatio, top = size / aspectRatio;
  

    return Matrix4( (2 * near) /( right - left ),    0.f,                                    0.f,        0.f,
                   0.f,                             (2 * near) / (top - bottom ),            0.f,                                    0.f,
                   (right + left) / (right - left),                             (top + bottom ) / (top - bottom),      -(far + near) / (far - near),       -1.f,
                   0.f,                             0.f,                                    - (2 * far * near) / (far - near ), 0.f);
    
    
}


void Matrix4::RemoveZRotation()
{
	Vector3		v3Up		=	Vector3(0.0f,1.0f,0.0f);
	Vector3		v3Right		=	Vector3(1.0f,0.0f,0.0f);
	Vector3		v3ZAxis		=	Vector3::ZERO;
	GetCol(2, v3ZAxis);
	
	v3Up = v3Up - ( v3ZAxis * Dot( v3ZAxis, v3Up ) );
	v3Up.Normalise();
	v3Right = Cross( v3Up, v3ZAxis);
	v3Right.Normalise();
	
	SetCol(0, v3Right);
	SetCol(1, v3Up);
	SetCol(2, v3ZAxis);
	SetRow(4, Vector3::ZERO);
}