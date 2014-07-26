//
//  UIVideoCaptureViewController.h
//  BubblePix
//
//  Created by Jamie Stewart on 21/04/11.
//  Copyright 2011 Fluid Pixel. All rights reserved.
//

#define DISABLE_PREVIEW_VIEW 1

#import <UIKit/UIKit.h>
//\====================================================================================================
//\This is our OpenGLES View
#import "EAGLView.h"
#import "NSCVImageBuffer.h"
//\====================================================================================================
//\These are all the headers we need to save/create and capture camera input from the device
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import <AssetsLibrary/AssetsLibrary.h>
//\====================================================================================================

#import "ARCameraController.h"
#import "EyeLevelUserLocation.h"
#import "CLLocationCoordinate2D+OSGB.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

class RenderableInstance;

@interface UIVideoCaptureViewController : UIViewController < EyeLevelUserLocationDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate,MFMailComposeViewControllerDelegate  >
{
    //\==================================================
    //\ IBOutlets
    IBOutlet UIView*                m_EAGLParentView;
    IBOutlet UILabel*               m_CameraOutputPane;
    IBOutlet UILabel*               m_heightOutput;
    IBOutlet UIButton*              m_LockButton;
    IBOutlet UILabel*               m_RotatedBuildingAmount;
    IBOutlet UILabel*               m_FOVAmount;
    IBOutlet UIButton*              m_FOVDecrementButton;
    IBOutlet UIButton*              m_FOVIncrementButton;
    IBOutlet UIButton*              m_YawResetButton;
    IBOutlet UIButton*              m_rotateLeftButton;
    IBOutlet UIButton*              m_rotateRightButton;
    IBOutlet UIButton*              m_resetButton;
    IBOutlet UIButton*              m_upButton;
    IBOutlet UIButton*              m_downButton;
	//\==================================================
	//\The EAGLView - this contains the OpenGLES context
	EAGLView*						m_EAGLView;

	
    //\==================================================
	//\AVCapture Variables
	AVCaptureSession*				m_CaptureSession;
    AVCaptureStillImageOutput*		m_stillImageCaptureOutput;
    AVCaptureVideoDataOutput*		m_videoCaptureOutput;

	//\==================================================
    ARCameraController*             m_CameraController;
    CLLocationCoordinate2D_OSGB*    m_CoordinateConverter;
    
    NSMutableArray*                 m_Buildings;
    NSMutableArray*                 m_SurroundingBuildings;
    
    //\==================================================
    BOOL                            m_bIsAsyncLoadingAssets;
    
    Vector3 previousPos;
    BOOL animateCameraNextTime;
    BOOL m_renderCameraFeed;
    
    int modelNumber;
}
@property( nonatomic, retain ) IBOutlet UIView* horizontalSpiritLevelMarker;
@property( nonatomic, retain ) IBOutlet UIView* verticalSpiritLevelMarker;
//\======================================================
//\Initialise the CoreVideo bits and pieces needed to capture video feed
-(void)initDeviceInputCapture;

//\======================================================
-(void)startCaptureSession;
-(void)endCaptureSession;
//\======================================================
-(void)sendBufferToGLRenderer:(NSCVImageBufferRef*)imageBuffer;
-(void)writeImageToPhotoLibrary:(UIImage*)image;
-(void)captureStillImage;
-(void)SurroundingBuildingsVisible:(BOOL)vis;
-(void)resetCameraAnimation;
-(void) unlockCameraChanges;
//\======================================================
-(IBAction) forwardButtonPressed:(id)sender;
-(IBAction) leftButtonPressed:(id)sender;
-(IBAction) rightButtonPressed:(id)sender;
-(IBAction) backwardButtonPressed:(id)sender;
-(IBAction) backwardButtonPressed:(id)sender;
-(IBAction) upButtonPressed:(id)sender;
-(IBAction) downButtonPressed:(id) sender;
-(IBAction) rotateLeftPressed:(id)sender;
-(IBAction) rotateRightPressed:(id)sender;
-(IBAction) resetCameraPosition:(id)sender;
-(IBAction) cameraButtonPressed:(id)sender;
-(IBAction) lockGyroscopePressed:(id)sender;
-(IBAction) informationButtonPressed:(id)sender;
-(IBAction) increaseFOV:(id)sender;
-(IBAction) decreaseFOV:(id)sender;
-(IBAction) swapModel:(id)sender;

-(IBAction) emailIt:(id)sender;

-(IBAction) hideBuildingButtonPressed:(id)sender;
-(IBAction) avButtonPressed:(id)sender;
-(IBAction) applyYawReset:(id)sender;
-(IBAction) mapButtonPressed:(id)sender;
-(IBAction) resetCameraLock:(id)sender;

@end
