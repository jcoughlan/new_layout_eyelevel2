////
////  UIVideoCaptureViewController.m
////  BubblePix
////
////  Created by Jamie Stewart on 21/04/11.
////  Copyright 2011 Fluid Pixel. All rights reserved.
////
//
//#import "UIVideoCaptureViewController.h"
//#import "GLCube.h"
//#import "GLModel.h"
//#import "RenderableInstance.h"
//#import "EyeLevelAssetManager.h"
//#import "DSActivityView.h"
//#import "AppDelegate.h"
//
//#import "Maths.h"
//
//#define FOV	DEG_2_RAD * 60.f
//#define FOV_2 (FOV * 0.5f)
//#define MAX_POI_DIST 1.0/0.5
//#define MAX_DIST 1.0/12.0
//#define MAX_POINT_SIZE 88.0
//#define MIN_POINT_SIZE 22.0
//#define SCALE_LONGLATS 10000
//
//
//#define MOVE_AMOUNT 0.5f
//
//
//@interface UIVideoCaptureViewController (Private)
//-( void ) lockGPSUpdates;
//-( void ) unlockGPSUpdates;
//-( UIImage * )addText:(UIImage *)img text:(NSString *)text1 x:(int)xPos y:(int)yPos;
//-( void ) positionHorizontalSpiritLevelAt:(float)horizontalPosition andVerticalSpiritLevelAt:(float)verticalPosition;
//@end
//
//@implementation UIVideoCaptureViewController
//@synthesize horizontalSpiritLevelMarker;
//@synthesize verticalSpiritLevelMarker;
//
////\=====================================================================================================
////\ Initialise the class and set up the input capture feeds and OpenGLES view.
////\=====================================================================================================
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    if( (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) )
//	{
//		//Set Up EAGLView
//        //TODO: CHange the size of this, why cant we do this? it needs to be dynamic...
//		m_EAGLView = [[EAGLView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
//        //m_CaptureView = [[EAGLView alloc] initWithFrame:CGRectMake(0, 0, 1440, 960)];
//        m_CameraController = [[ARCameraController alloc] init];
//        m_bIsAsyncLoadingAssets = false;
//        m_CoordinateConverter = [[CLLocationCoordinate2D_OSGB alloc] init];
//        m_Buildings = [[NSMutableArray alloc] init];
//        m_SurroundingBuildings = [[NSMutableArray alloc] init];
//        
//    }
//    return self;
//}
//
//
//
//-(void)createDebugAxisStructure:(Vector3)pos;
//{
//    GLCube* cube = new GLCube(Matrix4::IDENTITY, 1, 1, 1, @"boxTexture3.png");
//    
//    int numX = 3;
//    int numZ = 10;
//    int numY = 10;
//    
//    for(int i = 1; i < numZ + 1; ++i )
//    {
//        RenderableInstance* instance = new RenderableInstance( cube, Matrix4::CreateTranslation( Vector3( pos.x, pos.y, pos.z + ( i * 3 ) ) ) );
//        [m_EAGLView addRenderable:instance];
//    }
//    
//    for(int i = 1; i < numY + 1; ++i )
//    {
//        RenderableInstance* instance = new RenderableInstance( cube, Matrix4::CreateTranslation( Vector3( pos.x, pos.y + i*3, pos.z ) ) );
//        [m_EAGLView addRenderable:instance];
//        
//    }
//    
//    for(int i = 1; i < numX + 1; ++i )
//    {
//        RenderableInstance* instance = new RenderableInstance( cube, Matrix4::CreateTranslation( Vector3( pos.x + i * 3, pos.y, pos.z ) ) );
//        [m_EAGLView addRenderable:instance];
//    }
//}
//
//-(void) createDebugHorizontalCircle:(Vector3)pos radius:(float)theRadius
//{
//    GLCube* model = new GLCube(Matrix4::IDENTITY, 1, 1, 1, @"yellow.png");
//    
//    for(int i = 0; i < 360; i++)
//    {
//        RenderableInstance* instance = new RenderableInstance( model, Matrix4::CreateTranslation( pos + Vector3( theRadius * sin(i),0, theRadius * cos(i) ) ) );
//        [m_EAGLView addRenderable:instance];
//    }
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    [m_EAGLParentView addSubview:m_EAGLView];
//	
//	[self initDeviceInputCapture];
//    
//    //old code from before we removed live/manual button, leaving in for later debugging
//    /* [m_rotateLeftButton setHidden:!m_resetButton.selected];
//     [m_rotateRightButton setHidden:!m_resetButton.selected];
//     [m_upButton setHidden:!m_resetButton.selected];
//     [m_downButton setHidden:!m_resetButton.selected];
//     [m_heightOutput setHidden:!m_resetButton.selected];*/
//    
//    //new code to hide aforementioned button
//    m_resetButton.hidden = YES;
//    
//    
//    // [self createDebugAxisStructure:Vector3( 0, 0, -50)];
//    //  [self createDebugAxisStructure:Vector3( 0, 50, 0)];
//    //  [self createDebugAxisStructure:Vector3( 50, 0, 0)];
//    //  [self createDebugHorizontalCircle:Vector3::ZERO radius:50.f];
//	
//	//pass assets to render list
//	for( EyeLevelAsset* asset in [[EyeLevelAssetManager sharedInstance] getAssets] )
//	{
//        
//		GLModel* model = [asset getModelForModelNum:0];
//		RenderableInstance* instance = new RenderableInstance( model, Matrix4::IDENTITY );
//		[m_Buildings addObject:[NSValue valueWithPointer:instance]];
//		[m_EAGLView addRenderable:model];
//		instance->setVisible(false);
//		
//		//if this asset has a surrounding obj, load model for this
//		if( [asset getSurroundingModel] )
//		{
//			GLModel* surroundingModel = [asset getSurroundingModel];
//			RenderableInstance* surroundingModelInstance = new RenderableInstance( surroundingModel, Matrix4::IDENTITY );
//			surroundingModelInstance->setVisible(true);
//			[m_SurroundingBuildings addObject:[NSValue valueWithPointer:surroundingModelInstance]];
//			[m_EAGLView addRenderable:surroundingModelInstance];
//		}
//	}
//	
//	[self SurroundingBuildingsVisible:YES];
//	
//    [m_EAGLView setCameraController:m_CameraController];
//}
//
//-(void) viewWillDisappear:(BOOL)animated
//{
//    [self endCaptureSession];
//    
//    [super viewWillDisappear:animated];
//}
//
//-(void) viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [m_CameraController applyYawReset];
//    m_renderCameraFeed = YES;
//    [self startCaptureSession];
//    modelNumber = 0;
//}
//
//-(IBAction)resetCameraPosition:(id)sender
//{
//    [m_CameraController resetCamera];
//    
//}
//
//- (void)viewDidUnload
//{
//    [super viewDidUnload];
//    
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//    
//    [self endCaptureSession];
//    [m_EAGLView setCameraController:nil];
//	
//	self.horizontalSpiritLevelMarker = nil;
//	self.verticalSpiritLevelMarker = nil;
//}
//
//-(void)beginPhotoCapture
//{
//    //disable the video record button
//	[self endCaptureSession];
//    
//	[m_videoCaptureOutput setSampleBufferDelegate:nil queue:nil];
//	[m_CaptureSession removeOutput:m_videoCaptureOutput];
//	
//	[m_CaptureSession setSessionPreset:AVCaptureSessionPresetPhoto];
//	[self startCaptureSession];
//    
//    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(captureStillImage) userInfo:nil repeats:NO];
//}
//
//
//
//-(void)captureStillImage
//{
//	//NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
//	
//	AVCaptureStillImageOutput* currentOutput;
//    for( AVCaptureOutput* currentOutputs in [m_CaptureSession outputs])
//	{
//		if( [currentOutputs isKindOfClass:[AVCaptureStillImageOutput class]] )
//		{
//			currentOutput = (AVCaptureStillImageOutput*)currentOutputs;
//			break;
//		}
//	}
//	
//    AVCaptureConnection *videoConnection = nil;
//    for (AVCaptureConnection *connection in currentOutput.connections)
//    {
//        for (AVCaptureInputPort *port in [connection inputPorts])
//        {
//            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
//            {
//                videoConnection = connection;
//                break;
//            }
//        }
//        if (videoConnection)
//        {
//            break;
//        }
//    }
//	
//    [currentOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:
//     
//     ^(CMSampleBufferRef imageDataSampleBuffer, NSError *error)
//	 {
//         if (imageDataSampleBuffer != nil)
//         {
//			 //NSDictionary* dict = [captureOutput outputSettings];
//			 CMFormatDescriptionRef formatDesc = CMSampleBufferGetFormatDescription(imageDataSampleBuffer);
//			 if( kCMVideoCodecType_JPEG == CMFormatDescriptionGetMediaSubType(formatDesc))
//			 {
//				 NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//				 [self performSelectorOnMainThread:@selector(writeImageToPhotoLibrary:) withObject:[[UIImage alloc] initWithData:imageData]  waitUntilDone:YES];
//			 }
//			 else
//			 {
//				 [self captureStillImage];
//			 }
//         }
//		 else if (error)
//         {
//			 NSLog(@"Error on Still Image Capture");
//		 }
//     }];
//	
//    //[pool drain];
//}
//
//-(void)writeImageToPhotoLibrary:(UIImage*) image
//{
//	ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:
//     ^(NSURL *assetURL, NSError *error)
//	 {
//		 if (error)
//		 {
//			 NSLog(@"SaveImageToDevice Failed with Error");
//		 }
//	 }];
//    
//    ///[library release];
//	
//	[self endCaptureSession];
//    
//	dispatch_queue_t queue;
//	queue = dispatch_queue_create("cameraQueue", NULL);
//	[m_videoCaptureOutput setSampleBufferDelegate:self queue:queue];
//	//dispatch_release(queue);
//	
//	if( [m_CaptureSession canAddOutput:m_videoCaptureOutput] )
//	{
//		[m_CaptureSession addOutput:m_videoCaptureOutput];
//	}
//    
//	[m_CaptureSession setSessionPreset:AVCaptureSessionPreset640x480];
//	[self startCaptureSession];
//}
////\=====================================================================================================
////\
////\=====================================================================================================
//-(void)initDeviceInputCapture
//{
//	//\=====================================================================================================
//	//\Set Up the Input AVCapture
//	AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput
//										  deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo]
//										  error:nil];
//	//\=====================================================================================================
//	//\Set Up Still Image Capture
//    m_stillImageCaptureOutput = [[AVCaptureStillImageOutput alloc] init]; //Still Image Output Init
//	NSDictionary* imageOutputSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
//    [m_stillImageCaptureOutput setOutputSettings:imageOutputSettings];
//    
//    //\Set up Video Capture
//	m_videoCaptureOutput = [[AVCaptureVideoDataOutput alloc] init]; //Video Image Output
//    
//	NSDictionary *videoOutputSettings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA], (NSString*)kCVPixelBufferPixelFormatTypeKey, nil];
//	[m_videoCaptureOutput setVideoSettings:videoOutputSettings];
//    
//    
//    //\We create a serial queue to handle the processing of our frames
//	dispatch_queue_t queue = dispatch_queue_create("cameraQueue", NULL);
//	[m_videoCaptureOutput setSampleBufferDelegate:self queue:queue];
//	//	dispatch_release(queue);
//    
//    //\Setup Capture Session
//	m_CaptureSession = [[AVCaptureSession alloc] init];
//    
//	/*We add input and output*/
//    if ([m_CaptureSession canAddInput: captureInput])
//        [m_CaptureSession addInput:captureInput];
//    else{
//        //if we have no camera, bail (should only happen on simulator)
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No Camera Detected" message:@"It appears your device does not have a functioning camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        
//        [alert show];
//        //[alert release];
//        return;
//    }
//    
//	if( [m_CaptureSession canAddOutput:m_stillImageCaptureOutput] )
//	{
//		[m_CaptureSession addOutput:m_stillImageCaptureOutput];
//	}
//    
//	if( [m_CaptureSession canAddOutput:m_videoCaptureOutput] )
//	{
//		[m_CaptureSession addOutput:m_videoCaptureOutput];
//	}
//    
//	//\Set up our image size preset - any higher than this and we get the video FOV/Zoom which is a 'bug' according to Apple
//	//[m_CaptureSession setSessionPreset:AVCaptureSessionPreset640x480];
//    
//    
//    //not sure if this is still an issue so updating to highest preset
//    [m_CaptureSession setSessionPreset:AVCaptureSessionPreset1920x1080];
//    
//}
//
////\=====================================================================================================
////\ This a delegate function for AVCatureVideoData - it gets called from there when the sampleBuffer is ready
////\=====================================================================================================
//- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
//{
//	//\We create an autorelease pool because as we are not in the main_queue our code is
//	//\not executed in the main thread. So we have to create an autorelease pool for the thread we are in
//	//NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
//    
//    
//    if( captureOutput == m_videoCaptureOutput ) //we only want to process the sample if it belongs to video capture.
//    {
//        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//        [self performSelectorOnMainThread:@selector(sendBufferToGLRenderer:) withObject:[[NSCVImageBufferRef alloc] initWithCVImageBufferRef:imageBuffer]  waitUntilDone:false];
//    }
//	
//	//[pool drain];
//}
//
//
//
////\=====================================================================================================
////\
////\=====================================================================================================
//-(void)sendBufferToGLRenderer:(NSCVImageBufferRef*)imageBuffer
//{
//    if( !m_bIsAsyncLoadingAssets )
//    {
//		//get camera accelerations for positioning spirit level
//		[self positionHorizontalSpiritLevelAt:[m_CameraController getGravity].y andVerticalSpiritLevelAt:[m_CameraController getGravity].z];
//		
//        //NSLog(@"%@", sender);
//        if(m_renderCameraFeed == YES)
//        {
//            [m_EAGLView createBillboardTexture:[imageBuffer getImageBufferRef]];
//        }
//        
//        [m_EAGLView drawView]; //draw should be occuring as fast as possible not like this, now we have other objects.
//        
//        //update our camera output.
//        [m_CameraOutputPane setText:[m_CameraController description]];
//    }
//}
//
//
//
//#pragma mark -
////\=====================================================================================================
////\
////\=====================================================================================================
//
//-(void)resetCameraAnimation
//{
//    animateCameraNextTime = NO;
//}
//
//-(void)startCaptureSession
//{
//	[m_CaptureSession startRunning];
//}
//
//-(void)endCaptureSession
//{
//	[m_CaptureSession stopRunning];
//}
//
//- (void)didReceiveMemoryWarning
//{
//    // Releases the view if it doesn't have a superview.
//    [super didReceiveMemoryWarning];
//}
//
//- (void)dealloc
//{
//    //
//    
//    for( NSValue* value in m_SurroundingBuildings )
//    {
//        delete ((RenderableInstance*)value.pointerValue);
//    }
//    
//    //[m_SurroundingBuildings release];
//    
//    for( NSValue* value in m_Buildings )
//    {
//        delete ((RenderableInstance*)value.pointerValue);
//    }
//    //[m_Buildings release];
//	
//    
//	//[super dealloc];
//}
//
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
//}
//
//
//#pragma mark - Add Text to UIImage (could be made into UIImage category function)
//-(UIImage *)addText:(UIImage *)img text:(NSString *)text1 x:(int)xPos y:(int)yPos
//{
//    int w = img.size.width;
//    int h = img.size.height;
//    //lon = h - lon;
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
//    
//    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
//    CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1);
//	
//    char* text	= (char *)[text1 cStringUsingEncoding:NSASCIIStringEncoding];
//    CGContextSelectFont(context, "Arial", 11, kCGEncodingMacRoman);
//    CGContextSetTextDrawingMode(context, kCGTextFill);
//    CGContextSetRGBFillColor(context, 255, 255, 255, 1);
//    //rotate text
//    CGContextSetTextMatrix(context, CGAffineTransformMakeRotation( 0 ));
//	
//    CGContextShowTextAtPoint(context, xPos, yPos, text, strlen(text));
//	
//    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//	
//    return [UIImage imageWithCGImage:imageMasked];
//}
//
//#pragma mark - Private Methods
//
//-( void ) positionHorizontalSpiritLevelAt:(float)horizontalPosition andVerticalSpiritLevelAt:(float)verticalPosition
//{
//	//assert params are valid
//	NSAssert(horizontalPosition <= 1.0f && horizontalPosition >= -1.0f && verticalPosition <= 1.0f && verticalPosition >= - 1.0f, @"Vertical and horizontal spirit level positions should be in the range [ -1, 1 ]");
//    
//	//homogenize positions into range 0 to 1
//	float nHP = ( horizontalPosition + 1 ) * 0.5f;
//	float nVP = ( ( verticalPosition * 2 /*increase gradient of vertical translation*/ )  + 1 ) * 0.5f;
//	
//	//convert to pixel space
//	int horizontalPixelOffset = nHP * self.view.frame.size.width;
//	int verticalPixelOffset = nVP * self.view.frame.size.height;
//	
//	//adjust physical marker positions
//	self.horizontalSpiritLevelMarker.center = CGPointMake( horizontalPixelOffset, self.horizontalSpiritLevelMarker.center.y );
//	self.verticalSpiritLevelMarker.center = CGPointMake(  self.verticalSpiritLevelMarker.center.x, verticalPixelOffset );
//}
//
//-(void) unlockCameraChanges
//{
//    [m_resetButton setSelected: YES];
//    [m_CameraController lockManualAdjustments:NO];
//}
//
//-(void) lockGPSUpdates
//{
//    
//    [m_LockButton setSelected: YES];
//    [m_CameraController setUseLocationServices:NO];
//}
//
//-(void) unlockGPSUpdates
//{
//    [m_LockButton setSelected: NO];
//    [m_CameraController setUseLocationServices:YES];
//}
//
//#pragma mark - EyeLevelUserLocationDelegate
//-(void) eyeLevelUserLocation:(EyeLevelUserLocation*)userLocation didUpdateToLocation:(CLLocation*)location
//{
//    //Cameras position set to lat, long.
//    Vector3 pos = [m_CoordinateConverter OSGB36GridFromWGS84Location:[location coordinate]];
//    [m_CameraController setDisplayHeight:location.altitude];
//    
//    pos.y = 2;//location.altitude;
//    
//    if(previousPos.y != pos.y)
//    {
//        [m_CameraController setPosition:  pos];
//        previousPos = pos;
//        return;
//    }
//    
//    NSLog(@"updating location to x:%f, y:%f, accuracy:%f", pos.x, pos.z, location.horizontalAccuracy);
//    
//    if(animateCameraNextTime == NO)
//    {
//        [m_CameraController setPosition:  pos];
//        animateCameraNextTime = YES;
//        return;
//    }
//    
//    if(abs(previousPos.x - pos.x) > location.horizontalAccuracy * 0.5 || abs(previousPos.y - pos.y) > location.horizontalAccuracy * 0.5 || abs(previousPos.z - pos.z) > location.horizontalAccuracy * 0.5)
//    {
//        
//        [m_CameraController animateToPosition:  pos duration: 3];
//        
//        previousPos = pos;
//    }
//    
//}
//
//#pragma mark - IBActions
//
//-(IBAction) mapButtonPressed:(id)sender
//{
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration: 1];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:YES];
//    [self.navigationController popViewControllerAnimated:NO];
//    [UIView commitAnimations];
//}
//
//-(IBAction)forwardButtonPressed:(id)sender
//{
//    //[self lockGPSUpdates];
//    //switched to move backwards
//    [m_CameraController moveForward:-MOVE_AMOUNT];
//}
//
//-(IBAction)leftButtonPressed:(id)sender
//{
//    // [self lockGPSUpdates];
//    
//    //switched to move Right
//    [m_CameraController moveRight:MOVE_AMOUNT];
//}
//
//
//-(void)displayComposerSheet
//{
//    
//    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
//    NSInteger versionNum = [settings integerForKey:@"VERSION_NUM"];
//    if(!versionNum) versionNum = 0;
//    
//    
//	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
//	picker.mailComposeDelegate = self;
//	
//	[picker setSubject:[NSString stringWithFormat:@"EYELEVEL Picture %i", versionNum]];
//	
//    
//	// Attach an image to the email
//    NSData *myData = UIImageJPEGRepresentation([m_EAGLView glViewToImage], 1.0);
//	[picker addAttachmentData:myData mimeType:@"image/jpg" fileName:[NSString stringWithFormat:@"buildingImage%i.jpg", versionNum]];
//	
//	// Fill out the email body text
//	NSString *emailBody = [m_CameraController description];
//	[picker setMessageBody:emailBody isHTML:NO];
//	
//	[self presentViewController:picker animated:YES completion:nil];
//	// [picker release];
//    
//    [settings setInteger:versionNum + 1 forKey:@"VERSION_NUM"];
//    [settings synchronize];
//    
//}
//
//
//// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
//- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
//{
//	
//	[self dismissViewControllerAnimated:YES completion:nil];
//    m_renderCameraFeed = !m_LockButton.selected;
//}
//
//
//#pragma mark -
//#pragma mark Workaround
//
//// Launches the Mail application on the device.
//-(void)launchMailAppOnDevice
//{
//    [[[UIAlertView alloc] initWithTitle: @"Error"
//                                 message: @"An e-mail account is not setup on this phone.  Please go into your phone's maill app and set an account up."
//                                delegate: nil
//                       cancelButtonTitle: @"Dismiss"
//                       otherButtonTitles: nil]  show];
//}
//
//
//-(IBAction) emailIt:(id)sender
//{
//    [sender setSelected:YES];
//    
//	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
//	if (mailClass != nil)
//	{
//		// We must always check whether the current device is configured for sending emails
//		if ([mailClass canSendMail])
//		{
//			[self displayComposerSheet];
//		}
//		else
//		{
//			[self launchMailAppOnDevice];
//		}
//	}
//	else
//	{
//		[self launchMailAppOnDevice];
//	}
//    [sender setSelected:NO];
//}
//
//
//-(IBAction)rightButtonPressed:(id)sender
//{
//    // [self lockGPSUpdates];
//    
//    ///switched to move left
//    [m_CameraController moveRight:-MOVE_AMOUNT];
//}
//
//-(IBAction)backwardButtonPressed:(id)sender
//{
//    // [self lockGPSUpdates];
//    
//    //switched to move forward
//    [m_CameraController moveForward:MOVE_AMOUNT];
//}
//
//-(IBAction)upButtonPressed:(id)sender
//{
//    [self unlockCameraChanges];
//    [m_CameraController moveUp:MOVE_AMOUNT];
//    [m_heightOutput setText:[NSString stringWithFormat:@"%.2f", [m_CameraController getHeightAdjustments]]];
//}
//
//-(IBAction)downButtonPressed:(id) sender
//{
//    [self unlockCameraChanges];
//    [m_CameraController moveUp:-MOVE_AMOUNT];
//    [m_heightOutput setText:[NSString stringWithFormat:@"%.2f", [m_CameraController getHeightAdjustments]]];
//    
//}
//
//-(IBAction) resetCameraLock:(id)sender
//{
//    if(m_resetButton.selected == NO)
//    {
//        [self unlockCameraChanges];
//    }
//    else
//    {
//        [m_CameraController lockManualAdjustments:YES];
//        [m_CameraController resetAdjustments];
//        [m_heightOutput setText:@"0.00"];
//        m_resetButton.selected = NO;
//    }
//    [m_rotateLeftButton setHidden:!m_resetButton.selected];
//    [m_rotateRightButton setHidden:!m_resetButton.selected];
//    [m_upButton setHidden:!m_resetButton.selected];
//    [m_downButton setHidden:!m_resetButton.selected];
//    [m_heightOutput setHidden:!m_resetButton.selected];
//}
//
//-(IBAction)rotateLeftPressed:(id)sender
//{
//    
//    //switched to rotate right
//    [self unlockCameraChanges];
//    [m_CameraController adjustYaw:-DEG_2_RAD*0.5];
//}
//
//-(IBAction)rotateRightPressed:(id)sender
//{
//    //switched to rotate left
//    [self unlockCameraChanges];
//    [m_CameraController adjustYaw:DEG_2_RAD*0.5];
//}
//
//
//-(IBAction)cameraButtonPressed:(id)sender
//{
//    CATransition *animation = [CATransition animation];
//    animation.type = @"cameraIris";
//    animation.duration = 2.0f;
//    
//    [self.view.layer addAnimation:animation forKey:@"transitionViewAnimation"];
//    
//    UIImage* glImage = [m_EAGLView glViewToImage];
//    
//    Vector3 cameraWorldPos = [m_CameraController getPosition] ;
//    Vector3 cameraGeographicPos = Vector3::worldCoordToGeographicCoord(cameraWorldPos);
//    
//    //glImage = [self addText:glImage text:[NSString stringWithFormat:@"Latitude %f, Longitude %f, Altitude %f",cameraGeographicPos.z, cameraGeographicPos.x, cameraGeographicPos.y] x:4 y:52];
//    // glImage = [self addText:glImage text:[NSString stringWithFormat:@"Bearing %d, Pitch %d", (int)RAD_2_DEG( [m_CameraController getYaw] ), (int)RAD_2_DEG( [m_CameraController getPitch] )] x:4 y:42];
//    
//    UIImageWriteToSavedPhotosAlbum(glImage, self, nil, nil);
//}
//
//
//
//-(IBAction) lockGyroscopePressed:(id)sender
//{
//    bool currentlySelected = [sender isSelected];
//    
//    [m_CameraController setUseGyroscope:currentlySelected];
//    
//    m_renderCameraFeed = currentlySelected;
//    //if(currentlySelected == YES) [m_CameraController applyYawReset];
//    
//    [sender setSelected:!currentlySelected];
//}
//
//-(IBAction) informationButtonPressed:(UIButton*)sender
//{
//    bool currentlySelected = [sender isSelected];
//    
//    [sender setSelected:!currentlySelected];
//    [m_YawResetButton setHidden:currentlySelected];
//    [m_FOVDecrementButton setHidden:currentlySelected];
//    [m_FOVIncrementButton setHidden:currentlySelected];
//    [m_FOVAmount setHidden:currentlySelected];
//    if(m_resetButton.selected == YES)
//    {
//        [m_rotateLeftButton setHidden:!currentlySelected];
//        [m_rotateRightButton setHidden:!currentlySelected];
//    }
//    
//    [m_CameraOutputPane setHidden:currentlySelected];
//    
//}
//
//-(IBAction) avButtonPressed:(id)sender
//{
//    UIButton* avButton = (UIButton*)sender;
//    [EAGLView changeRenderMode];
//    [avButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_avr%i.png", Renderable::getRenderMode()]] forState: UIControlStateNormal];
//    
//    //[avButton setImage:downImage forState: UIControlStateSelected];
//    [avButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_avr%i_on.png", Renderable::getRenderMode()]] forState: UIControlStateHighlighted];
//    
//}
//
//-(void)SurroundingBuildingsVisible:(BOOL)vis
//{
//    for( NSValue* value in m_SurroundingBuildings )
//    {
//        RenderableInstance* modelInstance = ((RenderableInstance*)value.pointerValue);
//        modelInstance->setVisible(!vis);
//    }
//    
//}
//
//-(IBAction) hideBuildingButtonPressed:(id)sender
//{
//    UIButton* avButton = (UIButton*)sender;
//    [self SurroundingBuildingsVisible:!avButton.selected];
//    
//    avButton.selected = !avButton.selected;
//}
//
//
//
//-(IBAction) increaseFOV:(id)sender
//{
//    int fov = [[m_FOVAmount text] intValue];
//    fov += 1;
//    [m_FOVAmount setText:[NSString stringWithFormat:@"%d", fov]];
//    
//    [m_EAGLView setSceneFOV:fov];
//}
//
//-(IBAction) decreaseFOV:(id)sender
//{
//    int fov = [[m_FOVAmount text] intValue];
//    fov -= 1;
//    [m_FOVAmount setText:[NSString stringWithFormat:@"%d", fov]];
//    
//    [m_EAGLView setSceneFOV:fov];
//}
//
//-(IBAction) applyYawReset:(id)sender
//{
//    [m_CameraController applyYawReset];
//}
//
//
//-(IBAction) swapModel:(id)sender
//{
//    
//    ++modelNumber;
//    
//    int highestModelCount = 0;
//    for( EyeLevelAsset* asset in [[EyeLevelAssetManager sharedInstance] getAssets] )
//	{
//        if([asset getModelCount] > highestModelCount)
//        {
//            highestModelCount = [asset getModelCount];
//        }
//    }
//    
//    if(highestModelCount <= 1) return;
//    [m_EAGLView removeRenderables];
//    if(modelNumber >= highestModelCount) modelNumber = 0;
//    
//    for( EyeLevelAsset* asset in [[EyeLevelAssetManager sharedInstance] getAssets] )
//	{
//        if([asset getModelCount] > modelNumber)
//        {
//            GLModel* model = [asset getModelForModelNum:modelNumber];
//            [m_EAGLView addRenderable:model];
//        }
//        else
//        {
//            GLModel* model = [asset getModelForModelNum:[asset getModelCount] - 1];
//            [m_EAGLView addRenderable:model];
//            
//        }
//    }
//    
//    
//    for( NSValue* value in m_SurroundingBuildings )
//    {
//        RenderableInstance* modelInstance = ((RenderableInstance*)value.pointerValue);
//        [m_EAGLView addRenderable:modelInstance];
//    }
//}
//
//@end
