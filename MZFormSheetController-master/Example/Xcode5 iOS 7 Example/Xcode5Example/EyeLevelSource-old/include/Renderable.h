//\=====================================================================================
///
/// @author	Jamie Stewart
/// @brief	
///
//\=====================================================================================

#include "IRenderable.h"
#include "VertexBuffer.h"
#include "IndexBuffer.h"

#ifndef __RENDERABLE_H__
#define __RENDERABLE_H__



class Renderable : public IRenderable
{
public:
	Renderable();
	~Renderable();
    void		initialise		( VertexBuffer* vertices, IndexBuffer* indices);
	void		draw			( GLint* shaderParams );
    static void changeRenderMode();
    static int getRenderMode();
    
	GLuint      getTextureID    ();
    virtual     Matrix4 getTransformation() = 0;

	VertexBuffer*			m_vertices;
	IndexBuffer*			m_indices;
	GLuint					m_TextureID;

    
};


#endif