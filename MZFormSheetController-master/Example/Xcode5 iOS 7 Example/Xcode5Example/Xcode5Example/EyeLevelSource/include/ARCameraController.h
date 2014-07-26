//
//  ARCAmeraController, implements the CameraController delegate required by the EAGLEVIEW renderer.
//  This controller is fed from input from several motion and location sensors.
//

#import "EAGLView.h" // CameraControllerDelegate
#import "AccelerometerFilter.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>



#include "Maths.h"

@interface ARCameraController : NSObject <CameraControllerDelegate, CLLocationManagerDelegate, UIAccelerometerDelegate>
{
    Vector3 m_Position;
    Vector3 m_PositionAdjustments;
    
    double m_Yaw;
    float m_Pitch;
    float m_Roll;
    
    float angleX, angleY, angleZ;
    
    Matrix4 m_pCameraViewMatrix;
    
    float m_cameraAdjustedHeight;
    
    //\Positioning system
    CLLocationManager*			m_pLocationManager;
    CMMotionManager*            m_MotionManager;
    double                       m_ReferenceYaw;
    float                       m_ReferencePitch;
    float                       m_ReferenceRoll;
    CMAttitude*                 m_ReferenceAttitude;
    
	// Filter some noise out of gyroscope readings
	LowpassFilter *userAccelerationLpf;
    
    
    bool                        m_UseLocationServices;
    bool                        m_UseGyroscope;
    bool                        m_bApplyYawReset;
    
    GLfloat matrix[4][4], length;
    UIAccelerationValue	*accelerometer;
    Vector3 gravityAcceleration;

    BOOL initialisedGravity;
    
    float previousYaw;
    
    float m_compassHeading;
    
    NSTimer *animationTimer;
    Vector3 animationChangeVector;
    Vector3 animationTargetVector;
    
    float averageHeading;
    float averageYaw;
    int averageCount;
    
    float m_GPSheight;
    float m_lastPitch;
    float m_Yaw_Adjust;
    BOOL  lockAdjustments;
}

@property (nonatomic) UIAccelerationValue *accelerometer;


-(NSString*)description;

-(void) adjustYaw:(float)amount;
-(void) adjustPitch:(float)amount;
-(void) adjustRoll:(float)amount;

-( CMAcceleration ) getGravity;

-(void) setYaw:(float)amount;
-(void) setPitch:(float)amount;
-(void) setRoll:(float)amount;

-(float) getYaw;
-(float) getPitch;

-(void) resetCamera;

-(void) setPosition:(Vector3)position;
-(void) animateToPosition:(Vector3)position duration:(NSInteger)durationLength;
-(Vector3) getPosition;

-(void) setUseLocationServices:(bool)value;
-(void) setUseGyroscope:(bool)value;

-(void) moveForward:(float) metres;
-(void) moveRight:(float) metres;
-(void) moveUp:(float) metres;
-(float) getHeightAdjustments;

-(void) applyYawReset;
-(void) setDisplayHeight:(float)height;
-(void) lockManualAdjustments:(BOOL)lock;
-(void) resetAdjustments;


@end

