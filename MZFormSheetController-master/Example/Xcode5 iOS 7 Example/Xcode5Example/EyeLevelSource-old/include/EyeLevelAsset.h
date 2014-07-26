//
//  EyeLevelAsset.h
//  EyeLevel
//
//  Created by Apple on 16/11/2011.
//  Copyright (c) 2011 Fluid Pixel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>
#include "GLModel.h"

@class ZipFile;


@interface EyeLevelAsset : NSObject<MKAnnotation>
{
	GLModel*                                models[40];
	GLModel*								surroundingModel;
    NSString* objectPath[40];
    NSArray* modelPoints;
    int                                     modelCount;
}

@property( nonatomic, assign )          CLLocationCoordinate2D coordinate;
@property( nonatomic, copy )            NSString*	title;
@property( nonatomic, retain )          NSString*	thumbnailPath;
@property( nonatomic, retain )          NSString*	objPath;
@property( nonatomic, retain )          NSString*	surroundingOBJPath;
@property( nonatomic, retain )          NSString*	textureMapPath;
 


-(id) initWithELVFile:(NSString*)elvFilePath;
+(EyeLevelAsset*) eyeLevelAssetFromELVFile:(NSString*)elvFilePath;

-(GLModel*) getModelForModelNum:(int)modelNum;
-(GLModel*) getSurroundingModel;
-(Vector3) getVerticiesFor:(int)index modelNumber:(int)modNum;
-(int) getNumberOfcornersForModelNumber:(int)modNum;
-(int) getModelCount;

@end
