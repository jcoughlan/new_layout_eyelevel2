//
//  CLLocationCoordinate2D+OSGB.h
//  EyeLevel
//
//  Created by Apple on 06/12/2011.
//  Copyright (c) 2011 Fluid Pixel. All rights reserved.
//
// Contains Methods to converting between WGS84 coordinates (used by mapkit) and OSGB36 coordinates.


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#include "Vector3.h"
#include "Vector2.h"

@interface CLLocationCoordinate2D_OSGB  : NSObject
{
    NSDictionary* ellipse;
    NSDictionary* helmert;
}

//Converts a OSGB36 Location to its long/lat equivelent
-(CLLocationCoordinate2D) OSGB36locationFromOSGB36Grid: (Vector2) osGrid;

//Converts a OSGB36 long/lat coordinate to ins location
-( Vector3 ) OSGB36GridFromOSGB36Location:(CLLocationCoordinate2D)location;

-( Vector3 ) OSGB36GridFromWGS84Location:(CLLocationCoordinate2D) location;

//Converts a OSGB36 long/lat coordinate to its WGS84 Counterpart
-(CLLocationCoordinate2D) convertOSGB36toWGS84: (CLLocationCoordinate2D) p1;

//Converts a WGS84 long/lat coordinate to its OSGB36 CounterPart
-(CLLocationCoordinate2D) convertWGS84toOSGB36: (CLLocationCoordinate2D) p1;
@end
