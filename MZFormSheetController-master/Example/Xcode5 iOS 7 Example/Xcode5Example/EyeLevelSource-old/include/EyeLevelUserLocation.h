//
//  EyeLevelAnnotationViews.h
//  EyeLevel
//
//  Created by Apple on 17/11/2011.
//  Copyright (c) 2011 Fluid Pixel. All rights reserved.
//

#import <MapKit/MapKit.h>

@protocol EyeLevelUserLocationDelegate;


@interface EyeLevelUserLocation : NSObject<MKAnnotation, CLLocationManagerDelegate>
{
    CLLocationManager*              m_pLocationManager;
    
    CLLocationCoordinate2D          coordinate;

    id<EyeLevelUserLocationDelegate>   delegate;
}


@property( nonatomic )      BOOL    manualPositioning;
@property( nonatomic, assign )      id<EyeLevelUserLocationDelegate> delegate;
@property( nonatomic, readonly)     CLLocationCoordinate2D coordinate;
@property( nonatomic, copy )        NSString* title;
@property( nonatomic, retain )      CLLocation* gpsLocation;
@property( nonatomic, retain )      CLLocation* manualLocation;

@end



@protocol EyeLevelUserLocationDelegate
-(void) eyeLevelUserLocation:(EyeLevelUserLocation*)userLocation didUpdateToLocation:(CLLocation*)location;
@end