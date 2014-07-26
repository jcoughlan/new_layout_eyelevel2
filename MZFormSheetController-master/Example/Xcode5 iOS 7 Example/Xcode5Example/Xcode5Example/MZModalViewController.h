//
//  MZModalViewController.h
//  Xcode5Example
//
//  Created by Michał Zaborowski on 13.08.2013.
//  Copyright (c) 2013 Michał Zaborowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
//\These are all the headers we need to save/create and capture camera input from the device

@interface MZModalViewController : UIViewController
{
    BOOL FrontCamera;
    BOOL haveImage;
    BOOL fullScreen;
    BOOL isPortrait;
}
- (IBAction)OnExpandButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *expandButton;
@property (nonatomic, retain) AVCaptureStillImageOutput * stillImageOutput;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageView;
@property (nonatomic, assign) BOOL showStatusBar;
@end
