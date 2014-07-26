/*
 *  Plane.cpp
 *  See-View
 *
 *  Created by Stuart Varrall on 03/11/2009.
 *  Copyright 2009 Fluid Pixel Ltd. All rights reserved.
 *
 */

#include "Maths.h"

Plane::Plane()
{
	m_PlaneVector.Set(0.f, 0.f, 0.f);
	m_PlaneD = 0.f;
}

Plane::~Plane()
{
}

void Plane::Set(float x, float y, float z, float d )
{
	m_PlaneVector.Set( x, y, z );
	m_PlaneD = d;
}

void Plane::SetPlaneVector( Vector3 vVec )
{
	m_PlaneVector = vVec;
}

void Plane::SetPlaneD	( float fD )
{
	m_PlaneD = fD;
}

Vector3 Plane::GetPlaneVector()
{
	return m_PlaneVector;
}

float Plane::GetPlaneD	()
{
	return m_PlaneD;
}

void Plane::SetCreationPoint( Vector3 vVec )
{
	m_CreationPoint = vVec;
}

int	Plane::PointPlaneTest( Vector3 vPoint )
{
	Vector3 vTest;
	vTest = vPoint * m_PlaneVector;
	float fResult = vTest.x + vTest.y + vTest.z + m_PlaneD;
	if( fResult > 0.0001f )
	{
		return 1;
	}
	else if( fResult < -0.0001f)
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

float Plane::fPointPlaneTest( Vector3 vPoint )
{
	Vector3 vTest;
	vTest = vPoint * m_PlaneVector;
	float fResult = vTest.x + vTest.y + vTest.z + m_PlaneD;
	return fResult;
}