//
//  GLCaplessSphere.h
//  BubblePix
//
//  Created by Jamie Stewart on 28/04/11.
//  Copyright 2011 Fluid Pixel. All rights reserved.
//

#include "Renderable.h"
#include "Maths.h"

//Somtimes the Standard Template Library is our Friend Other times we should re-write it's functionality for speed & memory purposes
//As this is not one of those times
#import <vector>

//\======================================================================================
//\Import CoreVideo so we can support Texture Conversion from a CVImageBufferRef
#import <CoreVideo/CoreVideo.h>
//\======================================================================================

class GLCaplessSphere : public Renderable 
{
public:
	GLCaplessSphere();
	GLCaplessSphere(int numRows, int numColumns, float radius, float longMin, float longMax, float latMin, float latMax);
	~GLCaplessSphere();
	
	void createTexture(CVImageBufferRef imageBufferRef);

	void draw( GLint* shaderParams );
	void getPosRot(Matrix4 &posRot);
	void setPosRot(Matrix4 &posRot);
private:
	//GLuint				m_TextureID;
	//\=============================================================================
	std::vector<Vertex_3f_3f_2f>	m_vertexPoints;
	std::vector<unsigned int>		m_indexes;
	//\=============================================================================
	Vector3				m_position;
	Matrix4			m_m4PosRot;
	
};


