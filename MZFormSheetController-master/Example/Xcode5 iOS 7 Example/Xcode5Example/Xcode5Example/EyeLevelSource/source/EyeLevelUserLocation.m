//
//  EyeLevelAnnotationViews.m
//  EyeLevel
//
//  Created by Apple on 17/11/2011.
//  Copyright (c) 2011 Fluid Pixel. All rights reserved.
//

#import "EyeLevelUserLocation.h"

@implementation EyeLevelUserLocation
@synthesize title, gpsLocation, manualLocation, delegate, manualPositioning;

-(id) init
{
    if( ( self = [super init] ) )
    {
        NSLog(@"init image for pin");
        self.title = @"Current Location";
        
        //start the location tracking
        m_pLocationManager = [[CLLocationManager alloc] init];
        if( [CLLocationManager locationServicesEnabled] )
        {
            [m_pLocationManager setDelegate: self];
            m_pLocationManager.headingFilter = kCLHeadingFilterNone;
            m_pLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
            m_pLocationManager.distanceFilter = 1;
            [m_pLocationManager startUpdatingLocation];
            [m_pLocationManager startUpdatingHeading];
        }
        else
        {
            NSLog(@"Error initialising Location Service, Handle this later");
        }
        
        self.manualPositioning = false;
    }
    
    return self;
}


#pragma mark - MKAnnotation


- (CLLocationCoordinate2D)coordinate
{
    //    NSLog(@"coordinate call");
    if( self.manualPositioning && self.manualLocation)
    {
        return self.manualLocation.coordinate;
    }
    else
    {
        if( self.gpsLocation )
        {
            return self.gpsLocation.coordinate;
        }
        else
        {
            return CLLocationCoordinate2DMake(0, 0);
        }
    }
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    NSLog(@"Setting eyelevelcoord: %f %f", newCoordinate.latitude, newCoordinate.longitude);
    CLLocation* newLocation = [[CLLocation alloc] initWithCoordinate:newCoordinate
                                                            altitude:self.gpsLocation.altitude
                                                  horizontalAccuracy:self.gpsLocation.horizontalAccuracy
                                                    verticalAccuracy:self.gpsLocation.verticalAccuracy
                                                           timestamp:[NSDate date]];
    
    if(newCoordinate.latitude != self.gpsLocation.coordinate.latitude && newCoordinate.longitude != self.gpsLocation.coordinate.longitude)
    {
        self.manualPositioning = YES;
        self.manualLocation = newLocation;
    }
    
    if( delegate )
        [delegate eyeLevelUserLocation:self didUpdateToLocation:newLocation];
    
}

#pragma mark - CLLocationManagerDelegateMethods
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if( !self.manualPositioning )
    {
        
        self.gpsLocation = newLocation;
        
        if( delegate )
            [delegate eyeLevelUserLocation:self didUpdateToLocation:newLocation];
    }
}


-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"Location manager failed big time: %@", error.localizedDescription );
	
	[[[UIAlertView alloc] initWithTitle: @"Error"
                                 message: @"Failed to locate your position. Is Location Services enabled? Are you underground?"
                                delegate: nil
                       cancelButtonTitle: @"Dismiss"
                       otherButtonTitles: nil] show];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
	NSLog(@"Authorization status for the application changed: %d", status );
}

@end