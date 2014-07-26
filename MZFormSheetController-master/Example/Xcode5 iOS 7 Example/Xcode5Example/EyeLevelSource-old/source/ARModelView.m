//
//  ARPointView.m
//  PocketTours
//
//  Created by Jamie Stewart on 27/04/11.
//  Copyright 2011 Fluid Pixel. All rights reserved.
//
#import "AppDelegate.h"
#import "ARModelView.h"
#import "UIColor+Tools.h"
#import "ImageLoader.h"
#import "UIMapCalloutStandView.h"
#import "XMLReader.h"

@implementation ARModelView

@synthesize gradientStartColor = _gradientStartColor;
@synthesize gradientEndColor = _gradientEndColor;

-(id)initWithGLCube:(GLCube*)cube andData:(NSDictionary*)markerData
{
	if( (self = [super init]) )
	{
		[self setFrame:CGRectMake(0, 0, 88, 88)];
    
        m_Cube = cube;
		
		_gradientLayer = [[CAGradientLayer alloc] init];
        _gradientLayer.bounds = self.bounds;
        
        _gradientLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        
        [self.layer insertSublayer:_gradientLayer atIndex:0];
		
		m_markerColor = [mapPin getColor];
		[self setGradientStartColor:m_markerColor];
		[self setGradientEndColor:[m_markerColor colorByDarkeningColor:0.7]];
		[self setBackgroundColor:m_markerColor];
		
		m_markerData = [[NSDictionary alloc] initWithDictionary:markerData];
		
		NSString* markerNumber = [mapPin getPinNumber];
		if( markerNumber != nil )
		{
			m_IDNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
			[m_IDNumberLabel setText:markerNumber];
			[m_IDNumberLabel setTextAlignment:UITextAlignmentCenter];
			[m_IDNumberLabel setFont:[UIFont boldSystemFontOfSize:17]];
			[m_IDNumberLabel setBackgroundColor:[UIColor clearColor]];
			[self addSubview:m_IDNumberLabel];
			CGPoint selfCenter = [self center];
			[m_IDNumberLabel setCenter:selfCenter];
			
		}
		m_pinRef = mapPin;
		m_markerLatLong = [mapPin getMarkerLatLong];
	
		[[self layer] setCornerRadius:15.0f];
        [[self layer] setMasksToBounds:YES];
        
        [[self layer] setBorderWidth:5.0f];
		[[self layer] setBorderColor:[[UIColor whiteColor] CGColor]];
		
	}
	return self;
}

-(void)moreInfoPressed:(id)sender
{
    NSString* markerType  = [m_markerData objectForKey:@"label_type"];
    if( [markerType isEqualToString:@"text"] )
    {
        m_callout = [[UIMapCalloutWithTextView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        [m_callout setTitle:[m_markerData objectForKey:@"title"] titleColor:m_markerColor];
        //[(UIMapCalloutWithTextView*)callout setText:[marker objectForKey:@"subtitle"] textColor:nil];
    }
    else if( [markerType isEqualToString:@"image"] || [markerType isEqualToString:@"parking"])
    {
        m_callout = [[UIMapCalloutTextImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        //[(UIMapCalloutTextImageView*)m_CalloutView setText:[dict objectForKey:@"description"] textColor:nil];
        [m_callout setTitle:[m_markerData objectForKey:@"title"] titleColor:m_markerColor];
    }
    else 
    {
        m_callout = [[UIMapCalloutStandView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        [m_callout setTitle:[m_markerData objectForKey:@"title"] titleColor:m_markerColor];
        [m_callout setSubTitle:[m_markerData objectForKey:@"subtitle"] subtitleColor:m_markerColor];
        [(UIMapCalloutStandView*)m_callout setDelegate:self];
    }
    	
	//[callout setSubTitle:[marker objectForKey:@"subtitle"] subtitleColor:makerColor];
	[m_callout setCloseButton:[Image LoadImage:@"mapInfoCloseIcon" ofType:@"png"]];
	[m_callout setParentAnnotation:m_pinRef];
	
	CGAffineTransform rotation;
	float fAngle = ( [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft ) ? M_PI_2 : -M_PI_2;
	rotation = CGAffineTransformMakeRotation(fAngle);
	[(UIMapPinAnnotationCalloutView*)m_callout setTransform:rotation];
	[m_callout setFrame:CGRectMake(0, 0, 480, 320)];
    if( [m_callout isKindOfClass:[UIMapCalloutStandView class]] )
    {
        [m_callout callDelegateToPopulateSubViews:YES];
        [m_callout setCalloutAlpha:1.0];
        [m_callout repositionCloseButton];
        [m_callout setFrame:CGRectMake(-20, 0, 340, 480)];
    }
	[[self superview] addSubview:m_callout];
	[m_callout setNeedsDisplay];
	
}

-(NSInteger)getMarkerIDNumber
{
	if( m_IDNumberLabel != nil )
	{
		return [[m_IDNumberLabel text] integerValue];
	}
	return -1;
}

-(CLLocationCoordinate2D)getMarkerLatLong
{
	return m_markerLatLong;
}

-(void)setRelativeAngleToMarker:(float)angle
{
	m_relativeAngleToMarker = angle;
}

-(float)getRelativeAngleToMarker
{
	return m_relativeAngleToMarker;
}

-(void)setDistanceToMarker:(float)distance
{
	m_distanceToMarker = distance;
}

-(float)getDistanceToMarker
{
	return m_distanceToMarker;
}

-(void)showHideCallout:(id)sender
{
}

-(void)expandView:(id)sender
{
	CGRect currentFrame = [self frame];
	if( m_title == nil )
	{
		m_title = [[UILabel alloc] init];
		//We should expand the view so increase the scale in the X direction
		currentFrame.size.height *= (1.5*M_PI);
		m_distance = [[UILabel alloc] init];
	}
	else
	{
		[m_pMoreInfoButton removeFromSuperview];
		[m_pMoreInfoButton release];
		m_pMoreInfoButton = nil;
		
		[m_subTitle removeFromSuperview];
		[m_subTitle release];
		m_subTitle = nil;
		
		[m_distance removeFromSuperview];
		[m_distance release];
		m_distance = nil;
		
		[m_title removeFromSuperview];
		[m_title release];
		m_title = nil;
		currentFrame.size.height /= (1.5*M_PI);
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(finishedExpansion:)];
	
	[self setFrame:currentFrame];
	_gradientLayer.bounds = self.bounds;
	
	_gradientLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
	[UIView commitAnimations];
		
}

-(void)finishedExpansion:(id)sender
{
	if( m_title != nil )
	{
		[m_IDNumberLabel removeFromSuperview];
		CGSize sizeForString = [[m_markerData objectForKey:@"title"] sizeWithFont:[UIFont systemFontOfSize:17]];
		[m_title setFrame:CGRectMake(10, 5, sizeForString.width+50, sizeForString.height)];
		[m_title setText:[m_markerData objectForKey:@"title"]];
		[m_title setTextAlignment:UITextAlignmentLeft];
		[m_title setFont:[UIFont boldSystemFontOfSize:17]];
		[m_title setBackgroundColor:[UIColor clearColor]];
		[self addSubview:m_title];
		
		sizeForString = [[m_markerData objectForKey:@"subtitle"] sizeWithFont:[UIFont systemFontOfSize:17]];
		m_subTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, sizeForString.width+50, sizeForString.height)];
		[m_subTitle setText:[m_markerData objectForKey:@"subtitle"]];
		[m_subTitle setTextAlignment:UITextAlignmentLeft];
		[m_subTitle setFont:[UIFont boldSystemFontOfSize:17]];
		[m_subTitle setBackgroundColor:[UIColor clearColor]];
		[self addSubview:m_subTitle];

		[m_distance setFrame:CGRectMake(10, 50, 180, sizeForString.height)];
		[m_distance setText:[NSString stringWithFormat:@"Distance: %0.2f Km", m_distanceToMarker]];
		[m_distance setTextAlignment:UITextAlignmentLeft];
		[m_distance setFont:[UIFont boldSystemFontOfSize:17]];
		[m_distance setBackgroundColor:[UIColor clearColor]];
		[self addSubview:m_distance];
		
		CGRect currentFrame = [self frame];
		
		m_pMoreInfoButton = [[UIButton alloc] initWithFrame:CGRectMake(currentFrame.size.height - 55, 15, 44, 44)];
		[m_pMoreInfoButton addTarget:self action:@selector(moreInfoPressed:) forControlEvents:UIControlEventTouchUpInside];
		[m_pMoreInfoButton setImage:[Image LoadImage:@"arrowUp" ofType:@"png"] forState:UIControlStateNormal];
		[m_pMoreInfoButton setBackgroundColor:[UIColor clearColor]];
		[m_pMoreInfoButton setTransform:CGAffineTransformMakeRotation(M_PI_2)];
		[self addSubview:m_pMoreInfoButton];
		

	}
	else
	{
		[self addSubview:m_IDNumberLabel];
	}
	
	[self setNeedsDisplay];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	// Drawing code
	if (_gradientStartColor && _gradientEndColor)
    {
        [_gradientLayer setColors:
		 [NSArray arrayWithObjects: (id)[_gradientStartColor CGColor]
		  , (id)[_gradientEndColor CGColor], nil]];
    }
    
    [super drawRect:rect];
}

-(CGFloat)yShadowOffset 
{
	float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
	if (osVersion >= 3.2) 
	{
		return 6;
	} 
	return -6;

}


- (void)dealloc
{
	[m_markerData release];
    [super dealloc];
}

//\============================================================================================================================
//\Expand StandCallout Delegate Function
//\============================================================================================================================
-(void)calloutStandView:(UIMapCalloutStandView*)callout calloutIsGoingToExpand:(BOOL)yesOrNo
{
	if( yesOrNo )
	{
		NSLog(@"Expanding Callout View");
		
		if( [callout getParentAnnotation] == m_pinRef )
		{
			//Safety First -- test to make sure we have the right object
			NSObject* dataObject = [m_markerData retrieveForPath:@"data_file"];
			if( dataObject != nil )
			{
				NSString* markerDataPath = [[[AppDelegate shareDelegate] getTourMainDirectory] stringByAppendingPathComponent:(NSString*)dataObject];
				
				NSMutableArray* images = nil;
				NSMutableArray* audio = nil;
				NSString* text	= nil;
				NSError** xmlError = nil;
				NSDictionary* xmlDictionary = [XMLReader dictionaryForXMLData:[NSData dataWithContentsOfFile:markerDataPath] error:xmlError];
				if( xmlError == nil )
				{
					text = [xmlDictionary retrieveForPath:@"marker_data.text"];
					if( [xmlDictionary retrieveForPath:@"marker_data.audiofiles"] )
					{	if( [[xmlDictionary retrieveForPath:@"marker_data.audiofiles.audio"] isKindOfClass:[NSArray class]] )
					{
						audio = [NSArray arrayWithArray:[xmlDictionary retrieveForPath:@"marker_data.audiofiles.audio"]];
					}
					else
					{
						audio = [NSArray arrayWithObject:[xmlDictionary retrieveForPath:@"marker_data.audiofiles.audio"]];
					}
					}
					images = [NSArray arrayWithArray:[xmlDictionary retrieveForPath:@"marker_data.images.image"]];
				}
				else 
				{
#ifdef DEBUG
					NSLog(@"Error reading XML for marker data");
#endif
				}
				[callout setUpScrollingImageViewWithImages:images];
				[callout setStandDetailText:text];
				[callout setStandAudioPlaybackControls:audio];
			}
		}
		
	}
	else 
	{
		NSLog(@"No everything is getting smaller");
		[callout removeScrollView];
		[callout removeDetailText];
	}
	
}

-(UIColor*)getColor
{
    return m_markerColor;
}
@end
