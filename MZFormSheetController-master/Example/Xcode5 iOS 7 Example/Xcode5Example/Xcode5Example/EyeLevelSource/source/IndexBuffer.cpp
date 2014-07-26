//\=====================================================================================
/// 
/// @file	VertexBuffer.cpp
/// @author	Jamie Stewart
/// @date	9 Oct 2010
/// 
//\=====================================================================================
#include "IndexBuffer.h"

IndexBuffer::IndexBuffer( unsigned int indexCount, unsigned int indexSize, unsigned int indexType ) 
{	
	m_numIndexes	= indexCount;
	m_IndexSize		= indexSize;
	m_IndexType		= indexType;
	glGenBuffers(1, &m_IBO);
}

IndexBuffer::~IndexBuffer() 
{	
	glDeleteBuffers( 1, &m_IBO );
}

void IndexBuffer::Fill( void* indexData )
{
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_IBO);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, m_numIndexes * m_IndexSize, indexData, GL_STATIC_DRAW);
}

void* IndexBuffer::Lock()
{
	// Bind the new IBO and allocate enough space for its storage
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_IBO);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, m_numIndexes * m_IndexSize, NULL, GL_STATIC_DRAW);
	// Map the index buffer
	GLvoid *iBuffer = glMapBufferOES(GL_ELEMENT_ARRAY_BUFFER, GL_WRITE_ONLY_OES);
	return iBuffer;
}

void IndexBuffer::Unlock()
{
	// Unmap and unbind the vertex buffer
	
	glUnmapBufferOES(GL_ELEMENT_ARRAY_BUFFER);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
}

void IndexBuffer::Bind()
{
	glBindBuffer( GL_ELEMENT_ARRAY_BUFFER, m_IBO );
}

void IndexBuffer::UnBind()
{
	glBindBuffer( GL_ELEMENT_ARRAY_BUFFER, 0 );
}
