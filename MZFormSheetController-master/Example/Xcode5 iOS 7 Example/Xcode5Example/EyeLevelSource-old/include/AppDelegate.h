//
//  BubblePixAppDelegate.h
//  BubblePix
//
//  Created by Jamie Stewart on 21/04/11.
//  Copyright 2011 Fluid Pixel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : NSObject <UIApplicationDelegate>
{
	UIWindow* window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

+ (AppDelegate*)shareDelegate;

@end
