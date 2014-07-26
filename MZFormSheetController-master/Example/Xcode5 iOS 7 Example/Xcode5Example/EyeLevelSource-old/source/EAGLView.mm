//
//  EAGLView.m
//  BubblePix
//
//  Created by Jamie Stewart on 21/04/11.
//  Copyright 2011 Fluid Pixel. All rights reserved.
//

#import "EAGLView.h"
#import <QuartzCore/QuartzCore.h>

#include "Profiler.h"

#include "EAGLDefines.h"
#include <memory.h>
#include "GLModel.h"

GLint uniforms[NUM_UNIFORMS];
GLint modelUniforms[NUM_UNIFORMS];

@interface EAGLView (PrivateMethods)
- (BOOL)createFramebuffers;
- (void)deleteFramebuffer;
- (Matrix4)getViewMatrix;
@end

@implementation EAGLView

@dynamic context;
//\======================================================================================
// You must implement this method
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

//\======================================================================================
//\Initialise the EAGLView with a CGRect Object, this will also be the dimensions for the 
//\framebuffer object
//\======================================================================================
- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
		CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;


        [eaglLayer setOpaque:YES];
		NSDictionary* drawProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking,
                                        kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
                                        nil];
        
        [eaglLayer setDrawableProperties:drawProperties];
		
		context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        
		if (!context || ![EAGLContext setCurrentContext:context] || ![self createFramebuffers] )
        {
			NSLog(@"Failed to set ES context current");
            [self release];
            return nil;
		}
		
		if( ![self loadShaders:"modelShader" glShader:&m_modelShader glUniforms:modelUniforms] || ![self loadShaders:"Shader" glShader:&m_defaultShader glUniforms:uniforms])
        {
            [self release];
            return nil;
        }

        glUseProgram(m_defaultShader);
        
        glActiveTexture(GL_TEXTURE0);
        
        
        m_glBillboard = new GLBillboard(0.75f);
       // m_glCube = new GLCube(Matrix4::IDENTITY, 0.5f, 0.5f, 0.5f,  @"red.png");
        
        
        [self setSceneFOV:54.15f];
        [self setSceneTransparency:0.6f];
        
        
    }
    return self;
}


//\======================================================================================
//\ Destructor
//\======================================================================================
- (void)dealloc
{
    [self deleteFramebuffer];
    
	if ([EAGLContext currentContext] == context)
    {
		[EAGLContext setCurrentContext:nil];
	}
    
    [context release];
    
	context = nil;
	
    [super dealloc];
}

- (EAGLContext *)context
{
    return context;
}

//\======================================================================================
//\Swap out the render model for the other one
//\======================================================================================


- (BOOL)createFramebuffers
{	
	// Onscreen framebuffer object
	glGenFramebuffers(1, &viewFramebuffer);
	glBindFramebuffer(GL_FRAMEBUFFER, viewFramebuffer);
	
	glGenRenderbuffers(1, &viewRenderbuffer);
	glBindRenderbuffer(GL_RENDERBUFFER, viewRenderbuffer);
	
	[context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)self.layer];

	glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
	glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
	
	glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, viewRenderbuffer);
    
    glGenRenderbuffers(1, &depthRenderbuffer);
	glBindRenderbuffer(GL_RENDERBUFFER, depthRenderbuffer);
	glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, backingWidth, backingHeight);
	glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderbuffer);
    
	if( glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) 
	{ 		
        NSLog(@"Failure with framebuffer generation");
		return NO;
	}
	
    glViewport(0, 0, backingWidth, backingHeight);
	
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    //Enable depth testing
    glEnable(GL_DEPTH_TEST);
    glDepthFunc(GL_LEQUAL);
    
    //disable back face culling due to loaded models being done every which way... silly artists :(
    glDisable(GL_CULL_FACE);

    glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );

    GLenum error = glGetError();
    if( error != GL_NO_ERROR )
    {
        NSLog(@"GL ERROR %i CREATING FRAMEBUFFER", error);
    }
    
	NSLog(@"Created framebuffer");
	return YES;
}

- (void)deleteFramebuffer
{
    if (context)
    {
        [EAGLContext setCurrentContext:context];
        
        if (viewFramebuffer)
        {
            glDeleteFramebuffers(1, &viewFramebuffer);
            viewFramebuffer = 0;
        }
        
        if (viewRenderbuffer)
        {
            glDeleteRenderbuffers(1, &viewRenderbuffer);
            viewRenderbuffer = 0;
        }
        
        if (depthRenderbuffer)
        {
            glDeleteRenderbuffers(1, &depthRenderbuffer);
            depthRenderbuffer = 0;
        }
    }
}



- (BOOL)presentFramebuffer
{
    BOOL success = FALSE;
    
    if (context)
    {
        glBindRenderbuffer(GL_RENDERBUFFER, viewRenderbuffer);
        success = [context presentRenderbuffer:GL_RENDERBUFFER];
    }
    
    return success;
}

-(void)createBillboardTexture:(CVImageBufferRef)imageBufferRef
{
    
    m_glBillboard->createTexture(imageBufferRef);
}

-(void)addRenderable:(IRenderable *)renderable
{
    m_Renderables.push_back(renderable);
}

-(void)removeRenderables
{
    m_Renderables.clear();
}

-(void)drawView
{
   
	// Profiler::beginTrace((char*)"RENDER");
    
    GLenum error = glGetError();
    if( error != GL_NO_ERROR )
    {
        NSLog(@"GL ERROR %i", error);
    }
    
    /************************************************************************************************************************************
     *Clear Old Buffers.
    ************************************************************************************************************************************/
    glBindFramebuffer(GL_FRAMEBUFFER, viewFramebuffer);
    
    glClearColor(0.5f, 0.5f, 0.5f, 0.f);
	glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
   
    glUseProgram(m_defaultShader);
    
	/************************************************************************************************************************************
     *Render Background.
     *
     *Render the billboard without using the camera view matrix, as this stays in fixed position and doesnt move with camera.
     ************************************************************************************************************************************/
    glDisable(GL_DEPTH_TEST);

    glUniformMatrix4fv(uniforms[PROJECTION_MATRIX], 1, GL_FALSE, (const float*)( m_ProjectionMatrix ) );
    
    glUniformMatrix4fv(uniforms[VIEW_MATRIX], 1, GL_FALSE, (const float*)( Matrix4::IDENTITY ));
    glUniformMatrix4fv(uniforms[MODEL_MATRIX], 1, GL_FALSE, (const float*)( m_glBillboard->getTransformation() ) );
    m_glBillboard->draw(uniforms);

  //  glUniformMatrix4fv(uniforms[MODEL_MATRIX], 1, GL_FALSE, (const float*)( m_glCube->getTransformation() ) );
    //m_glCube->draw(uniforms);
    glEnable(GL_DEPTH_TEST);

    
    /************************************************************************************************************************************
     *Render Renderables.
     *
     *Renders all 'normal' behaving renderables. this loop should be as tight as possible.
     ************************************************************************************************************************************/
    
    glUseProgram(m_modelShader);
    glUniformMatrix4fv(modelUniforms[VIEW_MATRIX], 1, GL_FALSE, (const float*)([self getViewMatrix]));
    glUniformMatrix4fv(modelUniforms[PROJECTION_MATRIX], 1, GL_FALSE, (const float*)( m_ProjectionMatrix ) );
    
    for(std::vector<IRenderable*>::const_iterator iter = m_Renderables.begin(); iter != m_Renderables.end(); ++iter )
    {
        if(*iter == nil) continue;
        if( (*iter)->isVisible() )
        {
            glUniformMatrix4fv(modelUniforms[MODEL_MATRIX], 1, GL_FALSE, (const float*)( (*iter)->getTransformation() ));
            (*iter)->draw( modelUniforms );
        }
    }
    
    /************************************************************************************************************************************
     * Draws the currently bound render buffer
     ************************************************************************************************************************************/
    [self presentFramebuffer];
    
    //Profiler::endTrace((char*)"RENDER");
    //Profiler::outputToBuffer();
}

-(Matrix4)getViewMatrix
{
    return m_CameraDelegate == nil ?  Matrix4::IDENTITY : [m_CameraDelegate getViewMatrix];
}



-(void)unbind
{
}

-(void)layoutSubviews
{
    // The framebuffer should be re-created at the beginning of the next setFramebuffer method call.
    [self resizeFromLayer:(CAEAGLLayer *)self.layer];
}

-(BOOL)resizeFromLayer:(CAEAGLLayer *)layer
{
	glBindFramebuffer(GL_FRAMEBUFFER, viewFramebuffer);
     
     // Allocate color buffer backing based on the current layer size
    glBindRenderbuffer(GL_RENDERBUFFER, viewRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:layer];
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
     
    glBindRenderbuffer(GL_RENDERBUFFER, depthRenderbuffer);
	glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, backingWidth, backingHeight);
	glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderbuffer);

     if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
     {
         NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
         return NO;
     }

     
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    return YES;
}

//\==================================================================================================================================
//\ Load and compile specific shaders for this object
//\==================================================================================================================================
-(bool)CompileShader:(GLuint*)shader glType:(GLenum)type fileName:(const char*)file
{
    GLint status;
    const GLchar *source;
	
    source = (GLchar *)[[NSString stringWithContentsOfFile:[NSString stringWithUTF8String:file] encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source)
    {
#ifdef DEBUG
        NSLog(@"Failed to load vertex shader");
#endif
        return FALSE;
    }
	
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
	
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
	
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0)
    {
        glDeleteShader(*shader);
        return FALSE;
    }
	
    return TRUE;
}

-(bool)linkProgram:(GLuint)prog
{
    GLint status;
	
    glLinkProgram(prog);
	
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
	
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0)
        return false;
	
    return true;
}

-(bool)validateProgram:(GLuint)prog
{
    GLint logLength, status;
	
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
#ifdef DEBUG
		NSLog(@"Program validate log:\n%s", log);
#endif
        free(log);
    }
	
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0)
        return false;
	
    return true;
}

-(bool)loadShaders:(const char*)shaderFile glShader:(GLuint*)shader glUniforms:(GLint*)inUniform
{
  
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
	
    // Create shader program
    *shader = glCreateProgram();
	
    // Create and compile vertex shader
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:shaderFile] ofType:@"vsh"];
    if (![self CompileShader:&vertShader glType:GL_VERTEX_SHADER fileName:[vertShaderPathname UTF8String] ])
    {
#ifdef DEBUG
        NSLog(@"Failed to compile vertex shader");
#endif
        return FALSE;
    }
	
    // Create and compile fragment shader
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:shaderFile] ofType:@"fsh"];
    if (![self CompileShader:&fragShader glType:GL_FRAGMENT_SHADER fileName:[fragShaderPathname UTF8String]] )
    {
#ifdef DEBUG
        NSLog(@"Failed to compile fragment shader");
#endif
        return FALSE;
    }
	
    // Attach vertex shader to program
    glAttachShader(*shader, vertShader);
	
    // Attach fragment shader to program
    glAttachShader(*shader, fragShader);
	
    // Bind attribute locations
    // this needs to be done prior to linking
    glBindAttribLocation(*shader, GL_VERTEX_ARRAY, "position");
	glBindAttribLocation(*shader, GL_NORMAL_ARRAY, "normal" );
	glBindAttribLocation(*shader, GL_TEX_COORD_ARRAY, "texcoord");
    //glBindAttribLocation(*shader, GL_VERTEX_ARRAY, "color");
	
    // Link program
    if (![self linkProgram:*shader])
    {
#ifdef DEBUG
        NSLog(@"Failed to link program: %d", *shader);
#endif
        if (vertShader)
        {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader)
        {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (*shader)
        {
            glDeleteProgram(*shader);
            *shader = 0;
        }
        
        return false;
    }
	
    // Get uniform locations
    inUniform[MODEL_MATRIX]           = glGetUniformLocation(*shader, "modelMatrix");
    inUniform[VIEW_MATRIX]            = glGetUniformLocation(*shader, "viewMatrix");
    inUniform[PROJECTION_MATRIX]      = glGetUniformLocation(*shader, "projectionMatrix");
	inUniform[SHAPE_TEXTURE]			= glGetUniformLocation(*shader, "s_shapeTexture");
	inUniform[SHAPE_COLOR]			= glGetUniformLocation(*shader, "m_color");
	inUniform[SCALE]					= glGetUniformLocation(*shader, "scale");
    inUniform[TRANSPARENCY]           = glGetUniformLocation(*shader, "u_Transparency");
	
    // Release vertex and fragment shaders
    if(vertShader)
    {
		glDeleteShader(vertShader);
	}
	if (fragShader)
	{
		glDeleteShader(fragShader);
	}	
	return true;
}


+(void)changeRenderMode
{
    Renderable::changeRenderMode();
}

//\==================================================================================================================================
//\ End Object Shader code
//\==================================================================================================================================


#pragma mark - Utilities
//might need to adjust this for retina display and IPAD when we support this.
-(UIImage*)glViewToImage
{
    
    int width = 480;
    int height = 320;
        
       NSInteger myDataLength = width * height * 4; 
    
    // allocate array and read pixels into it.
    GLubyte *buffer = (GLubyte *) malloc(myDataLength);
    glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    
    // gl renders "upside down" so swap top to bottom into new array.
    // there's gotta be a better way, but this works.
    GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
    for(int y = 0; y < height; y++)
    {
        for(int x = 0; x < width * 4; x++)
        {
            buffer2[(height - 1 - y) * width * 4 + x] = buffer[y * 4 * width + x];
        }
    }
    
    // make data provider with data.
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, NULL);
    
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * width;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    // make the cgimage
    CGImageRef imageRef = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
    // then make the uiimage from that
    UIImage *myImage = [UIImage imageWithCGImage:imageRef];
   

    return myImage;
}



#pragma mark - Mutators

-(void)setCameraController:(id<CameraControllerDelegate>)delegate
{
    m_CameraDelegate = delegate;
}

-(void) setSceneFOV:(float) value
{
    NSLog(@"fov %f", value);
    m_ProjectionMatrix = Matrix4::CreatePerspective( DEG_2_RAD *  value, self.frame.size.width/self.frame.size.height, 1.0f, 500.f );
    m_glBillboard->setTransformation(Matrix4::CreateTranslation( Vector3( 0.f, 0.f, -1.f/ tanf( value * 0.5f * DEG_2_RAD)) ));
    //m_glCube->setTransformation(Matrix4::CreateTranslation(Vector3(0,0,-3.25f)));
}

-(void) setSceneTransparency:(float)value;
{
     glUniform1f(modelUniforms[TRANSPARENCY], value);
     glUniform1f(uniforms[TRANSPARENCY], value);
}

@end