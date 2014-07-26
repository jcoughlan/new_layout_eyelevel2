//
//  GLBillboard.h
//  BubblePix
//
//  Created by Jamie Stewart on 21/04/11.
//  Copyright 2011 Fluid Pixel. All rights reserved.
//

#include "Maths.h"
#include "Renderable.h"
//\======================================================================================
//\The Includes needed to support all versions of OpenGLES 
//\(This app should only support OpenGLES 2.0 for shader use in the future)


class GLCube : public IRenderable 
{
public:
	GLCube(Matrix4 modelMatrix, float breadth, float width, float height,  NSString* textureName);
	~GLCube();
	
	void draw( GLint* shaderParams  );
    
    void setTransformation( Matrix4 matrix );
    Matrix4 getTransformation( ) { return m_ModelMatrix; }
    
    bool isVisible() { return true; }

    
private:
	
    enum { VERTICES = 4 * 6 };
    
	Matrix4			m_ModelMatrix;
    
	Vertex_3f_3f_2f		m_VertexData[VERTICES];
    
    VertexBuffer*			m_vertices;
	IndexBuffer*			m_indices;
    
    GLuint   m_TextureID;
	
};

