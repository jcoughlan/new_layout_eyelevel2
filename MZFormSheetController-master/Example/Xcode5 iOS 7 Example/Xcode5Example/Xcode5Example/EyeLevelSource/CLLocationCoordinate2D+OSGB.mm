//
//  CLLocationCoordinate2D+OSGB.m
//  EyeLevel
//
//  Created by Apple on 06/12/2011.
//  Copyright (c) 2011 Fluid Pixel. All rights reserved.
//

#import "CLLocationCoordinate2D+OSGB.h"
#import "Vector3.h"

@interface CLLocationCoordinate2D_OSGB(Private)
-(CLLocationCoordinate2D) convert: (CLLocationCoordinate2D) p1 withSourceEllipse: (NSDictionary *) e1 withTransform: (NSDictionary *) t withTargetEllipse: (NSDictionary *) e2;
@end

@implementation CLLocationCoordinate2D_OSGB 

-(id) init
{
    self = [super init];
    
    if( self )
    {
        // Define the conversion constants
        NSDictionary *wgs84 = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects: [NSNumber numberWithDouble: 6378137.0], [NSNumber numberWithDouble: 6356752.3142], [NSNumber numberWithDouble: (1.0 / 298.257223563)], nil] 
                                                          forKeys: [NSArray arrayWithObjects: @"a", @"b", @"f", nil]];
        NSDictionary *airy1830 = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects: [NSNumber numberWithDouble: 6377563.396], [NSNumber numberWithDouble: 6356256.910], [NSNumber numberWithDouble: (1.0 / 299.3249646)], nil] 
                                                             forKeys: [NSArray arrayWithObjects: @"a", @"b", @"f", nil]];
        
        // Create the ellipse set
        ellipse = [[NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects: wgs84, airy1830, nil] 
                                               forKeys: [NSArray arrayWithObjects: @"WGS84", @"Airy1830", nil]] retain];
        
        // Transformation constants
        NSDictionary *hWGS84toOSGB36 = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects: 
                                                                             [NSNumber numberWithDouble: -446.448], 
                                                                             [NSNumber numberWithDouble: 125.157], 
                                                                             [NSNumber numberWithDouble: -542.060], 
                                                                             [NSNumber numberWithDouble: -0.1502], 
                                                                             [NSNumber numberWithDouble: -0.2470], 
                                                                             [NSNumber numberWithDouble: -0.8421], 
                                                                             [NSNumber numberWithDouble: 20.4894], nil] 
                                                                   forKeys: [NSArray arrayWithObjects: @"tx", @"ty", @"tz", @"rx", @"ry", @"rz", @"s", nil]];
        
        NSDictionary *hOSGB36toWGS84 = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects: 
                                                                             [NSNumber numberWithDouble: 446.448], 
                                                                             [NSNumber numberWithDouble: -125.157], 
                                                                             [NSNumber numberWithDouble: 542.0600], 
                                                                             [NSNumber numberWithDouble: 0.1502], 
                                                                             [NSNumber numberWithDouble: 0.2470], 
                                                                             [NSNumber numberWithDouble: 0.8421], 
                                                                             [NSNumber numberWithDouble: -20.4894], nil] 
                                                                   forKeys: [NSArray arrayWithObjects: @"tx", @"ty", @"tz", @"rx", @"ry", @"rz", @"s", nil]];
        
        // Create the helmert set
        helmert = [[NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects: hWGS84toOSGB36, hOSGB36toWGS84, nil] 
                                               forKeys: [NSArray arrayWithObjects: @"WGS84toOSGB36", @"OSGB36toWGS84", nil]] retain];
    }
    
    return self;
}

-(void) dealloc
{
    [ellipse release];
    [helmert release];
    
    [super dealloc];
}


-( Vector3 ) OSGB36GridFromWGS84Location:(CLLocationCoordinate2D) location
{
    return [self OSGB36GridFromOSGB36Location:[self convertWGS84toOSGB36:location]];
}

-( Vector3 ) OSGB36GridFromOSGB36Location:(CLLocationCoordinate2D)location
{
    double latitude = location.latitude * DEG_2_RAD;
    double longitude = location.longitude * DEG_2_RAD;

    // double a = 6378137.0, b = 6356752.3142; // Airy 1830 major & minor semi-axes
    double a = 6377563.396, b = 6356256.910; // Airy 1830 major & minor semi-axes
    double F0 = 0.9996012717; // NatGrid scale factor on central meridian
    double lat0 = DEG_2_RAD * 49;
    double lon0 = DEG_2_RAD * -2; // NatGrid true origin
    double N0 = -100000, E0 = 400000; // northing & easting of true origin, metres
    double e2 = 1 - (b * b) / (a * a); // eccentricity squared
    double n = (a - b) / (a + b), n2 = n * n, n3 = n * n * n;
    
    double cosLat = cos(latitude), sinLat = sin(latitude);
    double nu = a * F0 / sqrt(1 - e2 * sinLat * sinLat) ; // transverse radius of curvature
    double rho = a * F0 * (1 - e2) / pow(1 - e2 * sinLat * sinLat, 1.5); // meridional radius of curvature
    
    double eta2 = nu / rho - 1;
    
    double Ma = (1 + n + (5 / 4) * n2 + (5 / 4) * n3) * (latitude - lat0);
    double Mb = (3 * n + 3 * n * n + (21 / 8) * n3) * sin(latitude - lat0) * cos(latitude + lat0);
    double Mc = ((15 / 8) * n2 + (15 / 8) * n3) * sin(2 * (latitude - lat0)) * cos(2 * (latitude + lat0));
    double Md = (35 / 24) * n3 * sin(3 * (latitude - lat0)) * cos(3 * (latitude + lat0));
    double M = b * F0 * (Ma - Mb + Mc - Md); // meridional arc
    
    double cos3lat = cosLat * cosLat * cosLat;
    double cos5lat = cos3lat * cosLat * cosLat;
    double tan2lat = tan(latitude) * tan(latitude);
    double tan4lat = tan2lat * tan2lat;
    
    double I = M + N0;
    double II = (nu / 2) * sinLat * cosLat;
    double III = (nu / 24) * sinLat * cos3lat * (5 - tan2lat + 9 * eta2);
    double IIIA = (nu / 720) * sinLat * cos5lat * (61 - 58 * tan2lat + tan4lat);
    double IV = nu * cosLat;
    double V = (nu / 6) * cos3lat * (nu / rho - tan2lat);
    double VI = (nu / 120) * cos5lat * (5 - 18 * tan2lat + tan4lat + 14 * eta2 - 58 * tan2lat * eta2);
    
    double dLon = longitude - lon0;
    double dLon2 = dLon * dLon, dLon3 = dLon2 * dLon, dLon4 = dLon3 * dLon, dLon5 = dLon4 * dLon, dLon6 = dLon5 * dLon;
    
    double N = I + II * dLon2 + III * dLon4 + IIIA * dLon6;
    double E = E0 + IV * dLon + V * dLon3 + VI * dLon5;
    
    return Vector3(E,0,-N);
}

// Converts an OS Grid reference to a lat/long location
-(CLLocationCoordinate2D) OSGB36locationFromOSGB36Grid: (Vector2) osGrid
{
 double eastings = osGrid[0];
    double northings = osGrid[1];
    
    double a = 6377563.396;
    double b = 6356256.910;
    
    double f0 = 0.9996012717;
    
    double lat0 = 49.0 * M_PI / 180.0;
    double lon0 = -2.0 * M_PI / 180.0;
    double n0 = -100000.0;
    double e0 = 400000.0;
    
    double e2 = 1.0 - (b * b) / (a * a);
    double n = (a - b) / (a + b);
    double n2 = n * n;
    double n3 = n * n * n;
    
    double lat = lat0;
    double M = 0.0;
    
    do 
    {
        lat = (northings - n0 - M) / (a * f0) + lat;
        
        double Ma = (1.0 + n + ((5.0/4.0) * n2) + ((5.0/4.0) * n3)) * (lat - lat0);
        double Mb = (3.0 * n + 3.0 * n * n + ((21.0/8.0) * n3)) * sin(lat-lat0) * cos(lat+lat0);
        double Mc = (((15.0/8.0) * n2) + ((15.0/8.0) * n3)) * sin(2.0 * (lat - lat0)) * cos(2.0 * (lat + lat0));
        double Md = (35.0/24.0) * n3 * sin(3.0 * (lat-lat0)) * cos(3.0 * (lat+lat0));
        M = b * f0 * (Ma - Mb + Mc - Md);
        
    } while (northings - n0 - M >= 0.0001);
    
    double cosLat = cos(lat);
    double sinLat = sin(lat);
    double nu = a * f0 / sqrt(1.0 - e2 * sinLat * sinLat);
    double rho = a * f0 * (1.0 - e2)/pow((1.0 - e2 * sinLat * sinLat), 1.5);
    double eta2 = nu / rho - 1.0;
    
    double tanLat = tan(lat);
    double tan2Lat = tanLat * tanLat;
    double tan4Lat = tan2Lat * tan2Lat;
    double tan6Lat = tan4Lat * tan2Lat;
    
    double secLat = 1.0 / cosLat;
    double nu3 = nu * nu * nu;
    double nu5 = nu3 * nu * nu;
    double nu7 = nu5 * nu * nu;
    
    double vii = tanLat / (2.0 * rho * nu);
    double viii = tanLat / (24.0 * rho * nu3) * (5.0 + 3.0 * tan2Lat + eta2 - 9.0 * tan2Lat * eta2);
    double ix = tanLat / (720.0 * rho * nu5) * (61.0 + 90.0 * tan2Lat + 45.0 * tan4Lat);
    double x = secLat / nu;
    double xi = secLat / (6.0 * nu3) * (nu/rho + 2.0 * tan2Lat);
    double xii = secLat / (120.0 * nu5) * (5.0 + 28.0 * tan2Lat + 24.0 * tan4Lat);
    double xiia = secLat / (5040.0 * nu7) * (61.0 + 662.0 * tan2Lat + 1320.0 * tan4Lat + 720.0 * tan6Lat);
    
    double dE = (eastings - e0);
    double dE2 = dE * dE;
    double dE3 = dE2 * dE;
    double dE4 = dE2 * dE2;
    double dE5 = dE3 * dE2;
    double dE6 = dE3 * dE3;
    double dE7 = dE3 * dE4;
    
    lat = lat - vii * dE2 + viii * dE4 - ix * dE6;
    double lon = lon0 + x * dE - xi * dE3 + xii * dE5 - xiia * dE7;
    
    // Convert to degrees
    lat = lat * 180.0 / M_PI;
    lon = lon * 180.0 / M_PI;
    
    // Return the 2D location
    return CLLocationCoordinate2DMake(lat, lon);
    
}

// Convert from OSGB36 to WGS84
-(CLLocationCoordinate2D) convertOSGB36toWGS84: (CLLocationCoordinate2D) p1 
{
    return [self convert: p1 withSourceEllipse: [ellipse objectForKey: @"Airy1830"] withTransform: [helmert objectForKey: @"OSGB36toWGS84"] withTargetEllipse: [ellipse objectForKey: @"WGS84"]];
}

// Convert from WGS84 to OSGB36
-(CLLocationCoordinate2D) convertWGS84toOSGB36: (CLLocationCoordinate2D) p1 {
    return [self convert: p1 withSourceEllipse: [ellipse objectForKey: @"WGS84"] withTransform: [helmert objectForKey: @"WGS84toOSGB36"] withTargetEllipse: [ellipse objectForKey: @"Airy1830"]];
}

// Transform from one ellipse to another
-(CLLocationCoordinate2D) convert: (CLLocationCoordinate2D) p1 withSourceEllipse: (NSDictionary *) e1 withTransform: (NSDictionary *) t withTargetEllipse: (NSDictionary *) e2 {
    
    double p1Lat = p1.latitude * M_PI / 180.0;
    double p1Lon = p1.longitude * M_PI / 180.0;
    
    double a = [[e1 objectForKey: @"a"] doubleValue];
    double b = [[e1 objectForKey: @"b"] doubleValue];
    
    double sinPhi = sin(p1Lat);
    double cosPhi = cos(p1Lat);
    
    double sinLambda = sin(p1Lon);
    double cosLambda = cos(p1Lon);
    double h = 0.0;
    
    double eSq = (a * a - b *b) / (a * a);
    double nu = a / sqrt(1.0 - eSq * sinPhi * sinPhi);
    
    double x1 = (nu + h) * cosPhi * cosLambda;
    double y1 = (nu + h) * cosPhi * sinLambda;
    double z1 = ((1.0 - eSq) * nu + h) * sinPhi;
    
    double tx = [[t objectForKey: @"tx"] doubleValue];
    double ty = [[t objectForKey: @"ty"] doubleValue];
    double tz = [[t objectForKey: @"tz"] doubleValue];
    
    double rx = [[t objectForKey: @"rx"] doubleValue] / 3600.0 * M_PI / 180.0;
    double ry = [[t objectForKey: @"ry"] doubleValue] / 3600.0 * M_PI / 180.0;
    double rz = [[t objectForKey: @"rz"] doubleValue] / 3600.0 * M_PI / 180.0;
    
    double s1 = [[t objectForKey: @"s"] doubleValue] / 1000000.0 + 1;
    
    double x2 = tx + x1*s1 - y1*rz + z1*ry;
    double y2 = ty + x1*rz + y1*s1 - z1*rx;
    double z2 = tz - x1*ry + y1*rx + z1*s1;
    
    a = [[e2 objectForKey: @"a"] doubleValue];
    b = [[e2 objectForKey: @"b"] doubleValue];
    
    double precision = 4 / a;
    
    eSq = (a*a - b*b) / (a*a);
    double p = sqrt(x2*x2 + y2*y2);
    double phi = atan2(z2, p*(1-eSq));
    double phiP = 2 * M_PI;
    
    while (abs(phi-phiP) > precision) {
        nu = a / sqrt(1 - eSq*sin(phi)*sin(phi));
        phiP = phi;
        phi = atan2(z2 + eSq*nu*sin(phi), p);
    }
    
    double lambda = atan2(y2, x2);
    h = p/cos(phi) - nu;
    
    phi = phi * 180.0 / M_PI;
    lambda = lambda * 180.0 / M_PI;
    
    return CLLocationCoordinate2DMake(phi, lambda);
}

@end
