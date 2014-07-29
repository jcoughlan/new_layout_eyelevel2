//
//  MZViewController.m
//  Xcode5Example
//
//  Created by Michał Zaborowski on 13.08.2013.
//  Copyright (c) 2013 Michał Zaborowski. All rights reserved.
//

#import "MZViewController.h"
#import "MZFormSheetController.h"
#import "MZCustomTransition.h"
#import "MZModalViewController.h"
#import "MZFormSheetSegue.h"

@interface MZViewController () <MZFormSheetBackgroundWindowDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
    [[MZFormSheetBackgroundWindow appearance] setBlurRadius:5.0];
    [[MZFormSheetBackgroundWindow appearance] setBackgroundColor:[UIColor clearColor]];
    
    [MZFormSheetController registerTransitionClass:[MZCustomTransition class] forTransitionStyle:MZFormSheetTransitionStyleCustom];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"formSheet"]) {
        MZFormSheetSegue *formSheetSegue = (MZFormSheetSegue *)segue;
        MZFormSheetController *formSheet = formSheetSegue.formSheetController;
        formSheet.transitionStyle = MZFormSheetTransitionStyleBounce;
        formSheet.cornerRadius = 8.0;
        formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
            
        };
        
        formSheet.shouldDismissOnBackgroundViewTap = YES;
        
        formSheet.didPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
            
        };
    }
}

- (IBAction)showFormSheet:(UIButton *)sender
{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"modal"];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    //set the size of the camera preview
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    UIInterfaceOrientation orientation = self.interfaceOrientation;
    
    //different for portrait and landscape
    if (orientation == UIInterfaceOrientationPortrait || orientation ==  UIInterfaceOrientationPortraitUpsideDown)
        formSheet.presentedFormSheetSize = CGSizeMake(screenBounds.size.width* 0.9f, screenBounds.size.height*0.9f);
    else
        formSheet.presentedFormSheetSize = CGSizeMake(screenBounds.size.height* 0.9f, screenBounds.size.width*0.9f);
    
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.8;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVertically = YES;
    formSheet.preferredContentSize =CGSizeMake(screenBounds.size.width* 0.9f, screenBounds.size.height*0.9f);
    
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    
    __weak MZFormSheetController *weakFormSheet = formSheet;
    
    
    // If you want to animate status bar use this code
    formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
        UINavigationController *navController = (UINavigationController *)weakFormSheet.presentedFSViewController;
        if ([navController.topViewController isKindOfClass:[MZModalViewController class]]) {
            MZModalViewController *mzvc = (MZModalViewController *)navController.topViewController;
            mzvc.showStatusBar = NO;
        }
        
        
        [UIView animateWithDuration:0.3 animations:^{
            if ([weakFormSheet respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
                [weakFormSheet setNeedsStatusBarAppearanceUpdate];
            }
        }];
    };
    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
        // Passing data
        UINavigationController *navController = (UINavigationController *)presentedFSViewController;
        navController.topViewController.title = @"Augmented Reality";
        
        //transparent navbar
        [ navController.topViewController.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        navController.topViewController.navigationController.navigationBar.shadowImage = [UIImage new];
        navController.topViewController.navigationController.navigationBar.translucent = YES;
    };
    formSheet.transitionStyle = MZFormSheetTransitionStyleCustom;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent; // your own style
}

- (BOOL)prefersStatusBarHidden {
    return NO; // your own visibility code
}

- (void)formSheetBackgroundWindow:(MZFormSheetBackgroundWindow *)formSheetBackgroundWindow didChangeStatusBarToOrientation:(UIInterfaceOrientation)orientation
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)formSheetBackgroundWindow:(MZFormSheetBackgroundWindow *)formSheetBackgroundWindow didChangeStatusBarFrame:(CGRect)newStatusBarFrame
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)formSheetBackgroundWindow:(MZFormSheetBackgroundWindow *)formSheetBackgroundWindow didRotateToOrientation:(UIDeviceOrientation)orientation animated:(BOOL)animated
{
    NSLog(@"%@",NSStringFromSelector(_cmd)); 
}

@end
