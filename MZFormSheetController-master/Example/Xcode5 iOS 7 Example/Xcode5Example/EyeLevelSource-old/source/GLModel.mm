//\=====================================================================================
/// 
/// @file	Model.cpp
/// @author	Jamie Stewart
/// @date	16 April 2011
/// 
//\=====================================================================================
#include "GLModel.h"
#include <stdio.h>

#include <OpenGLES//ES2//gl.h>
#include <OpenGLES//ES2//glext.h>
#include <mach/mach_time.h>

#include "EAGLDefines.h"
#include "Profiler.h"

#define FILLEDWIREFRAME 2
#define WIREFRAME 1
#define SOLID 0

static float lowestY = -999;

NSString *readLineAsNSString(FILE *file)
{
    char buffer[4096];
    
    // tune this capacity to your liking -- larger buffer sizes will be faster, but
    // use more memory
    NSMutableString *result = [NSMutableString stringWithCapacity:256];
    
    // Read up to 4095 non-newline characters, then read and discard the newline
    int charsRead;
    do
    {
        if(fscanf(file, "%4095[^\n]%n%*c", buffer, &charsRead) == 1)
            [result appendFormat:@"%s", buffer];
        else
            break;
    } while(charsRead == 4095);
    
    return result;
}


    


GLModel::GLModel( VertexData vertexData, VertexData triangleVertexData, NSString* textureFilePath )
{
    initialise( vertexData, triangleVertexData, textureFilePath, Matrix4::IDENTITY);
}

void GLModel::initialise( VertexData vertexData, VertexData vertexDataTriangle, NSString* textureFilePath, Matrix4 transform )
{
    m_ModelTransform = transform;
    m_Position = Vector3(vertexData.position.x, vertexData.position.y, vertexData.position.z);
    m_vertexLengths = vertexData.vertexLengths;
    NSLog(@"position here is %f", m_Position.x);
    int iterCount = 0;
    for( std::vector<Vector3>::const_iterator iter = vertexData.corners.begin(); iter != vertexData.corners.end(); ++ iter ) 
    {
        NSLog(@"loading vertex %i", iterCount);
        m_cornerList[iterCount] = vertexData.corners[iterCount];
        ++ iterCount;
    }
    numberOfCorners = iterCount;
    
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
    
    
    UIImage* image = [UIImage imageNamed:textureFilePath];
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
    
    m_vertices = new VertexBuffer( sizeof(Vertex_3f_3f_2f), vertexData.vertexData.size() , V_3F_3F_2F );
	m_vertices->Fill((void*)&vertexData.vertexData[0]);
    
    
    m_indices = new IndexBuffer(  vertexData.indexData.size(), sizeof(ushort), GL_UNSIGNED_SHORT );
	m_indices->Fill( (void*)&vertexData.indexData[0] );
    
    m_triangleVertices =  new VertexBuffer( sizeof(Vertex_3f_3f_2f), vertexDataTriangle.vertexData.size() , V_3F_3F_2F );
    m_triangleVertices->Fill((void*)&vertexDataTriangle.vertexData[0]);
    
    m_triangleMesh = new IndexBuffer(  vertexDataTriangle.indexData.size(), sizeof(ushort), GL_UNSIGNED_SHORT );
	m_triangleMesh->Fill( (void*)&vertexDataTriangle.indexData[0] );
    
     NSLog(@"position here afetrwrds is %f", m_Position.x);
}

GLModel::GLModel( NSString* filename, NSString* textureMap, Matrix4 transform,  BOOL ignorePreviousHeights ) 
{    
    if(ignorePreviousHeights == YES) lowestY = -999;
    NSLog(@"constructor for model %@", filename);
    initialise(  GLModel::loadModelVertexData(filename, false), GLModel::loadModelVertexData(filename, true), textureMap, transform );
}

VertexData GLModel::loadModelVertexData( NSString* objFilePath, BOOL triangle )
{
    if(triangle == NO)
    {
        NSLog(@"quad geometry");
    } 
	else
	{
		NSLog(@"triangle");
	}

    
    NSString *contents = [NSString stringWithContentsOfFile:objFilePath encoding:NSUTF8StringEncoding error:nil];
    
    std::vector<Vector3>			vertices;
    std::vector<Vector3>			normals;
    std::vector<Vector2>			uvs;
    std::vector<NSString*>          faces;
    std::vector<int>               vertexLength;

	Vector3 minVertex = Vector3( INT_MAX, INT_MAX, INT_MAX );
	Vector3 maxVertex = Vector3( INT_MIN, INT_MIN, INT_MIN );

    int debugcounter = 0;

    NSArray *array = [contents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];

    
    for( NSString* line in array )
    {
        if( [line hasPrefix:@"v "] )
        {
            Vector3 vertexVector = ProcessVector3( [line substringFromIndex:2]);
     
            vertices.push_back( vertexVector );
            
			if( vertexVector.y < minVertex.y )
			{
				minVertex.y = vertexVector.y;
			}
			if( vertexVector.y > maxVertex.y )
			{
				maxVertex.y = vertexVector.y;
			}
			if( vertexVector.x < minVertex.x )
			{
				minVertex.x = vertexVector.x;
			}
			if( vertexVector.x > maxVertex.x )
			{
				maxVertex.x = vertexVector.x;
			}
			if( vertexVector.z < minVertex.z )
			{
				minVertex.z = vertexVector.z;
			}
			if( vertexVector.z > maxVertex.z )
			{
				maxVertex.z = vertexVector.z;
			}
        }
        else if ( [line hasPrefix:@"vt"] )
        {
            uvs.push_back( ProcessVector2( line ) );
        }
        else if( [line hasPrefix:@"vn"] )
        {
            normals.push_back( ProcessVector3( line ) );
        }
        else if( [line hasPrefix:@"f "] )
        {
            if(triangle == NO)
            {
                NSArray* lineComponents = [line componentsSeparatedByString:@" "];
                int verticiesNumber = [lineComponents count] - 2;
                if(verticiesNumber == 4)
                {
                std::vector<NSString*> tempFaces = ProcessFaceList(line);
               
                faces.insert( faces.end(), tempFaces.begin(), tempFaces.end() );
               
                vertexLength.push_back(verticiesNumber);
                NSLog(@"verticies %i", verticiesNumber);
                }
            }
            else
            {
                NSArray* lineComponents = [line componentsSeparatedByString:@" "];
                int verticiesNumber = [lineComponents count];
                //NSLog(@"number of verts:%i", verticiesNumber);
                std::vector<NSString*> tempFaces = ProcessFaceListTriangle(line, YES);
                faces.insert( faces.end(), tempFaces.begin(), tempFaces.end() );
                std::vector<NSString*> tempFaces2 = ProcessFaceListTriangle(line, NO);
                if(verticiesNumber >=6) faces.insert( faces.end(), tempFaces2.begin(), tempFaces2.end() );
               // debugcounter+=6;
                
            }
        }
    }

	Vector3 averagePosition = (minVertex + maxVertex) / 2.f;
    
    if(lowestY == -999) lowestY = minVertex.y;
    
    debugcounter = 0;
        int vertexNumber = 0;
        for( std::vector<Vector3>::const_iterator iter = vertices.begin(); iter != vertices.end(); ++ iter ) 
        {
            vertices[vertexNumber].y -= lowestY;
            ++vertexNumber;
        }

    
    
	// NSMutableDictionary* quickFaceLookup = [NSMutableDictionary dictionary];
    
    std::vector<Vertex_3f_3f_2f> vertexData;
    std::vector<ushort> indexData;
    
    //for every face
    for( std::vector<NSString*>::const_iterator iter = faces.begin(); iter != faces.end(); ++ iter ) 
    {
        //id result = [quickFaceLookup objectForKey:(*iter)];
        
        //if( result == nil )
       // {
            //new face
          //  NSLog(@" face is %@", *iter);
            NSArray* faceIndices = [(*iter) componentsSeparatedByString:@"/"];
            
            if( [faceIndices count] == 3 )
            {
               // NSLog(@"face indicies count");
                //[quickFaceLookup setValue:[NSNumber numberWithInt:vertexData.size()] forKey:(*iter)];
                
                //construct vertex data for this face.
                int vertexIndex =  [[faceIndices objectAtIndex:0] intValue] - 1;
                int uvIndex = [[faceIndices objectAtIndex:1] intValue] - 1;
                int normalIndex = [[faceIndices objectAtIndex:2] intValue] - 1;
                
               // [squareWireframeVertices addObject:FBOX(vertices[vertexIndex].x]);
                // [squareWireframeVertices addObject:FBOX(vertices[vertexIndex].y]);
                //  [squareWireframeVertices addObject:FBOX(vertices[vertexIndex].z]);

                debugcounter++;
                //NSLog(@"vertex %i", [[faceIndices objectAtIndex:0] intValue]);
                indexData.push_back(vertexData.size());
                vertexData.push_back(Vertex_3f_3f_2f( vertices[vertexIndex], normals[normalIndex], uvs[uvIndex] ));
            }
       // }
      //  else
      //  {
            //face allready exists
          //  NSNumber* faceIndex = result;
          //  indexData.push_back( [faceIndex intValue] );
      //  }
    } 
    
     NSLog(@"added to other: %i", debugcounter);
    
    VertexData returnData;
    returnData.indexData = indexData;
    returnData.vertexData = vertexData;
    returnData.position = averagePosition;
	returnData.corners  = vertices;
    returnData.vertexLengths = vertexLength;
    return returnData;
}

GLModel::~GLModel()
{
}

int GLModel::getPositionX()
{
    NSLog(@"pos x is %f", m_Position.x);
    int returnVal = m_Position.x;
    return returnVal;
}

int GLModel::getPositionY()
{
    return m_Position.y;
}


int GLModel::getPositionZ()
{
    return m_Position.z;
}

Vector3 GLModel::getPosition()
{
    NSLog(@"called here o.k");

	return Vector3(m_Position.x, m_Position.y, m_Position.z);
}

Vector3 GLModel::ProcessVector3( NSString* line )
{
    NSArray* lineComponents = [line componentsSeparatedByString:@" "];

    if( [lineComponents count] >= 4 )
    {
        return Vector3( [[lineComponents objectAtIndex:1] floatValue], [[lineComponents objectAtIndex:2] floatValue], [[lineComponents objectAtIndex:3]  floatValue] );
    }
    else
    {
        return Vector3( 0.f, 0.f, 0.f );
    }
}

Vector2 GLModel::ProcessVector2( NSString* line )
{
    NSArray* lineComponents = [line componentsSeparatedByString:@" "];
    
    if( [lineComponents count] >= 3 )
    {
        return Vector2( [[lineComponents objectAtIndex:1] floatValue], [[lineComponents objectAtIndex:2] floatValue] );
    }
    else
    {
        return Vector2( 0.f, 0.f);
    }
}

std::vector<NSString*> GLModel::ProcessFaceListTriangle( NSString* line, BOOL firstEdge )
{
    NSArray* lineComponents = [line componentsSeparatedByString:@" "];
    std::vector<NSString*> ret;
  
    
    
    if(firstEdge == YES)
    {
        ret.push_back([lineComponents objectAtIndex:1]);
        ret.push_back([lineComponents objectAtIndex:2]);
        ret.push_back([lineComponents objectAtIndex:3]);
    }
    else
    {
        ret.push_back([lineComponents objectAtIndex:3]);
        ret.push_back([lineComponents objectAtIndex:4]);
        ret.push_back([lineComponents objectAtIndex:1]);
    }
    return ret;
}

std::vector<NSString*> GLModel::ProcessFaceList( NSString* line )
{
    NSArray* lineComponents = [line componentsSeparatedByString:@" "];
    
    std::vector<NSString*> ret;

    for( int i = 1; i < [lineComponents count]; ++i )
    {
        ret.push_back([lineComponents objectAtIndex:i]);
    }
    
    //if([lineComponents count] < 6) ret.push_back([lineComponents objectAtIndex:1]);
    return ret;
}

void GLModel::draw( int* shaderParams )
{
    //\========================================================================================================================
	//Bind VBO && IBO
	//\========================================================================================================================
	GLuint offset = 0;
    unsigned int stride = m_vertices->GetVertexDataSize();
    
    if(Renderable::getRenderMode() == FILLEDWIREFRAME || Renderable::getRenderMode() == SOLID)
    {
        m_triangleMesh->Bind();
        m_triangleVertices->Bind();
        
        // Update attribute values
        
        glEnableVertexAttribArray(GL_VERTEX_ARRAY);
        glVertexAttribPointer(GL_VERTEX_ARRAY, 3, GL_FLOAT, GL_FALSE, stride, (const void*)offset);
        
        offset += sizeof(Vector3);
        glEnableVertexAttribArray(GL_NORMAL_ARRAY);
        glVertexAttribPointer(GL_NORMAL_ARRAY, 3, GL_FLOAT, GL_FALSE, stride, (const void*)offset);
        
        offset += sizeof(Vector3); 

        glEnableVertexAttribArray(GL_TEX_COORD_ARRAY);
        glVertexAttribPointer(GL_TEX_COORD_ARRAY, 2, GL_FLOAT, GL_FALSE, stride, (const void*)offset);
        glEnable(GL_BLEND);
        glCullFace(GL_BACK);
        //glEnable(GL_CULL_FACE);

       glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, m_TextureID);
        //glUniform1i(shaderParams[SHAPE_TEXTURE], 0);
       // glBlendFunc(GL_ONE, GL_CONSTANT_ALPHA);
        glUniform4f(shaderParams[SHAPE_COLOR],1,1,1,0.6);
        // glDrawElements(GL_TRIANGLES, m_triangleMesh->GetIndexSize(), m_triangleMesh->GetIndexType(), (void*)0);
        for(int i = 0; i + 3 <= m_triangleMesh->GetIndexSize(); i+=3)
        {
            glDrawArrays(GL_TRIANGLES, i,3);
        }
        glUniform4f(shaderParams[SHAPE_COLOR],1,0,0,1);
        m_triangleMesh->UnBind();
        m_triangleVertices->UnBind();
    }
    if(Renderable::getRenderMode() == FILLEDWIREFRAME || Renderable::getRenderMode() == WIREFRAME)
   {
        m_vertices->Bind();
        m_indices->Bind();
        
        offset = 0;
        glEnableVertexAttribArray(GL_VERTEX_ARRAY);
        glVertexAttribPointer(GL_VERTEX_ARRAY, 3, GL_FLOAT, GL_FALSE, stride, (const void*)offset);
        offset += sizeof(Vector3);
        glEnableVertexAttribArray(GL_NORMAL_ARRAY);
        glVertexAttribPointer(GL_NORMAL_ARRAY, 3, GL_FLOAT, GL_FALSE, stride, (const void*)offset);
        
        offset += sizeof(Vector3); 
        
        glEnableVertexAttribArray(GL_TEX_COORD_ARRAY);
        glVertexAttribPointer(GL_TEX_COORD_ARRAY, 2, GL_FLOAT, GL_FALSE, stride, (const void*)offset);
       // m_triangleMesh->Bind();
      //  glEnable(GL_POLYGON_OFFSET_FILL);
       /// glPolygonOffset(10, 10);
        //glDisable(GL_CULL_FACE);
        glLineWidth(2.5);
       int drawCount = 0;
       for(int i = 0; i + 4 <= m_indices->GetIndexSize(); i+=4)
        {
           // NSLog(@"Drawing from %i", m_vertexLengths[drawCount]);
            if(m_vertexLengths[drawCount] <= 4)
            {
            glDrawArrays(GL_LINE_LOOP, i,4);
            }
             ++drawCount;
        }
       m_vertices->UnBind();
       m_indices->UnBind();
   }
    
	//\========================================================================================================================
	// unbind and disable VBO IBO 
	//\========================================================================================================================	
	glDisableVertexAttribArray(GL_VERTEX_ARRAY);
    glDisableVertexAttribArray(GL_NORMAL_ARRAY);
    glDisableVertexAttribArray(GL_TEX_COORD_ARRAY);
    
	// Unbind the VBO and IBO
	
    
}

