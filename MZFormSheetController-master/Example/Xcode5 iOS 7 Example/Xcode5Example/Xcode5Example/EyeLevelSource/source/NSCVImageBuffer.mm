//
//  NSCVImageBufferRef.m
//  VideoCaptureTest
//
//  Created by Jamie Stewart on 12/04/11.
//  Copyright 2011 Fluid Pixel. All rights reserved.
//

#import "NSCVImageBuffer.h"


@implementation NSCVImageBufferRef

-(id)initWithCVImageBufferRef:(CVImageBufferRef)imageRef
{
	self = [super init];
	if( self )
	{
		imageBuffer = CVPixelBufferRetain(imageRef);
	}
	return self;
}

-(CVImageBufferRef)getImageBufferRef
{ 
	return imageBuffer;
}

-(void)dealloc
{
	CVPixelBufferRelease(imageBuffer);
	[super dealloc];
}

@end
