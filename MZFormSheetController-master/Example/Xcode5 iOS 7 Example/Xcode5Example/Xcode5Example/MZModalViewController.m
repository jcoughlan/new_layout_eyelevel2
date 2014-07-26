//
//  MZModalViewController.m
//  Xcode5Example
//
//  Created by Michał Zaborowski on 13.08.2013.
//  Copyright (c) 2013 Michał Zaborowski. All rights reserved.

#import "MZModalViewController.h"
#import "MZFormSheetController.h"


@interface MZModalViewController ()

@end

@implementation MZModalViewController

@synthesize stillImageOutput, UIImageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //crank up the camera view
    [self initializeCamera];
    FrontCamera = NO;
    fullScreen = NO;
    isPortrait= NO;
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        isPortrait = YES;
}


- (void)orientationChanged:(NSNotification *)notification{
    [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void) adjustViewsForOrientation:(UIInterfaceOrientation) orientation {
    
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        //load the portrait view
         isPortrait = YES;
        NSLog(@"Going to portrait");
        if (fullScreen)
        {
           
            MZFormSheetController *formSheet = self.navigationController.formSheetController;
            CGRect screenBounds = [[UIScreen mainScreen] bounds];
            formSheet.presentedFormSheetSize = CGSizeMake(screenBounds.size.width, screenBounds.size.height);
            [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
                
            }];
        }
        else
        {
            MZFormSheetController *formSheet = self.navigationController.formSheetController;
            CGRect screenBounds = [[UIScreen mainScreen] bounds];
            formSheet.presentedFormSheetSize = CGSizeMake(screenBounds.size.width* 0.9f, screenBounds.size.height*0.9f);
            [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
                
            }];
        }
    }
    else if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
    {
        //load the landscape view
        isPortrait = NO;
        NSLog(@"Going to landscape");
        if (fullScreen)
        {
            MZFormSheetController *formSheet = self.navigationController.formSheetController;
            CGRect screenBounds = [[UIScreen mainScreen] bounds];
            formSheet.presentedFormSheetSize = CGSizeMake(screenBounds.size.height, screenBounds.size.width);
            [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
                
            }];
        }
        else
        {
            MZFormSheetController *formSheet = self.navigationController.formSheetController;
            CGRect screenBounds = [[UIScreen mainScreen] bounds];
            formSheet.presentedFormSheetSize = CGSizeMake(screenBounds.size.height* 0.9f, screenBounds.size.width*0.9f);
            [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
                
            }];
        }
    }
}


//AVCaptureSession to show live video feed in view
- (void) initializeCamera {
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
	session.sessionPreset = AVCaptureSessionPresetPhoto;
    
	AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
	captureVideoPreviewLayer.frame = self.UIImageView.bounds;
	[self.UIImageView.layer addSublayer:captureVideoPreviewLayer];
    
    UIView *view = [self UIImageView];
    CALayer *viewLayer = [view layer];
    [viewLayer setMasksToBounds:YES];
    
    CGRect bounds = [view bounds];
    [captureVideoPreviewLayer setFrame:bounds];
    
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    
    for (AVCaptureDevice *device in devices) {
        
        NSLog(@"Device name: %@", [device localizedName]);
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            
            if ([device position] == AVCaptureDevicePositionBack) {
                NSLog(@"Device position : back");
                backCamera = device;
            }
            else {
                NSLog(@"Device position : front");
                frontCamera = device;
            }
        }
    }
    
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
    /*We add input and output*/
    if ([session canAddInput: input])
        [session addInput:input];
    else{
        //if we have no camera, bail (should only happen on simulator)
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No Camera Detected" message:@"It appears your device does not have a functioning camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        return;
    }
   // [session addInput:input];
    
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
    
	[session startRunning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Access to form sheet controller
    MZFormSheetController *controller = self.navigationController.formSheetController;
    controller.shouldDismissOnBackgroundViewTap = YES;
    
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.showStatusBar = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [self.navigationController.formSheetController setNeedsStatusBarAppearanceUpdate];
        
    }];
    
}

- (void) OnExpandButtonClicked:(id)sender
{
    
    MZFormSheetController *formSheet = self.navigationController.formSheetController;
    if (isPortrait)
    {
        if (fullScreen)
        {
            //set the size o fthe camera preview
            
            CGRect screenBounds = [[UIScreen mainScreen] bounds];
            
            formSheet.presentedFormSheetSize = CGSizeMake(screenBounds.size.width* 0.9f, screenBounds.size.height*0.9f);
            
            [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
                
            }];
            fullScreen = NO;
        }
        else{
            
            //set the size o fthe camera preview
            CGRect screenBounds = [[UIScreen mainScreen] bounds];
            
            formSheet.presentedFormSheetSize = CGSizeMake(screenBounds.size.width, screenBounds.size.height);        formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
            
            [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
                
            }];
            fullScreen = YES;
        }
    }
    else{
        if (fullScreen)
        {
            //set the size o fthe camera preview
            
            CGRect screenBounds = [[UIScreen mainScreen] bounds];
            
            formSheet.presentedFormSheetSize = CGSizeMake(screenBounds.size.height* 0.9f, screenBounds.size.width*0.9f);
            
            [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
                
            }];
            fullScreen = NO;
        }
        else{
            
            //set the size o fthe camera preview
            CGRect screenBounds = [[UIScreen mainScreen] bounds];
            
            formSheet.presentedFormSheetSize = CGSizeMake(screenBounds.size.height, screenBounds.size.width);        formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
            
            [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
                
            }];
            fullScreen = YES;
        }

    }
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent; // your own style
}

- (BOOL)prefersStatusBarHidden {
    return self.showStatusBar; // your own visibility code
}

@end
