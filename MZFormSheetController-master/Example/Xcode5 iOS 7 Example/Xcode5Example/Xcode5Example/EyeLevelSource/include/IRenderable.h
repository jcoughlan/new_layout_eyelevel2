//\=====================================================================================
///
/// @author	Ryan Sullivan
/// @brief	Abstract interface class that provides the basis for all renderables to be drawn by the 
///         EAGLView Renderer.
///
//\=====================================================================================

#ifndef __IRENDERABLE_H__
#define __IRENDERABLE_H__

#include "Matrix4.h"

class IRenderable 
{
public:
	virtual ~IRenderable() { }
	virtual void draw( int* shaderParams) = 0;
    virtual Matrix4 getTransformation() = 0;
    
    virtual bool isVisible() = 0;

};

#endif //__IRENDERABLE_H__