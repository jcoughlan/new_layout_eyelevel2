//\=====================================================================================
///
/// @author	Jamie Stewart
/// @brief	
///
//\=====================================================================================
#include "Maths.h"
#include <typeinfo>
#include <stdio.h>
#include <stdlib.h>
#include <OpenGLES//ES2//gl.h>
#include <OpenGLES//ES2//glext.h>
#include "Renderable.h"

#include "EAGLDefines.h"



static int renderMode = 0;

Renderable::Renderable()
{
	m_vertices = NULL;
	m_indices = NULL;
}

Renderable::~Renderable()
{
	m_TextureID = -1;
	if( m_vertices != NULL )
	{
		delete m_vertices;
		m_vertices = NULL;
	}
	
	if( m_indices != NULL )
	{
		delete m_indices;
		m_indices = NULL;
	}
}

void Renderable::initialise( VertexBuffer* vertices, IndexBuffer* indices)
{
	m_vertices	= vertices;
	m_indices	= indices;
}

GLuint Renderable::getTextureID()
{
	return m_TextureID;
}

 void Renderable::changeRenderMode()
{
    ++renderMode;
    if(renderMode > 2) renderMode = 0;
}

 int Renderable::getRenderMode()
{
    return renderMode;
}

void Renderable::draw( GLint* shaderParams ) 
{
	m_vertices->Bind();
	m_indices->Bind();
	// Update attribute values
	GLuint offset = 0;
	unsigned int stride = m_vertices->GetVertexDataSize();
	glEnableVertexAttribArray(GL_VERTEX_ARRAY);
    glVertexAttribPointer(GL_VERTEX_ARRAY, 3, GL_FLOAT, GL_FALSE, stride, (const void*)offset);
	
	switch ( m_vertices->GetVertexDataType() )
	{
		case V_3F_4UC:
		{
			glEnableVertexAttribArray(GL_COLOR_ARRAY);
			glVertexAttribPointer(GL_COLOR_ARRAY, 4, GL_UNSIGNED_BYTE, GL_TRUE, stride, (const void*)(offset + sizeof(Vector3)));
			break;
		}
		case V_3F_3F:
		{
			offset += sizeof(Vector3);
			glEnableVertexAttribArray(GL_NORMAL_ARRAY);
			glVertexAttribPointer(GL_NORMAL_ARRAY, 3, GL_FLOAT, GL_FALSE, stride, (const void*)offset);
			break;
		}
		case V_3F_2F:
		{
			offset += sizeof(Vector3);
			glEnableVertexAttribArray(GL_TEX_COORD_ARRAY);
			glVertexAttribPointer(GL_TEX_COORD_ARRAY, 2, GL_FLOAT, GL_FALSE, stride, (const void*)offset);
			break;
		}
		case V_3F_3F_2F:
		{
			offset += sizeof(Vector3);
			glEnableVertexAttribArray(GL_NORMAL_ARRAY);
			glVertexAttribPointer(GL_NORMAL_ARRAY, 3, GL_FLOAT, GL_FALSE, stride, (const void*)offset);
			offset += sizeof(Vector3);
			glEnableVertexAttribArray(GL_TEX_COORD_ARRAY);
			glVertexAttribPointer(GL_TEX_COORD_ARRAY, 2, GL_FLOAT, GL_FALSE, stride, (const void*)offset);
			break;
		}
		case V_3F_3F_4F:
		{
			offset += sizeof(Vector3);
			glEnableVertexAttribArray(GL_NORMAL_ARRAY);
			glVertexAttribPointer(GL_NORMAL_ARRAY, 3, GL_FLOAT, GL_FALSE, stride, (const void*)offset);
			offset += sizeof(Vector3);
			glEnableVertexAttribArray(GL_COLOR_ARRAY);
			glVertexAttribPointer(GL_COLOR_ARRAY, 4, GL_FLOAT, GL_TRUE, stride, (const void*)offset);
			break;
		}
		case V_3F_3F_4F_2F:
		{
			offset += sizeof(Vector3);
			glEnableVertexAttribArray(GL_NORMAL_ARRAY);
			glVertexAttribPointer(GL_NORMAL_ARRAY, 3, GL_FLOAT, GL_FALSE, stride, (const void*)offset);
			offset += sizeof(Vector3);
			glEnableVertexAttribArray(GL_COLOR_ARRAY);
			glVertexAttribPointer(GL_COLOR_ARRAY, 4, GL_FLOAT, GL_TRUE, stride, (const void*)offset);
			offset += sizeof(Vector4);
			glEnableVertexAttribArray(GL_TEX_COORD_ARRAY);
			glVertexAttribPointer(GL_TEX_COORD_ARRAY, 2, GL_FLOAT, GL_FALSE, stride, (const void*)offset);
			break;
		}
		default:
			break;
	}
	
    // Draw
	glDrawElements(GL_TRIANGLE_STRIP, m_indices->GetIndexSize(), m_indices->GetIndexType(), (void*)0);
	
	glDisableVertexAttribArray(GL_VERTEX_ARRAY);
	switch ( m_vertices->GetVertexDataType() )
	{
		case V_3F_4UC:
		{
			glDisableVertexAttribArray(GL_COLOR_ARRAY);
			break;
		}
		case V_3F_3F:
		{
			glDisableVertexAttribArray(GL_NORMAL_ARRAY);
			break;
		}
		case V_3F_2F:
		{
			glDisableVertexAttribArray(GL_TEX_COORD_ARRAY);
			break;
		}
		case V_3F_3F_2F:
		{
			glDisableVertexAttribArray(GL_NORMAL_ARRAY);
			glDisableVertexAttribArray(GL_TEX_COORD_ARRAY);
			break;
		}
		case V_3F_3F_4F:
		{
			glDisableVertexAttribArray(GL_NORMAL_ARRAY);
			glDisableVertexAttribArray(GL_COLOR_ARRAY);
			break;
		}
		case V_3F_3F_4F_2F:
		{
			glDisableVertexAttribArray(GL_NORMAL_ARRAY);
			glDisableVertexAttribArray(GL_COLOR_ARRAY);
			glDisableVertexAttribArray(GL_TEX_COORD_ARRAY);
			break;
		}
		default:
			break;
	}
	// Unbind the VBO and IBO
	m_vertices->UnBind();
	m_indices->UnBind();
} 

