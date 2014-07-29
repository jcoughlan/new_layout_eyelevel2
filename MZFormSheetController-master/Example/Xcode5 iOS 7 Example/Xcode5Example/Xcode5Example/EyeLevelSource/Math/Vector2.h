#ifndef VECTOR_2_H
#define VECTOR_2_H
#ifdef __cplusplus
//#include "Maths.h"

class Vector2
	{
	public:
		
		Vector2();
		Vector2( float x, float y );
        
        static const Vector2 ZERO;
		
		void			Set( float x, float y );
		
		void			Clamp		( float fMin, float fMax );
		float			DProd		( const Vector2& v ) const;
		float			Length		() const;
		float			LengthSqrd	() const;
		Vector2			Normal		() const;
		float			Normalise	();
		void			Rotate		( float fAngle );
		float&			operator[]	( int val );
		Vector2			operator *	( float s ) const;
		const Vector2&	operator *=	( float s );
		const Vector2&	operator =	( const Vector2& v );
		Vector2			operator +	( const Vector2& v ) const;
		Vector2			operator -	( const Vector2& v ) const;
		const Vector2&	operator +=	( const Vector2& v );
		const Vector2&	operator -=	( const Vector2& v );
		const Vector2&	operator *=	( const Vector2& v );
		bool			operator == ( const Vector2& v ) const;
		bool			operator != ( const Vector2& v ) const;
		float			PerpDot	( const Vector2& vec )const;
		friend float	PerpDot ( const Vector2& vecA, const Vector2& vecB );
		union
		{
			struct 
			{
				float x;
				float y;
			};
            struct
            {
                float u;
                float v;
            };
			struct 
			{
				float i[2];
			};
		};
	};
#endif
#endif // VECTOR_2_H