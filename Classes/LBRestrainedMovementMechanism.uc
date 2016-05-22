/**
 *  LBRestrainedMovementMechanism
 *
 *  Creation date: 08.05.2016 22:41
 *  Copyright 2016, Windows7
 */
class LBRestrainedMovementMechanism extends LBMechanism;

var(RestrainedMovement) bool bPerformMovement; 
var(RestrainedMovement) vector PointA; //First point of movement, we are always moving from PointA to PointB with positive speed and vice versa
var(RestrainedMovement) vector PointB; //Second point of movement
var(RestrainedMovement) float FwdSpeed; //Forward speed if < 0 then moves backwards
var(RestrainedMovement) float kFwdSpeed; //Coefficient that modifies the FwdSpeed: k*FwdSpeed
var(RestrainedMovement) bool bReverseOnCompleteMov; //Reverse the FwdSpeed, after reaching either Point
var(RestrainedMovement) bool bFaceMovingDirection; //Rotate the object to face PointB

var(RestrainedRotation) bool bPerformRotation; 
var(RestrainedRotation) float AngleA; //First angle restraint, we are always rotation from PointA to PointB
var(RestrainedRotation) float AngleB; //Second angle restraintt
var(RestrainedRotation) float AngSpeed; //Set big values to make the actor rotate instantly, smaller values will give a smooth rotation
var(RestrainedRotation) float kAngSpeed; //Coefficient that modifies the AngSpeed: k*AngSpeed
var(RestrainedRotation) bool bReverseOnCompleteRot;

var(MechanismDebug) bool bShowDebugLines; //Display debug in game

var float currot;

function FirstTickInit()
{
    super.FirstTickInit();
    
    currot=parent.rotation.Yaw*UnrRotToDeg; //!!!
}

event OwnerTick(float deltatime)
{
    super.OwnerTick(deltatime);
    
    if(benabled==false)
        return;
     
    if (bPerformMovement)  
        PerformMovement();  
    if (bPerformRotation)
        PerformRotation();
}

function PerformMovement()
{
    local vector v;
      
    v=vect(0,0,0); 
    
    if (FwdSpeed>0)
        v=PointB-parent.location;
    else
        v=-1*(PointA-parent.location);
    
    if (v!=vect(0,0,0))
    {
        if (vsize(v)>abs(FwdSpeed))
        {
            v=normal(v);
            parent.MoveSmooth(v*FwdSpeed);  
        }
        else
        {
            parent.MoveSmooth(v); 
            if (bReverseOnCompleteMov)
            {
                FwdSpeed=-FwdSpeed; 
            }
        }
    }  
    
    if (bShowDebugLines)
    {
        parent.DrawDebugSphere(PointA, 64, 16, 0, 0, 255);
        parent.DrawDebugSphere(PointB, 64, 16, 255, 0, 0);
        parent.DrawDebugLine(parent.location, PointA, 0, 0, 255);
        parent.DrawDebugLine(parent.location, PointB, 255, 0, 0);
        parent.DrawDebugLine(parent.location+vect(0,0,25), parent.location+parent.Velocity+vect(0,0,25), 0, 255, 0);
    }
}

function PerformRotation()
{
    local vector a, b, c;
    local rotator r, ra, rb, rc;
    local float f;
   
    if (AngSpeed>0)
        f=AngleB-currot;    
    else
        f=-(AngleA-currot);
    
    if (f!=0)
    {
        if (abs(f)>abs(AngSpeed))
        {
            currot=currot+AngSpeed; 
        }
        else
        {
            currot=currot+f;
            if (bReverseOnCompleteRot)
            {
                AngSpeed=-AngSpeed; 
            }
        }
    }
    
    r=parent.rotation;
    r.Yaw=currot*DegToUnrRot;
    parent.SetRotation(r);
    
    ra.Yaw=AngleA * DegToUnrRot;
    rb.Yaw=AngleB * DegToUnrRot;
    
    a=vector(ra);
    b=vector(rb);
    
    rc.Yaw=currot * DegToUnrRot;
    c=vector(rc);
    
    if (bShowDebugLines)
    {
        parent.DrawDebugLine(parent.location, parent.location+a*128, 0, 0, 255);
        parent.DrawDebugLine(parent.location, parent.location+b*128, 255, 0, 0);
        parent.DrawDebugLine(parent.location, parent.location+c*128, 0, 255, 0);
    }
}

function SetParamFloat(name param, float value, optional int priority=0)
{
    if (param=='FwdSpeed')
        FwdSpeed=value;
    else if (param=='kFwdSpeed')
        kFwdSpeed=value;
    else if (param=='AngSpeed')
        AngSpeed=value;   
    else if (param=='kAngSpeed')
        kAngSpeed=value;  
} 
    
function SetParamBool(name param, bool value, optional int priority=0)
{
    if (param=='bReverseOnCompleteMov')
        bReverseOnCompleteMov=value;
    if (param=='bReverseOnCompleteRot')
        bReverseOnCompleteRot=value;    
}     

defaultproperties
{
    bShowDebugLines=false
    
    bPerformMovement=true
    bPerformRotation=true
    
    AngleA=0
    AngleB=90
    
    FwdSpeed=0
    kFwdSpeed=100
    AngSpeed=0
    kAngSpeed=1
    
    bFaceMovingDirection=false
    bReverseOnCompleteMov=true
    bReverseOnCompleteRot=true
    
}
