//
//  EAGLDefines.h
//  EyeLevel
//
//  Created by stuart on 08/08/2011.
//  Copyright 2011 Fluid Pixel. All rights reserved.
//

#include <OpenGLES//ES2//gl.h>

enum
{
    GL_VERTEX_ARRAY,
	GL_NORMAL_ARRAY,
	GL_COLOR_ARRAY,
	GL_TEX_COORD_ARRAY,
    NUM_ATTRIBUTES
};


enum eShaderParams
{
    MODEL_MATRIX,
    PROJECTION_MATRIX,
    VIEW_MATRIX,
    TRANSPARENCY,
	SHAPE_TEXTURE,
	SHAPE_COLOR,
	SCALE,
	NUM_UNIFORMS
};

enum eRenderModes 
{
    eRenderModes_Normal = GL_TRIANGLES,
    eRenderModes_Lines = GL_LINES,
};