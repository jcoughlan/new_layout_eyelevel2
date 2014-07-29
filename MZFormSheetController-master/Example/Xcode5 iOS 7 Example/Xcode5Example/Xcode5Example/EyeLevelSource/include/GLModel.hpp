//\=====================================================================================
/// 
/// @file	Model.h
/// @author	Jamie Stewart
/// @date	16 April 2011
/// 
//\=====================================================================================
#ifndef GLMODEL_H
#define GLMODEL_H

#include "Renderable.h"
#include "VertexSource.h"

#include "Matrix4.h"

#include <list>
#include <vector>

struct VertexData
{
    std::vector<Vertex_3f_3f_2f> vertexData;
    std::vector<ushort> indexData;
	Vector3 position;
    std::vector<Vector3> corners;
    std::vector<int> vertexLengths;
    
};

class GLModel : public Renderable
{
public:
    GLModel( VertexData vertexData, VertexData triangleVertexData, NSString* textureFilePath );
    GLModel( NSString* filename, NSString* textureMap, Matrix4 transform,  BOOL ignorePreviousHeights );
    ~GLModel();

    void				draw(  GLint* shaderParams );

    Vector3				getPosition();
    int                 getPositionX();
    int                 getPositionY();
    int                 getPositionZ();
    
    bool isVisible()    { return true; }
    
    Matrix4             getTransformation() { return m_ModelTransform; }
    
    IndexBuffer*			m_triangleMesh;
    VertexBuffer*			m_triangleVertices;
    std::vector<int>        m_vertexLengths;
   
public:
    static VertexData loadModelVertexData( NSString* objFilePath, BOOL triangle  );
    
private:
    void initialise( VertexData vertexData, VertexData vertexDataTriangle, NSString* textureFilePath, Matrix4 transform );
    
private:
    static Vector3                   ProcessVector3( NSString* line );
    static Vector2                   ProcessVector2( NSString* line );
    static std::vector<NSString*>    ProcessFaceList( NSString* line );
    static std::vector<NSString*>    ProcessFaceListTriangle( NSString* line, BOOL firstEdge );
	
public:

    Matrix4                         m_ModelTransform;
	Vector3							m_Position;
	unsigned int                    m_RenderMode;

    int numberOfCorners;
	Vector3                       m_cornerList[999];
   
};

#endif