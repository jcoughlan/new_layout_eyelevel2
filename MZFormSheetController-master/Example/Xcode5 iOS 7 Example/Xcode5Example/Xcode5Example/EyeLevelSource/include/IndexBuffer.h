//\=====================================================================================
/// 
/// @file	VertexBuffer.h
/// @author	Jamie Stewart
/// @date	9 Oct 2010
/// 
//\=====================================================================================
#ifndef __INDEX_BUFFER_H__
#define __INDEX_BUFFER_H__

#include "Maths.h"
#include <OpenGLES//ES2//gl.h>
#include <OpenGLES//ES2//glext.h>
#include "VertexSource.h"

class IndexBuffer 
{
	
public:
	IndexBuffer( unsigned int indexCount, unsigned int indexSize, unsigned int indexType );
	~IndexBuffer();
	void	Fill( void* indexData );
	void*	Lock();
	void	Unlock();
	void	Bind();
	void	UnBind();
	
	unsigned int GetIndexType(){ return m_IndexType; };
	unsigned int GetIndexSize(){ return m_numIndexes; };
private:
	void*			m_IndexSource;
	// Vertex and index buffer objects
	GLuint			m_IBO;
	unsigned int	m_numIndexes;
	unsigned int	m_IndexSize;
	unsigned int	m_IndexType;
	
};

#endif