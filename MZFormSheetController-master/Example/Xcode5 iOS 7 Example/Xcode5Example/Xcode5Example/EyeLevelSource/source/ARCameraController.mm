
#include "Maths.h"
#include "ARCameraController.h"

#import <CoreMotion/CoreMotion.h>

#define kAccelerometerFrequency		100.0 // Hz
#define kFilteringFactor			0.1

//static const double kMinCutoffFrequency = 1;

//static const double kUserAccelerationHpfCutoffFrequency = 1000.0;
static const double kUserAccelerationLpfCutoffFrequency = 10.0;


@interface ARCameraController (Private)
-(void) initLocationManager;
-(void) initMotionDevice;
-(void) processDeviceMotion;
@end

@implementation ARCameraController

@synthesize accelerometer;

#pragma mark - Initialisation
-(id) init
{
    if( ( self = [super init] ) )
    {
        [self resetCamera];

        [self initLocationManager];
        [self initMotionDevice];
        
    }
    averageYaw = 0;
    averageHeading = 0;
    averageCount = 0;
    m_Yaw_Adjust = 0;
    m_cameraAdjustedHeight = 0;
    lockAdjustments = YES;
    return self;
}

-(void) resetCamera
{
    m_Yaw = 0;
    m_Pitch = 0;
    m_Roll = 0;
    
    m_Position = Vector3();
    m_PositionAdjustments = Vector3(0.0,0.0,0.0);
    m_UseLocationServices = YES;
    m_UseGyroscope = YES;
    
    [self getViewMatrix];
    
    m_bApplyYawReset = false;    previousYaw = 0;
}

-(void) initLocationManager
{
    //start the location tracking
    m_pLocationManager = [[CLLocationManager alloc] init];
    if( [CLLocationManager locationServicesEnabled] )
    {
        [m_pLocationManager setDelegate: self];
        m_pLocationManager.headingFilter = kCLHeadingFilterNone;
       // m_pLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        m_pLocationManager.distanceFilter = 1;
        //[m_pLocationManager startUpdatingLocation];
        [m_pLocationManager startUpdatingHeading];
    }
    else
    {
        NSLog(@"Error initialising Location Service, Handle this later");
    }
    
}


-(void) initMotionDevice
{
	
//    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 30)];
//	[[UIAccelerometer sharedAccelerometer] setDelegate:self];	
	
    //start the motion manager
    // Turn on the appropriate type of data
    if (m_MotionManager == nil) 
    {
        m_MotionManager = [[CMMotionManager alloc] init];
    }
    

    
    m_MotionManager.accelerometerUpdateInterval = 0.0;
    m_MotionManager.deviceMotionUpdateInterval = 0.0;
    //[m_MotionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical];

    [m_MotionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryCorrectedZVertical];
    

    userAccelerationLpf = [[LowpassFilter alloc] initWithCutoffFrequency:kUserAccelerationLpfCutoffFrequency];
    
    
    [NSTimer scheduledTimerWithTimeInterval:(1.0/30.0)
                                     target:self
                                   selector:@selector( processDeviceMotion )
                                   userInfo:nil
                                    repeats:YES];
   
   
    initialisedGravity = NO;
   // self.accelerometer = [UIAccelerometer sharedAccelerometer];
  //  accelerometer = calloc(3, sizeof(UIAccelerationValue));

}

#pragma mark - Uninitialise
-(void)dealloc
{
    [m_pLocationManager stopUpdatingHeading];
	//[m_pLocationManager stopUpdatingLocation];
	[m_pLocationManager setDelegate:nil];
    
    
}

#pragma mark - Getters
-( CMAcceleration ) getGravity
{
	return m_MotionManager.deviceMotion.gravity;
}

#pragma mark - Device Motion Delegate
- (void) processDeviceMotion 
{
    if( m_UseGyroscope )
    {
        double yaw,pitch,roll = 0;

        CMDeviceMotion *deviceMotion = m_MotionManager.deviceMotion;
        CMAttitude *attitude = deviceMotion.attitude;
      //  NSLog(@"device yaw is %f difference is %f", attitude.yaw, attitude.yaw - previousYaw);
        if (m_ReferenceAttitude != nil) 
        {
            yaw = attitude.yaw  - m_ReferenceYaw;
            pitch = attitude.pitch - m_ReferencePitch;
            roll =  attitude.roll - m_ReferenceRoll;
        }
        

        if( ![m_MotionManager isDeviceMotionAvailable] )
        {
			[m_MotionManager stopDeviceMotionUpdates];
            //NSLog(@"Device Motion Not enabled!");
        }
        
        float pitchVal = asin(deviceMotion.gravity.z);
        if(fabs(pitchVal - m_lastPitch) > 0.005)
        {
            [self setPitch:pitchVal];
            m_lastPitch = pitchVal;
        }
        if( fabsf(previousYaw - attitude.yaw) > 0.005 && fabsf(previousYaw - attitude.yaw) < 0.35)
        {
            [self setYaw: yaw];
            
        }
        previousYaw = attitude.yaw;
      //  else
       // {
            //[self applyYawReset];
       // }*/
        
          //   NSLog(@"yaw is %f", fabsf(previousYaw - attitude.yaw));
        
        
    }
}

#pragma mark - Device Location Delegates
#pragma mark - Location Manager

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading 
{
    //NSLog(@"heading is %f ", newHeading.trueHeading);
    // NSLog(@"BEARING FROM DUE NORTH %f", newHeading.trueHeading - 90 -180);
    //we need to realign our default heading when this is done.
    if( m_ReferenceAttitude == nil )
    {
        NSLog(@"BEARING FROM DUE NORTH %f", newHeading.trueHeading - 90 -180);
        
        CMDeviceMotion *deviceMotion = m_MotionManager.deviceMotion;      
        CMAttitude *attitude = deviceMotion.attitude;
        
        m_ReferenceAttitude = attitude;
        m_ReferencePitch = attitude.pitch;
        m_ReferenceRoll = attitude.roll;
        m_ReferenceYaw = attitude.yaw + ( DEG_2_RAD * (  newHeading.trueHeading + 90.0l ));
    }
    
    //recalibrate hte yaw count every now and then to remove compounded in accuracies, (we need to find a way to do this in other axis.
    static int reset = 1;
    
   // if( reset++ % 1 == 0 )
  //  {
    
    CMDeviceMotion *deviceMotion = m_MotionManager.deviceMotion;
    CMAttitude *attitude = deviceMotion.attitude;
    
    m_compassHeading = attitude.yaw + ( DEG_2_RAD * (  newHeading.trueHeading + 90.0l ));
        if(m_bApplyYawReset)
    {
        NSLog(@"Recalibrating yaw");
        reset = 1;
        m_bApplyYawReset = false;
        
        m_ReferenceAttitude = attitude;
        m_ReferenceYaw = attitude.yaw + ( DEG_2_RAD * (  newHeading.trueHeading + 90.0l ));
        
        //m_ReferenceYaw = (attitude.yaw) + DEG_2_RAD * ( 90);
        averageYaw = 0;
        averageHeading = 0;
        averageCount = 0;
       // NSLog(@"newHeading: %f new Yaw: %Lf result %f", newHeading.trueHeading, RAD_2_DEG(attitude.yaw  - m_ReferenceYaw)

    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"Location manager failed big time: %@", error.localizedDescription );
	
	UIAlertView *pAlertView = [[UIAlertView alloc] initWithTitle: @"Error" 
														 message: @"Failed to locate your position. Is Location Services enabled? Do you have access to the internet?" 
														delegate: nil 
											   cancelButtonTitle: @"Dismiss" 
											   otherButtonTitles: nil];
	
	[pAlertView show];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
	NSLog(@"Authorization status for the application changed: %d", status );
}

-(void) setUseLocationServices:(bool)value
{
    m_UseLocationServices = value;
}

-(void) setUseGyroscope:(bool)value
{
    m_UseGyroscope  = value;
}

#pragma mark - Camera Rotation Mutators
-(void) adjustYaw:(float)amount
{
    m_Yaw_Adjust += amount;
}

-(void) adjustPitch:(float)amount
{
    m_ReferenceYaw += amount;
}

-(void) adjustRoll:(float)amount
{
    m_Roll += amount;
}

-(void) setYaw:(float)amount
{
    m_Yaw = amount;
}

-(void) setPitch:(float)amount
{
    m_Pitch = amount;
    
}

-(void) setRoll:(float)amount
{
    m_Roll = amount;
}


-(float) getYaw
{
    return m_Yaw;
}

-(float) getPitch
{
    return m_Pitch;
}

-(void) setPosition:(Vector3)position
{
    NSLog(@"set pos here");
    m_Position = position;
}

-(void)onAnimationTimerTick:(NSTimer *)timer {
    
    m_Position.x += animationChangeVector.x;
    m_Position.y += animationChangeVector.y;
    m_Position.z += animationChangeVector.z;
    //NSLog(@"animating %f aiming for %f", animationTargetVector.x - m_Position.x, animationChangeVector.x);
     if(abs(animationTargetVector.x - m_Position.x) <= abs(animationChangeVector.x))
    {
       // NSLog(@"here on stop timer");
        [animationTimer invalidate];
        animationTimer = nil;
        m_Position = animationTargetVector;
    }
}

-(void) animateToPosition:(Vector3)position duration:(NSInteger)durationLength
{
    if(abs(position.x - m_Position.x > 200))
    {
        m_Position = position;
        NSLog(@"too big to animate");
        return;
    }
    if(animationTimer) [animationTimer invalidate];
    animationTimer = [NSTimer scheduledTimerWithTimeInterval: 0.1
                                                      target: self
                                                    selector:@selector(onAnimationTimerTick:)
                                                    userInfo: nil repeats:YES];
    animationTargetVector = position;
    animationChangeVector = Vector3((position.x - m_Position.x) / (durationLength / 0.1), (position.y - m_Position.y) / (durationLength / 0.1), (position.z - m_Position.z) / (durationLength / 0.1)); 
}

-(Vector3) getPosition
{
    return m_Position;
}

-(void) moveForward:(float) metres
{
    m_Position += m_pCameraViewMatrix.GetCol(2) * metres;
    NSLog(@"Camera Pos %f, %f, %f", m_Position.x, m_Position.y, m_Position.z);
}

-(void) moveRight:(float) metres
{
    
    m_Position += m_pCameraViewMatrix.GetCol(0) * metres;
    NSLog(@"Camera Pos %f, %f, %f", m_Position.x, m_Position.y, m_Position.z);
}

-(void) moveUp:(float) metres
{
    m_PositionAdjustments += m_pCameraViewMatrix.GetCol(1) * metres;
    m_cameraAdjustedHeight+=metres;
    NSLog(@"Camera Pos %f, %f, %f", m_Position.x, m_Position.y, m_Position.z);
}

-(float) getHeightAdjustments
{
    
    return m_cameraAdjustedHeight;
}

-(void) setDisplayHeight:(float)height
{
   m_GPSheight = height;
}

-(void) resetAdjustments
{
    m_PositionAdjustments = Vector3(0.0,0.0,0.0);
    m_Yaw_Adjust = 0;
    m_cameraAdjustedHeight = 0;
}

-(NSString*)description
{
    double yawAngle = RAD_2_DEG(m_Yaw);
    while(yawAngle < 0)
    {
        yawAngle += 360;
    }
    while(yawAngle > 360)
    {
        yawAngle -= 360;
    }
    

    return [NSString stringWithFormat:@"Augmented Reality View v0.9\nAugmented Position (%f,%f,%f)\nAugmented Orientation Yaw %1.3f Pitch %1.3Lf Roll NA Compass %Lf", m_Position.x, m_Position.z, m_GPSheight + m_Position.y, yawAngle, RAD_2_DEG(m_Pitch),  RAD_2_DEG(m_compassHeading)];
}

-(void) applyYawReset
{
    m_bApplyYawReset = true;
}

-(void) lockManualAdjustments:(BOOL)lock
{
    lockAdjustments = lock;
}

#pragma mark - CameraControllerDelegate
-(Matrix4) getViewMatrix;
{
    Matrix4 translation = Matrix4::CreateTranslation(-1 * m_Position);
    Matrix4 translationAdjustments;
    if(lockAdjustments == NO) translationAdjustments = Matrix4::CreateTranslation(-1.0 *  m_PositionAdjustments);
    else translationAdjustments = Matrix4::CreateTranslation(Vector3(0.0,0.0,0.0));
   
    
    Matrix4 rotation = Matrix4::IDENTITY;
    rotation.RotateZYX( Vector3(m_Pitch, m_Yaw, m_Roll) );
    
    Matrix4 rotation2 = Matrix4::IDENTITY;
    if(lockAdjustments == NO)
    {
        rotation2.RotateZYX( Vector3(0.0, m_Yaw_Adjust, 0.0) );
    }

    
    m_pCameraViewMatrix =  translationAdjustments * translation * rotation2 * rotation;
    
    return m_pCameraViewMatrix;
}



@end
