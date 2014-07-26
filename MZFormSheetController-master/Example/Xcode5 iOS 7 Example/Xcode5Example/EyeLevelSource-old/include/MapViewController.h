//
//  MapViewController.h
//  EyeLevel
//
//  Created by Apple on 15/11/2011.
//  Copyright (c) 2011 Fluid Pixel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "EyeLevelAssetManager.h"
#import "EyeLevelUserLocation.h"

@class UIVideoCaptureViewController;

@interface MapViewController : UIViewController <EyeLevelUserLocationDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, EyeLevelAssetManagerDelegate>
{
    NSMutableArray*                 m_AutoCompleteAssets;
    UIVideoCaptureViewController*   m_ARView;
    EyeLevelUserLocation*           m_UserLocation;
    BOOL                            m_InitialisedInitialZoom;
    BOOL                            m_InternetFailed;
}

@property( nonatomic, retain ) IBOutlet MKMapView*      mapView;
@property( nonatomic, retain ) IBOutlet UITableView*    autoCompleteTableView;
@property( nonatomic, retain ) IBOutlet UITextField*    searchField;
@property( nonatomic, retain ) IBOutlet UIView*         searchView;
@property( nonatomic, retain ) IBOutlet UIButton*       lockButton;
@property (retain, nonatomic) IBOutlet UIButton         *mapSwitchButton;

- (IBAction) lockButtonPressed:(id)sender;
- (IBAction) cameraButtonPressed:(id)sender;
- (IBAction) mapModeButtonPressed:(id)sender;
- (IBAction) showSearchMechanism:(id)sender;
- (IBAction) hideSearchMechanism:(id)sender;

@end
