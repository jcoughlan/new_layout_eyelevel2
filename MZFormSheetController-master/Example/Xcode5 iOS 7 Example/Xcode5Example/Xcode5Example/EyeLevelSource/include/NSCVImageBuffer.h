//
//  NSCVImageBufferRef.h
//  VideoCaptureTest
//  Created by Jamie Stewart on 12/04/11.
//  Copyright 2011 Fluid Pixel. All rights reserved.
//

//	Wrapping a CVImageBufferRef up in an NSObject to get it to comply with NSObjects etc

#import <Foundation/Foundation.h>
#import <CoreVideo/CoreVideo.h>

@interface NSCVImageBufferRef : NSObject 
{
	CVImageBufferRef imageBuffer;
}

-(id)initWithCVImageBufferRef:(CVImageBufferRef)imageRef;
-(CVImageBufferRef)getImageBufferRef;

@end
