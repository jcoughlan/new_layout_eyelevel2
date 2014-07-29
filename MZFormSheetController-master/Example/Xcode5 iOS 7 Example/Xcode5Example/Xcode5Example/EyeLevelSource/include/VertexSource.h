/*
 *  VertexSource.h
 *  Fluid_Pixel
 *
 *  Created by Jamie Stewart on 23/06/10.
 *  Copyright 2010 Fluid Pixel. All rights reserved.
 *
 */

#ifndef __VERTEX_SOURCE_H__
#define __VERTEX_SOURCE_H__
#ifdef __cplusplus
#include "Vector4.h"
#include "Vector3.h"
#include "Vector2.h"

class Vertex_3f_4uc
{
public:
	Vector3 m_vPosition;
	unsigned char m_Color[4];
};


class Vertex_3f_3f
{
public:
	Vector3 m_vPosition;
	Vector3 m_Normal;
};

class Vertex_3f_2f
{
public:
	Vector3 m_vPosition;
	Vector2 m_TexCoords;
};

class Vertex_3f_3f_2f
{
public:
    Vertex_3f_3f_2f(){}
    Vertex_3f_3f_2f( Vector3 pos, Vector3 normal, Vector2 uv ) : m_vPosition( pos ), m_Normal( normal ), m_TexCoords( uv ) {}
    
    bool operator == ( Vertex_3f_3f_2f rhs ) { return m_vPosition == rhs.m_vPosition && m_Normal == rhs.m_Normal && m_TexCoords == rhs.m_TexCoords; }
    
	Vector3 m_vPosition;
	Vector3 m_Normal;
	Vector2 m_TexCoords;
};

class Vertex_3f_2f_2f
{
public:
	Vector3 m_vPosition;
	Vector2 m_TexCoords;
	Vector2 m_TexCoords2;
};

class Vertex_3f_3f_4f
{
public:
	Vector3 m_vPosition;
	Vector3 m_Normal;
	Vector4 m_Color;	
};

class Vertex_3f_3f_4f_2f
{
public:
	Vector3 m_vPosition;
	Vector3 m_Normal;
	Vector4 m_Color;
	Vector2 m_TexCoords;	
};
#endif
#endif