//\=====================================================================================
/// 
/// @file	VertexBuffer.cpp
/// @author	Jamie Stewart
/// @date	9 Oct 2010
/// 
//\=====================================================================================
#include "VertexBuffer.h"

VertexBuffer::VertexBuffer(unsigned int vertexDataSize, unsigned int vertexCount, VertexType vertexType) 
{	
	m_numVerticies	= vertexCount;
	m_VertexSize	= vertexDataSize;
	m_VertexType	= vertexType;
	// Generate buffer objects
	glGenBuffers(1, &m_VBO);
}

VertexBuffer::~VertexBuffer() 
{	
	glDeleteBuffers( 1, &m_VBO );
}

void VertexBuffer::Fill( void* bufferData )
{
	// Bind the new VBO and allocate enough space for its storage
	glBindBuffer(GL_ARRAY_BUFFER, m_VBO);
	glBufferData(GL_ARRAY_BUFFER, m_numVerticies * m_VertexSize , bufferData, GL_STATIC_DRAW);
}

void* VertexBuffer::Lock()
{
	// Bind the new VBO and allocate enough space for its storage
	glBindBuffer(GL_ARRAY_BUFFER, m_VBO);
	glBufferData(GL_ARRAY_BUFFER, m_numVerticies * m_VertexSize , NULL, GL_STATIC_DRAW);
	// Map the vertex buffer
	GLvoid *vBuffer = glMapBufferOES(GL_ARRAY_BUFFER, GL_WRITE_ONLY_OES);
	return vBuffer;
}

void VertexBuffer::Unlock()
{
	// Unmap and unbind the vertex buffer
	glUnmapBufferOES(GL_ARRAY_BUFFER);
	glBindBuffer(GL_ARRAY_BUFFER, 0);
}

void VertexBuffer::Bind()
{
	glBindBuffer( GL_ARRAY_BUFFER, m_VBO );
}

void VertexBuffer::UnBind()
{
	glBindBuffer( GL_ARRAY_BUFFER, 0 );
}
