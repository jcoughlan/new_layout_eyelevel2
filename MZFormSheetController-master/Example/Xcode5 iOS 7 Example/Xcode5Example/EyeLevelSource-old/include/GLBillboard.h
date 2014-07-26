//
//  GLBillboard.h
//  BubblePix
//
//  Created by Jamie Stewart on 21/04/11.
//  Copyright 2011 Fluid Pixel. All rights reserved.
//

#include "Maths.h"
#include "Renderable.h"
#include "VertexSource.h"


//\======================================================================================
//\Import CoreVideo so we can support Texture Conversion from a CVImageBufferRef
#import <CoreVideo/CoreVideo.h>
//\======================================================================================
class GLBillboard : public Renderable 
{
public:
	GLBillboard();
	GLBillboard(float fAspectRatio);
	~GLBillboard();
	
	void createTexture(CVImageBufferRef imageBufferRef);
	void draw( GLint* shaderParams );

    Matrix4 getTransformation() { return m_m4PosRot; }
    void setTransformation( const Matrix4& mat ) { m_m4PosRot = mat; }
    
    bool isVisible() { return true; }
private:
	void Init();
	
    enum { VERTICES = 4 };
    
	//GLuint				m_TextureID;

	Matrix4             m_m4PosRot;
	Vertex_3f_2f		m_VertexData[VERTICES];
	float				m_fAspectRatio;
	
};