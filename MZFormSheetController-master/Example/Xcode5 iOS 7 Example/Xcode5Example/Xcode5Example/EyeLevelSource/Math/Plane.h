/*
 *  Plane.h
 *  See-View
 *
 *  Created by Stuart Varrall on 03/11/2009.
 *  Copyright 2009 Fluid Pixel Ltd. All rights reserved.
 *
 */
#include "Vector3.h"

class Plane
{
public:
	Plane();
	~Plane();
	
	void		Set					(float x, float y, float z, float d );
	void		SetPlaneVector		( Vector3 vVec );
	void		SetPlaneD			( float fD );
	void		SetCreationPoint	( Vector3 vVec );
	Vector3		GetPlaneVector		();
	float		GetPlaneD			();
	Vector3		GetCreationPoint	() { return m_CreationPoint; };
	int			PointPlaneTest		( Vector3 vPoint );
	float		fPointPlaneTest		( Vector3 vPoint );
	
private:
	Vector3		m_PlaneVector;
	Vector3		m_CreationPoint;
	float		m_PlaneD;

};