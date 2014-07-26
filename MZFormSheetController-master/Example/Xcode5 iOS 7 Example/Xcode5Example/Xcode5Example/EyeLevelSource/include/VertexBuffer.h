//\=====================================================================================
/// 
/// @file	VertexBuffer.h
/// @author	Jamie Stewart
/// @date	9 Oct 2010
/// 
//\=====================================================================================

#ifndef __VERTEX_BUFFER_H__
#define __VERTEX_BUFFER_H__

#include "Maths.h"
#include <OpenGLES//ES2//gl.h>
#include <OpenGLES//ES2//glext.h>
#include "VertexSource.h"

enum VertexType
{
	V_3F_4UC,
	V_3F_3F,
	V_3F_2F,
	V_3F_3F_2F,
	V_3F_3F_4F,
	V_3F_3F_4F_2F
	
};

class VertexBuffer 
{
	
public:
	VertexBuffer(unsigned int vertexDataSize, unsigned int vertexCount, VertexType vertexType);
	~VertexBuffer();
	void	Fill( void* bufferData );
	void*	Lock();
	void	Unlock();
	void	Bind();
	void	UnBind();
	
	unsigned int GetVertexDataSize(){ return m_VertexSize;};
	unsigned int GetNumVertices()	{ return m_numVerticies;};
	VertexType	 GetVertexDataType()	{ return m_VertexType; };
private:
	// Vertex and index buffer objects
	GLuint			m_VBO;
	unsigned int	m_numVerticies;
	unsigned int	m_VertexSize;
	VertexType		m_VertexType;
};


#endif