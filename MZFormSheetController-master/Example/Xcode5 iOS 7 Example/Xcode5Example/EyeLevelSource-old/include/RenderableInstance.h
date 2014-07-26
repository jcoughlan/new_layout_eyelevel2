//\=====================================================================================
///
/// @author	Ryan Sullivan
/// @brief	An instance of a renderable, using this allows renderables to be instanced (loaded once). and shared amongst many 
/// renderableInstances
///
//\=====================================================================================

#include "IRenderable.h"
#include "Matrix4.h"


#ifndef RENDERABLEINSTANCE_H
#define RENDERABLEINSTANCE_H


class RenderableInstance : public IRenderable
{
public: 
    
    /***
     *  IRenderable Implementation
     ***/
    void draw( int* shaderParams );
    
public:
    
	RenderableInstance( IRenderable* renderable, Matrix4 transform );
	~RenderableInstance();
    
    
    /**
     * Mutators
     **/
    void setVisible( bool visible ) { m_IsVisible = visible; }
    bool isVisible() { return m_IsVisible; }
    
    void setTransformation( const Matrix4& mat ) { m_InstanceTransform = mat; }
    Matrix4 getTransformation() { return m_InstanceTransform; } //need to combine this transform with the real models transform(!?)
    
    
private:
    
    /***
     * Data Members
     ***/
    IRenderable*    m_InstanceRenderable;
    Matrix4         m_InstanceTransform;
	bool            m_IsVisible;
    
};

#endif