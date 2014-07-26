//
//  GLBillboard.m
//  BubblePix
//
//  Created by Jamie Stewart on 21/04/11.
//  Copyright 2011 Fluid Pixel. All rights reserved.
//

#import "GLCube.h"

#include <OpenGLES//ES2//gl.h>
#include <OpenGLES//ES2//glext.h>

#include "EAGLDefines.h"

GLCube::GLCube(Matrix4 modelMatrix, float breadth, float width, float height,  NSString* textureName)
{
    m_ModelMatrix = modelMatrix;
    
    glGenTextures(1, &m_TextureID);
    
    glBindTexture(GL_TEXTURE_2D, m_TextureID);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	//\========================================================================================================
	//\ This is necessary for non-power-of-two textures - only supported on 3G and up
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    
#ifndef GL_BGRA
#define GL_BGRA 0x80E1
#endif
    
    UIImage* image = [UIImage imageNamed:textureName];
    CGImageRef textureImage = image.CGImage;
    
    if (image == nil) {
        NSLog(@"Failed to load texture image");
        //  return;
    }
    
    NSInteger texWidth = CGImageGetWidth(textureImage);
    NSInteger texHeight = CGImageGetHeight(textureImage);
    
    GLubyte *textureData = (GLubyte *)malloc(texWidth * texHeight * 4);
    
    CGContextRef textureContext = CGBitmapContextCreate(textureData, texWidth, texHeight, 8, texWidth * 4, CGImageGetColorSpace(textureImage), kCGImageAlphaPremultipliedLast);
    CGContextTranslateCTM (textureContext, 0, texHeight);
    CGContextScaleCTM (textureContext, 1.0, -1.0);
    CGContextSetBlendMode(textureContext, kCGBlendModeCopy);
    
    CGContextDrawImage(textureContext, CGRectMake(0.0, 0.0, (float)texWidth, (float)texHeight), textureImage);
    
    CGContextRelease(textureContext);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, texWidth, texHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, textureData);
    
    free(textureData);
    
    float hBreadth = breadth/2;
    float hWidth = width/2;
    float hHeight = height/2;

    //front face
	m_VertexData[0].m_vPosition = Vector3( -hWidth, -hHeight, hBreadth );
	m_VertexData[1].m_vPosition = Vector3(  hWidth, -hHeight, hBreadth );
	m_VertexData[2].m_vPosition = Vector3( hWidth,  hHeight,  hBreadth );
	m_VertexData[3].m_vPosition = Vector3(  -hWidth,  hHeight, hBreadth );
    
    //back face.
    m_VertexData[4].m_vPosition = Vector3( -hWidth, -hHeight, -hBreadth );
	m_VertexData[5].m_vPosition = Vector3( -hWidth,  hHeight, -hBreadth );
	m_VertexData[6].m_vPosition = Vector3( hWidth,  hHeight, -hBreadth );
	m_VertexData[7].m_vPosition = Vector3( hWidth, -hHeight, -hBreadth );
    
    //top face
	m_VertexData[8].m_vPosition = Vector3(  -hWidth,  hHeight,  hBreadth );
	m_VertexData[9].m_vPosition = Vector3(  hWidth,  hHeight,  hBreadth );
	m_VertexData[10].m_vPosition = Vector3(  hWidth,  hHeight, -hBreadth );
    m_VertexData[11].m_vPosition = Vector3( -hWidth,  hHeight, -hBreadth);
    
    //bottom face
    m_VertexData[12].m_vPosition = Vector3( -hWidth, -hHeight, -hBreadth );
	m_VertexData[13].m_vPosition = Vector3( hWidth, -hHeight, -hBreadth );
	m_VertexData[14].m_vPosition = Vector3( hWidth, -hHeight, hBreadth );
	m_VertexData[15].m_vPosition = Vector3( -hWidth, -hHeight, hBreadth );
    
    //right face
    m_VertexData[16].m_vPosition = Vector3(  hWidth, -hHeight,  hBreadth );
    m_VertexData[17].m_vPosition = Vector3(  hWidth, -hHeight, -hBreadth );
	m_VertexData[18].m_vPosition = Vector3(  hWidth,  hHeight, -hBreadth );
	m_VertexData[19].m_vPosition = Vector3(  hWidth,  hHeight,  hBreadth );
    
    //left face
    m_VertexData[20].m_vPosition = Vector3( -hWidth, -hHeight, -hBreadth );
	m_VertexData[21].m_vPosition = Vector3( -hWidth, -hHeight,  hBreadth );
	m_VertexData[22].m_vPosition = Vector3( -hWidth,  hHeight,  hBreadth );
	m_VertexData[23].m_vPosition = Vector3( -hWidth,  hHeight, -hBreadth );
    
    
    //normals for shader attempt
    //front face
    m_VertexData[0].m_Normal = Vector3( 0, 0, 1 );
	m_VertexData[1].m_Normal = Vector3( 0, 0, 1 );
	m_VertexData[2].m_Normal = Vector3( 0, 0, 1 );
	m_VertexData[3].m_Normal = Vector3( 0, 0, 1 );
    
    //back face
    m_VertexData[4].m_Normal = Vector3( 0, 0, -1 );
	m_VertexData[5].m_Normal = Vector3( 0, 0, -1 );
	m_VertexData[6].m_Normal = Vector3( 0, 0, -1 );
	m_VertexData[7].m_Normal = Vector3( 0, 0, -1 );
    
    //top face
    m_VertexData[8].m_Normal = Vector3( 0, 1, 0 );
	m_VertexData[9].m_Normal = Vector3( 0, 1, 0 );
	m_VertexData[10].m_Normal = Vector3( 0, 1, 0 );
	m_VertexData[11].m_Normal = Vector3( 0, 1, 0 );
    
    //bottom face
    m_VertexData[12].m_Normal = Vector3( 0, -1, 0 );
	m_VertexData[13].m_Normal = Vector3( 0, -1, 0 );
	m_VertexData[14].m_Normal = Vector3( 0, -1, 0 );
	m_VertexData[15].m_Normal = Vector3( 0, -1, 0 );
    
    //right face
    m_VertexData[16].m_Normal = Vector3( 1, 0, 0 );
	m_VertexData[17].m_Normal = Vector3( 1, 0, 0 );
	m_VertexData[18].m_Normal = Vector3( 1, 0, 0 );
	m_VertexData[19].m_Normal = Vector3( 1, 0, 0 );
    
    //left face
    m_VertexData[20].m_Normal = Vector3( -1, 0, 0 );
	m_VertexData[21].m_Normal = Vector3( -1, 0, 0 );
	m_VertexData[22].m_Normal = Vector3( -1, 0, 0 );
	m_VertexData[23].m_Normal = Vector3( -1, 0, 0 );
    
    
    //texture coords
    //front face
    m_VertexData[0].m_TexCoords = Vector2( 0.0f, 0.0f );
	m_VertexData[1].m_TexCoords = Vector2( 1.0f, 0.0f );
	m_VertexData[2].m_TexCoords = Vector2( 1.0f, 1.0f );
	m_VertexData[3].m_TexCoords = Vector2( 0.0f, 1.0f );
    
    //back face
    m_VertexData[7].m_TexCoords = Vector2( 0.0f, 0.0f );
	m_VertexData[4].m_TexCoords = Vector2( 1.0f, 0.0f );
	m_VertexData[5].m_TexCoords = Vector2( 1.0f, 1.0f );
	m_VertexData[6].m_TexCoords = Vector2( 0.0f, 1.0f );
    
    m_VertexData[8].m_TexCoords = Vector2( 0.0f, 0.0f );
	m_VertexData[9].m_TexCoords = Vector2( 1.0f, 0.0f );
	m_VertexData[10].m_TexCoords = Vector2( 1.0f, 1.0f );
	m_VertexData[11].m_TexCoords = Vector2( 0.0f, 1.0f );
    
    m_VertexData[12].m_TexCoords = Vector2( 0.0f, 0.0f );
	m_VertexData[13].m_TexCoords = Vector2( 1.0f, 0.0f );
	m_VertexData[14].m_TexCoords = Vector2( 1.0f, 1.0f );
	m_VertexData[15].m_TexCoords = Vector2( 0.0f, 1.0f );
    
    m_VertexData[16].m_TexCoords = Vector2( 0.0f, 0.0f );
	m_VertexData[17].m_TexCoords = Vector2( 1.0f, 0.0f );
	m_VertexData[18].m_TexCoords = Vector2( 1.0f, 1.0f );
	m_VertexData[19].m_TexCoords = Vector2( 0.0f, 1.0f );
    
    m_VertexData[20].m_TexCoords = Vector2( 0.0f, 0.0f );
	m_VertexData[21].m_TexCoords = Vector2( 1.0f, 0.0f );
	m_VertexData[22].m_TexCoords = Vector2( 1.0f, 1.0f );
	m_VertexData[23].m_TexCoords = Vector2( 0.0f, 1.0f );
    
    
    
	
	m_vertices = new VertexBuffer( sizeof(Vertex_3f_3f_2f), VERTICES , V_3F_3F_2F );
	m_vertices->Fill((void*)&m_VertexData[0]);
	
	ushort pIndices[36];
    
    //fix winding order
	pIndices[0] = 0;
	pIndices[1] = 1;
	pIndices[2] = 2;
	pIndices[3] = 0;
    pIndices[4] = 2;
	pIndices[5] = 3;
    
	pIndices[6] = 4;
	pIndices[7] = 5;
    pIndices[8] = 6;
	pIndices[9] = 4;
	pIndices[10] = 6;
	pIndices[11] = 7;
    
    pIndices[12] = 8;
	pIndices[13] = 9;
	pIndices[14] = 10;
	pIndices[15] = 8;
    pIndices[16] = 10;
	pIndices[17] = 11;
    
	pIndices[18] = 12;
	pIndices[19] = 13;
    pIndices[20] = 14;
	pIndices[21] = 12;
	pIndices[22] = 14;
	pIndices[23] = 15;
    
    pIndices[24] = 16;
	pIndices[25] = 17;
	pIndices[26] = 18;
	pIndices[27] = 16;
    pIndices[28] = 18;
	pIndices[29] = 19;
    
	pIndices[30] = 20;
	pIndices[31] = 21;
    pIndices[32] = 22;
	pIndices[33] = 20;
	pIndices[34] = 22;
	pIndices[35] = 23;
    
	
	m_indices = new IndexBuffer(  36, sizeof(ushort), GL_UNSIGNED_SHORT );
	m_indices->Fill( (void*)pIndices );
	//\========================================================================================================
}



GLCube::~GLCube()
{
}


void GLCube::setTransformation( Matrix4 matrix )
{
    m_ModelMatrix = matrix;
}




void GLCube::draw( GLint* shaderParams )
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
    glEnableVertexAttribArray(GL_NORMAL_ARRAY);
    glVertexAttribPointer(GL_NORMAL_ARRAY, 3, GL_FLOAT, GL_FALSE, stride, (const void*)offset);
    
    offset += sizeof(Vector3);
    glEnableVertexAttribArray(GL_TEX_COORD_ARRAY);
    glVertexAttribPointer(GL_TEX_COORD_ARRAY, 2, GL_FLOAT, GL_FALSE, stride, (const void*)offset);
    
	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, m_TextureID);
	glUniform1i(shaderParams[SHAPE_TEXTURE], 0);
    
    
	glDrawElements(GL_TRIANGLES, m_indices->GetIndexSize(), m_indices->GetIndexType(), (void*)0);
    
    
	//\========================================================================================================================
	// unbind and disable VBO IBO 
	//\========================================================================================================================	
	glDisableVertexAttribArray(GL_VERTEX_ARRAY);
    glDisableVertexAttribArray(GL_NORMAL_ARRAY);
    glDisableVertexAttribArray(GL_TEX_COORD_ARRAY);

	// Unbind the VBO and IBO
	m_vertices->UnBind();
	m_indices->UnBind();
}

