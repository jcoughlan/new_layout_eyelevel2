//
//  GLBillboard.m
//  BubblePix
//
//  Created by Jamie Stewart on 21/04/11.
//  Copyright 2011 Fluid Pixel. All rights reserved.
//

#import "GLBillboard.h"
#include "EAGLDefines.h"

GLBillboard::GLBillboard()
{
	m_fAspectRatio = 1.0;
	Init();
}

GLBillboard::GLBillboard(float fAspectRatio)
{
	m_fAspectRatio = fAspectRatio;
	Init();
}


void GLBillboard::Init()
{
	//\========================================================================================================
	//\ As this class extends Renderable.h we should set up our vertex and index buffer here
	//\========================================================================================================
	float fDistanceFromCamera = -1.f/ tanf( 21.f * DEG_2_RAD);
 
	m_m4PosRot = Matrix4::CreateTranslation( Vector3( 0.f, 0.f, fDistanceFromCamera) );

    m_TextureID = 0;
	
	m_VertexData[0].m_vPosition = Vector3( -1.f, -1.f * m_fAspectRatio, 0.0 );
	m_VertexData[1].m_vPosition = Vector3(  1.f, -1.f * m_fAspectRatio, 0.0 );
	m_VertexData[2].m_vPosition = Vector3( -1.f,  1.f * m_fAspectRatio, 0.0 );
	m_VertexData[3].m_vPosition = Vector3(  1.f,  1.f * m_fAspectRatio, 0.0 );
	
    //HACK
    //for now reorder texture coords so we render in landscape, really we should rotate the billboard!!!
	m_VertexData[2].m_TexCoords = Vector2( 0.0f, 0.0f );
	m_VertexData[0].m_TexCoords = Vector2( 0.0f, 1.0f );
	m_VertexData[3].m_TexCoords = Vector2( 1.0f, 0.0f );
	m_VertexData[1].m_TexCoords = Vector2( 1.0f, 1.0f );
	
	m_vertices = new VertexBuffer( sizeof(Vertex_3f_2f), 4 , V_3F_2F );
	m_vertices->Fill((void*)m_VertexData);
	
	ushort pIndices[4];
	pIndices[0] = 0;
	pIndices[1] = 1;
	pIndices[2] = 2;
	pIndices[3] = 3;
	
	m_indices = new IndexBuffer(  4, sizeof(ushort), GL_UNSIGNED_SHORT );
	m_indices->Fill( (void*)pIndices );
	//\========================================================================================================
}

GLBillboard::~GLBillboard()
{
}



void GLBillboard::createTexture(CVImageBufferRef imageBufferRef)
{
    //\========================================================================================================
	//\As We're going to be reading from this buffer it's best to lock it otherwise we get undefined behaiour
	//\========================================================================================================
	CVPixelBufferLockBaseAddress(imageBufferRef,0);
    
	//\========================================================================================================
	//\This next section is only if we were going to render out a texture larger than 2048x2048 as the iPad/iPhone4 
	//\has this texture size limitation for a single texture, iPhone3G/GS/iPod 1024.1024 limit. 
	//\Ignore this for now as it's only testing ::TODO:: code but this is where the image extraction would take 
	//\place if we aren't going to process the texture in a shader.
	//\========================================================================================================
	int bufferHeight = CVPixelBufferGetHeight(imageBufferRef);
	int bufferWidth = CVPixelBufferGetWidth(imageBufferRef);
    int bytesPerRow = CVPixelBufferGetBytesPerRow(imageBufferRef);
	
    int padding = bytesPerRow - (bufferWidth * 4);
    
    if(m_TextureID == 0)
	{
        int dataSize = bufferWidth * bufferHeight * 4;
        uint8_t* textureData = (uint8_t*)malloc(dataSize);
        if(textureData == NULL)
        {
            m_TextureID = 0;
        }
        else
        {
            memset(textureData, 128, dataSize);
            
            glGenTextures(1, &m_TextureID);
            glBindTexture(GL_TEXTURE_2D, m_TextureID);
            // glTexParameterf(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, GL_FALSE);
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, bufferWidth, bufferHeight, 0, GL_BGRA_EXT, 
                         GL_UNSIGNED_BYTE, textureData);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
            glBindTexture(GL_TEXTURE_2D, 0);
            free(textureData);
        }
	}
    
    
    //\========================================================================================================
	glBindTexture(GL_TEXTURE_2D, m_TextureID);
	
	unsigned char* linebase = (unsigned char *)CVPixelBufferGetBaseAddress( imageBufferRef );
	
    if( padding > 0 )
    {
        for( int h = 0; h < bufferHeight; h++ )
        {
            GLubyte *row = linebase + h * (bufferWidth * 4 + padding);
            glTexSubImage2D( GL_TEXTURE_2D, 0, 0, h, bufferWidth, 1, GL_BGRA, GL_UNSIGNED_BYTE, row );
        }
    } 
    else
    {
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, bufferWidth, bufferHeight, GL_BGRA_EXT, GL_UNSIGNED_BYTE, linebase);
    }
    
    CVPixelBufferUnlockBaseAddress( imageBufferRef, 0 );
}

void GLBillboard::draw( GLint* shaderParams  )
{
	//\========================================================================================================================
	//Bind VBO && IBO
	//\========================================================================================================================
	m_vertices->Bind();
	m_indices->Bind();
	// Update attribute values
	GLuint offset = 0;
	unsigned int stride = m_vertices->GetVertexDataSize();
	
	glEnableVertexAttribArray(GL_VERTEX_ARRAY);
    glVertexAttribPointer(GL_VERTEX_ARRAY, 3, GL_FLOAT, GL_FALSE, stride, (const void*)offset);
	
	offset += sizeof(Vector3);
	glEnableVertexAttribArray(GL_TEX_COORD_ARRAY);
	glVertexAttribPointer(GL_TEX_COORD_ARRAY, 2, GL_FLOAT, GL_FALSE, stride, (const void*)offset);
    
	glActiveTexture(GL_TEXTURE0);
	glUniform1i(shaderParams[SHAPE_TEXTURE], 0);
	glBindTexture(GL_TEXTURE_2D, m_TextureID);
    
	glDrawElements(GL_TRIANGLE_STRIP, m_indices->GetIndexSize(), m_indices->GetIndexType(), (void*)0);
    
	//\========================================================================================================================
	// unbind and disable VBO IBO 
	//\========================================================================================================================	
	glDisableVertexAttribArray(GL_VERTEX_ARRAY);
	glDisableVertexAttribArray(GL_TEX_COORD_ARRAY);
	// Unbind the VBO and IBO
	m_vertices->UnBind();
	m_indices->UnBind();
}

