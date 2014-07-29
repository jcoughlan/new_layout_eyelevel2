#ifndef VECTOR_4_H
#define VECTOR_4_H
#ifdef __cplusplus
#include "Vector3.h"

class Vector4
	{
	public:
		
		Vector4();
		Vector4(float, float, float, float);
		Vector4(float*);
		~Vector4();
		
		float i[4];
		
		void  Set(float, float, float, float);
		
		const Vector4& Normalise();
		
		Vector3 CastVector3();
		
		Vector4 XProd(const Vector4 &vec);
		
		float& operator[](int val);
		
		const Vector4& Homogonise();
		
		const Vector4& operator=(const Vector4 &vec);
		
		const Vector4& operator+=(const Vector4 &vec);
		
		const Vector4& operator-=(const Vector4 &vec);
		
		const Vector4& operator*=(const Vector4 &vec);
		
		const Vector4& operator/=(const Vector4 &vec);
		
		Vector4 operator*(const float &num);
		
		Vector4 operator/(const float &num);
		
		Vector4 operator*(const Vector4 &vec);
		
		Vector4 operator/(const Vector4 &vec);
		
		Vector4 operator+(const Vector4 &vec);
		
		Vector4 operator-(const Vector4 &vec);
		
	};
#endif
#endif // VECTOR_4_H