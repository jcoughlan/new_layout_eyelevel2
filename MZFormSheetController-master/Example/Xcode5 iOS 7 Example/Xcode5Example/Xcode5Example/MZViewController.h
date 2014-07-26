//
//  MZViewController.h
//  Xcode5Example
//
//  Created by Michał Zaborowski on 13.08.2013.
//  Copyright (c) 2013 Michał Zaborowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MZViewController : UIViewController <MKMapViewDelegate>
- (IBAction)showFormSheet:(UIButton *)sender;
@end
