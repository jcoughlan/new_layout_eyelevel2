//
//  EAGLView.h
//  BubblePix
//
//  Created by Jamie Stewart on 21/04/11.
//  Copyright 2011 Fluid Pixel. All rights reserved.
//

#import <UIKit/UIKit.h>
//\======================================================================================
//\The Includes needed to support all versions of OpenGLES 
//\(This app should only support OpenGLES 2.0 for shader use in the future)
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>
//#import <OpenGLES/ES1/gl.h>
//#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

//\======================================================================================
//\Import CoreVideo so we can support Texture Conversion from a CVImageBufferRef
//\This is only passed through to the GLBillboard class
#import <CoreVideo/CoreVideo.h>
//\======================================================================================
#include "Renderable.h"
#include "Matrix4.h"
#include "Vector3.h"

#import "GLBillboard.h"

#import "GLCube.h"

#include <vector>
#import "GLBillboard.h"

@protocol CameraControllerDelegate;

@interface EAGLView : UIView
{
@private
    EAGLContext*			context;
    
    // The pixel dimensions of the CAEAGLLayer
    GLint					backingWidth;
    GLint					backingHeight;
    
     // The OpenGL ES names for the framebuffer and renderbuffer used to render to this view.
	GLuint                  viewRenderbuffer, viewFramebuffer, depthRenderbuffer;
	GLuint					m_defaultShader;
    GLuint					m_modelShader;
    
	//\The Billboard that we're going to render stuff to
	GLBillboard*			m_glBillboard;
    GLCube*                 m_glCube;
    
	Matrix4				m_ProjectionMatrix;
    
    std::vector<IRenderable*>         m_Renderables;
    
    id<CameraControllerDelegate>    m_CameraDelegate;
    
    
    
}

@property (nonatomic, strong) EAGLContext *context;

//-(void)setUpGLViewport;
-(void)setCameraController:(id<CameraControllerDelegate>)delegate;
-(BOOL)presentFramebuffer;
-(void)drawView;
-(void)unbind;


//PassThrough so our main view doesn't have to care about what it's rendering
-(void)createBillboardTexture:(CVImageBufferRef)imageBufferRef;
-(BOOL)resizeFromLayer:(CAEAGLLayer*)layer;

//\Manage renderables
-(void)addRenderable:(IRenderable*)renderable;
-(void)removeRenderables;
//\================================================================================================
//\Shader Compilation and linker methods
-(bool)CompileShader:(GLuint*)shader glType:(GLenum)type fileName:(const char*)file;
-(bool)linkProgram:(GLuint)prog;
-(bool)validateProgram:(GLuint)prog;
-(bool)loadShaders:(const char*)shaderFile glShader:(GLuint*)shader glUniforms:(GLint*)uniform;
//\================================================================================================

-(UIImage*)glViewToImage;


-(void) setSceneFOV:(float) value;
-(void) setSceneTransparency:(float)value;

+(void)changeRenderMode;

@end

@protocol CameraControllerDelegate <NSObject>
-(Matrix4) getViewMatrix;
@end

