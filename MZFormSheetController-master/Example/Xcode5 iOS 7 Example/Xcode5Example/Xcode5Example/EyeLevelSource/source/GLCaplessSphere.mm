//
//  GLCaplessSphere.m
//  BubblePix
//
//  Created by Jamie Stewart on 28/04/11.
//  Copyright 2011 Fluid Pixel. All rights reserved.
//

#import "GLCaplessSphere.h"


#include "EAGLDefines.h"

#define START_ANGLE (60.f * 0.01745329252f)
#define STOP_ANGLE (-60.f * 0.01745329252f)
#define ANGLE_INCREMENT (3.f * 0.01745329252f)



GLCaplessSphere::GLCaplessSphere()
{	
}

GLCaplessSphere::GLCaplessSphere(int numRows, int numColumns, float radius, float longMin, float longMax, float latMin, float latMax)
{
	
	//Set up the GLSphereSecments position and rotation
	//To move the sphere into or out of the screen so you can see it more easily change the 3rd parameter of m_position (it's z Value)
	//As this is OpenGL -z is "into" the screen +z moves things towards us, the 'camera/eye' is placed at origin in this sample
	m_position = Vector3( 0.f, 0.f, 0.f);
	
	m_m4PosRot = Matrix4::IDENTITY;
	m_m4PosRot.SetRow(3, m_position);
	//uncomment out the below line to rotate the spehere around the y Origin by PI
	m_m4PosRot.RotateY(M_PI);
	
	glGenTextures(1, &m_TextureID);
	
	float inverseRadius = 1/radius;
	//Invert these first as the multiply is slightly quicker
	float invColumns = 1.0f/float(numColumns);
	float invRows = 1.0f/float(numRows);
	
	//Lets put everything in radians first
	float latitiudinalRange = (latMax-latMin) * DEG_2_RAD;
	float longitudinalRange = (longMax-longMin) * DEG_2_RAD;
	// for each row of the mesh
	for (int row = 0; row <= numRows; ++row)
	{
		// y ordinates this may be a little confusing but here we are navigating around the xAxis in GL
		float ratioAroundXAxis = float(row) * invRows;
		float u_textureCoordinate = fabsf(1.0-ratioAroundXAxis);
		float radiansAboutXAxis  = ratioAroundXAxis * latitiudinalRange + (latMin * DEG_2_RAD);
		float y  =  radius * sin(radiansAboutXAxis);
		float z  =  radius * cos(radiansAboutXAxis);
		
		for ( int col = 0; col <= numColumns; ++col )
		{
			Vertex_3f_3f_2f vertexData;// = new Vertex_3f_3f_2f();
			
			float ratioAroundYAxis   = float(col) * invColumns;
			float v_textureCoordinate = fabsf(ratioAroundYAxis - 1.0);
			float theta = ratioAroundYAxis * longitudinalRange + (longMin * DEG_2_RAD);
			vertexData.m_vPosition.x  = -z * sinf(theta);
			vertexData.m_vPosition.y  =  y;
			vertexData.m_vPosition.z  =  -z * cosf(theta);
			
			vertexData.m_Normal.x =  inverseRadius * vertexData.m_vPosition.x;
			vertexData.m_Normal.y =  inverseRadius * vertexData.m_vPosition.y;
			vertexData.m_Normal.z =  inverseRadius * vertexData.m_vPosition.z;
			
			vertexData.m_TexCoords.u = u_textureCoordinate;
			vertexData.m_TexCoords.v = v_textureCoordinate;
			// increment vertex index
			m_vertexPoints.push_back(vertexData);
		}
	}
	//now all the verticies have been read into memory stick them in the vertex buffer
	NSLog(@"Number of Vertexs : %lu", m_vertexPoints.size() );
	m_vertices = new VertexBuffer( sizeof(Vertex_3f_3f_2f), m_vertexPoints.size() , V_3F_3F_2F );
	m_vertices->Fill((void*)&m_vertexPoints[0]);
	
	//Now to set up the index buffer
	int numIndexes = 6*numRows*numColumns;
	ushort* pIndices = (ushort*)malloc(numIndexes * sizeof(ushort));
	ushort face = 0;
	for (int i = 0; i < numIndexes; i += 6)
	{
		pIndices[i]	  = face;
		pIndices[i+1] = face + 1;
		pIndices[i+2] = face + numColumns + 1;
		
		pIndices[i+3] = face + 1;
		pIndices[i+4] = face + numColumns + 2;
		pIndices[i+5] = face + numColumns + 1;
		
		face++;
		if( face == numColumns )
		{
			face++;
		}
	}
									 
	//As we're using gltriangles to render this out it should be 6*numRows*numColumns
	m_indices = new IndexBuffer(  numIndexes, sizeof(ushort), GL_UNSIGNED_SHORT );
	m_indices->Fill( (void*)pIndices );
	free(pIndices);
	
}

GLCaplessSphere::~GLCaplessSphere()
{
	m_vertexPoints.empty();
	m_vertexPoints.clear();
	m_indexes.empty();
	m_indexes.clear();
}


void GLCaplessSphere::createTexture(CVImageBufferRef imageBufferRef)
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
	
	//\========================================================================================================
    //\Clear out the existing texture memory - or we will have a very short lived app
	glDeleteTextures( 1, &m_TextureID );
    //\========================================================================================================
	glBindTexture(GL_TEXTURE_2D, m_TextureID);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	//\========================================================================================================
	//\ This is necessary for non-power-of-two textures - only supported on 3G and up
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	//\========================================================================================================
	//\The Following Hash Def should be defined but in some cases it's not so put this in, either way the hardware
	//\switch is recognised so this is deemed to be the safe way of defining GL_BGRA - ask PowerVR the maker of the GPU
	//\========================================================================================================
#ifndef GL_BGRA
#define GL_BGRA 0x80E1
#endif
	//\========================================================================================================
	//\Relates to above sampled image size not in current use
	//\========================================================================================================
    //\Stupidly not many people have seemed to realise that CVPixelBufferGetBaseAddress(imageBufferRef) is a pixel buffer that can be recognised by 
    //\OpenGL without any tweaking it is read in from the camera as a BRGA texture so this saves a lot of time converting from one format to another
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, bufferWidth, bufferHeight, 0, GL_BGRA, GL_UNSIGNED_BYTE, CVPixelBufferGetBaseAddress(imageBufferRef));
	
	//\========================================================================================================
	//\Unlock the buffer as we're done with out operations on it -- until the next pass that is
	//\========================================================================================================
	CVPixelBufferUnlockBaseAddress(imageBufferRef,0);
}

void GLCaplessSphere::draw( GLint* shaderParams )
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

void GLCaplessSphere::getPosRot(Matrix4 &posRot)
{
	posRot = m_m4PosRot;
}

void GLCaplessSphere::setPosRot(Matrix4 &posRot)
{
	m_m4PosRot = posRot;
}
