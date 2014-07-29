#ifndef PI_MATHS_H
#define PI_MATHS_H
#ifdef __cplusplus
#include "math.h"
#include "stdlib.h"

#include "MathsDefines.h"

#include "Vector.h"
#include "Vector2.h"
#include "Vector3.h"
#include "Vector4.h"

#include "Matrix33.h"
#include "Matrix4.h"

#include "Quaternion.h"

#include "Plane.h"

#include "Util.h"

//Vector2& operator ( const IVector2 &v );
//IVector2& operator ( const Vector2 &v );

Vector2 IVector2ToVector2( const IVector2 &v );
IVector2 Vector2ToIVector2( const Vector2 &v );


#endif
#endif // PI_MATHS_H
