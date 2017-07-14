/**
 *  LBPathMovementMechanism
 *
 *  Creation date: 08.01.2017 00:10
 *  Copyright 2017, Windows7
 */
class LBPathMovementMechanism extends LBTransposeMechanism;

var (PathMovement) float ForwardSpeed; 
var (PathMovement) float AngularSpeed;

var (PathMovementSystem) SplineActor Path;
var (PathMovementSystem) bool bSimulateMovement;
var (PathMovementSystem) float dError;
var (PathMovementSystem) float dStepLength; //Should be less then ForwardSpeed

var (SmoothMovement) bool bUseSmoothMovement;
var (SmoothMovement) float AccelRate;

var (PathMovementOutput) vector outLocation; //bSimulateMovement==true; [proc::PeformActorMovement->location]
var (PathMovementOutput) vector outVelocity; //bSimulateMovement==true; [proc::PeformPawnMovement->velocity]
var (PathMovementOutput) rotator outRotation; //bSimulateMovement==true; [proc::PerformActorRotation->rotation]
var (PathMovementOutput) rotator outAngSpeed; //bSimulateMovement==true; [proc::PerformPawnRotation->angspeed] !!!NOT IMPLEMENTED YET!!!

var float dist;
var float pathstep;

//function InitMechanism();
//{
//    pathsteps=Path.Connections[0].SplineComponent.GetLocationAtDistanceAlongSpline(dist) / dStep;        
//}

//function FirstTickInit()
//{
//    if (bfirsttick==false)
//        return;
//    
//    if (bfirsttick==true)
//        bfirsttick=false;    
//}

function PeformActorMovement(float dt)
{
    local SplineConnection node;
    local float spd;
    local vector v;
    local rotator r;
    
    if (Path == none || Path.Connections.Length == 0)
        return;
        
    node=Path.Connections[0];
    
    if (bTickIndependent)
    {
        if (bUseSmoothMovement) 
            spd=LinearInerpFloatValue(spd,ForwardSpeed,TickIndependentFloat(AccelRate, dt, MovementTimeScale),dt);
        else
            spd=TickIndependentFloat(ForwardSpeed,dt,MovementTimeScale);    
    }
    else
    {
        if (bUseSmoothMovement) 
            spd=LinearInerpFloatValue(spd,ForwardSpeed,AccelRate,dt);
        else
            spd=ForwardSpeed;        
    }
        
    if (spd < node.SplineComponent.GetSplineLength() - dist)
    {
        dist=dist+spd;
        
        v=node.SplineComponent.GetLocationAtDistanceAlongSpline(dist);

        //`log("Cur point: "@v@","@dist@"/"@node.SplineComponent.GetSplineLength()@path);
        //r=rotator(node.SplineComponent.GetTangentAtDistanceAlongSpline(dist));
    }
    else
    {
        dist=node.SplineComponent.GetSplineLength();
        
        v=node.SplineComponent.GetLocationAtDistanceAlongSpline(dist);
        //r=rotator(node.SplineComponent.GetTangentAtDistanceAlongSpline(node.SplineComponent.GetSplineLength()))
        
        Path=Path.Connections[0].ConnectTo;  
        
        dist=0;  
    }   
   
    if (!bSimulateMovement)
    {
        parent.SetLocation(v);
    }
    else
    {
        outLocation=v;    
    }
}
 
function PeformPawnMovement(float dt)
{
    local SplineConnection node;
    local float pos;
    local vector v;
    local rotator r;
    
    if (Path == none || Path.Connections.Length == 0)
    {
        LogInfo("Reached the last point!"); 
        return;
    }
        
    node=Path.Connections[0];
    
    v=(node.SplineComponent.GetLocationAtDistanceAlongSpline(dist) * vect(1,1,0)) - (parent.Location * vect(1,1,0));
    
    if (VSize(v) > dError)
    {
        if (!bSimulateMovement)
        {
            parent.Velocity=Normal(v)*ForwardSpeed;
        }
        else
        {
            outVelocity=Normal(v)*ForwardSpeed;    
        }
        
        if (bShowDebugGraphics)
        {
            DGDisplaySpeedVector(parent,v);
            DGDisplayLocationSphere(parent,node.SplineComponent.GetLocationAtDistanceAlongSpline(dist));                
        }
    }
    else
    { 
        dist=dist + dStepLength;
        
        if (dist >= node.SplineComponent.GetSplineLength())
        {
            if (Path.Connections[0].ConnectTo!=none)
            {
                Path=Path.Connections[0].ConnectTo;  
                dist=0;
                
                LogInfo("Going to next path point"@Path);
                
                if (!bSimulateMovement)
                {
                    parent.Velocity=Normal(v)*ForwardSpeed;
                }
                else
                {
                    outVelocity=Normal(v)*ForwardSpeed;    
                }
            } 
            else
            {
                LogInfo("We've reached the last point!");    
            }    
        }       
    }
}

function PerformActorRotation(float dt)
{
    local SplineConnection node;
    local float spd;
    local vector v;
    local rotator r;

    if (Path == none || Path.Connections.Length == 0)
        return;
    
    node=Path.Connections[0];
        
    r=rotator(node.SplineComponent.GetTangentAtDistanceAlongSpline(dist));
    
    if (!bSimulateMovement)
    {
        parent.SetRotation(r);
    }
    else
    {
        outRotation=r;    
    }
}

function PerformPawnRotation(float dt)
{
    local SplineConnection node;
    local float spd;
    local vector v;
    local rotator r;

    if (Path == none || Path.Connections.Length == 0)
        return;
    
    node=Path.Connections[0];
        
    r=rotator(node.SplineComponent.GetTangentAtDistanceAlongSpline(dist));
    
    if (!bSimulateMovement)
    {
        parent.SetRotation(r);
    }
    else
    {
        outAngSpeed=r-parent.Rotation;
       //`log("parent.Rotation:"@parent.Rotation*unrrottodeg@"r:"@r*unrrottodeg); 
    } 
}

function PerformMovement(float dt)
{
    if (LBActor(parent)!=none)
        PeformActorMovement(dt);
    else if (LBPawn(parent)!=none)
        PeformPawnMovement(dt);
}

function PerformRotation(float dt)
{
    if (LBActor(parent)!=none)
        PerformActorRotation(dt);
    else if (LBPawn(parent)!=none)
        PerformPawnRotation(dt);  
}
    
function DGDisplaySpeedVector(actor a, vector v)
{
    local float r,h;
    a.GetBoundingCylinder(r,h);
    parent.DrawDebugLine(a.Location,a.Location+v*h,255,0,0);  
}

function DGDisplayLocationSphere(actor a, vector v)
{
    local float r,h;
    
    a.GetBoundingCylinder(r,h);
    a.DrawDebugSphere(v,h+h/4,12,0,0,128);        
}

function SetParamFloat(name param, float value, optional int priority=0)
{
    if (param=='ForwardSpeed' || param=='FwdSpeed')
    {
        ForwardSpeed=value;
    }
    else if (param=='AccelRate' || param=='AccelerationRate')
    {
        AccelRate=value;    
    }
}

function float GetParamFloat(name param)
{
    if (param=='outLocationX' || param=='outLocation-X')
        return outLocation.X;
    else if (param=='outLocationY' || param=='outLocation-Y')
        return outLocation.Y;  
    else if (param=='outLocationZ' || param=='outLocation-Z')
        return outLocation.Z;  
    else if (param=='outVelocityX' || param=='outVelocity-X')
        return outVelocity.X;
    else if (param=='outVelocityY' || param=='outVelocity-Y')
        return outVelocity.Y;  
    else if (param=='outVelocityZ' || param=='outVelocity-Z')
        return outVelocity.Z; 
    else if (param=='outRotationYaw' || param=='outRotation-Yaw')
        return outRotation.Yaw;
    else if (param=='outRotationPitch' || param=='outRotation-Pitch')
        return outRotation.Pitch;  
    else if (param=='outRotationRoll' || param=='outRotation-Roll')
        return outRotation.Roll;
    else if (param=='outAngularSpeedYaw' || param=='outAngularSpeed-Yaw')
        return outAngSpeed.Yaw;
    else if (param=='outAngularSpeedPitch' || param=='outAngularSpeed-Pitch')
        return outAngSpeed.Pitch;  
    else if (param=='outAngularSpeedRoll' || param=='outAngularSpeed-Roll')
        return outAngSpeed.Roll;    
}
    

function vector GetParamVector(name param)
{
    if (param=='outLocation')
        return outLocation;
    else if (param=='outVelocity' || param=='outVel')
        return outVelocity;    
}
    
function rotator GetParamRotator(name param)
{
    if (param=='outRotation')
        return outRotation;
    else if (param=='outAngularSpeed' || param=='outAngSpeed')
        return outAngSpeed;    
} 

defaultproperties
{
    AccelRate=1
    
    dError=5.0f
    dStepLength=1.0f
    
    mechname="Path_Movement_Mechanism"
    
    MechanismParams.Empty
    
    MechanismParams(0)=(ParamName="ForwardSpeed", ParamType=ParamType_Float, ParamInfo="Float. Read. Write. Gets or sets the forward speed for path movement. Set to non-zero value to advance along the spline.")
    MechanismParams(1)=(ParamName="AccelerationRate", ParamType=ParamType_Float, ParamInfo="Float. Read. Write. Gets or sets the acceleration rate for smooth movement.")
    MechanismParams(2)=(ParamName="outLocation", ParamType=ParamType_Vector, ParamInfo="Vector. Read. Gets the location for the parent actor in simulated movement.")
    MechanismParams(3)=(ParamName="outLocationX", ParamType=ParamType_Float, ParamInfo="Float. Read. Gets the X component of  @outLocation.")
    MechanismParams(4)=(ParamName="outLocationY", ParamType=ParamType_Float, ParamInfo="Float. Read. Gets the Y component of  @outLocation.")
    MechanismParams(5)=(ParamName="outLocationZ", ParamType=ParamType_Float, ParamInfo="Float. Read. Gets the Z component of  @outLocation.")
    MechanismParams(6)=(ParamName="outVelocity", ParamType=ParamType_Vector, ParamInfo="Vector. Read. Gets the velocity for the parent pawn in simulated movement.")
    MechanismParams(7)=(ParamName="outVelocityX", ParamType=ParamType_Float, ParamInfo="Float. Read. Gets the X component of  @outVelocity.")
    MechanismParams(8)=(ParamName="outVelocityY", ParamType=ParamType_Float, ParamInfo="Float. Read. Gets the Y component of  @outVelocity.")
    MechanismParams(9)=(ParamName="outVelocityZ", ParamType=ParamType_Float, ParamInfo="Float. Read. Gets the Z component of  @outVelocity.")
    MechanismParams(10)=(ParamName="outRotation", ParamType=ParamType_Rotator, ParamInfo="Rotator. Read. Gets the rotation for the parent actor in simulated movement.")
    MechanismParams(11)=(ParamName="outRotationYaw", ParamType=ParamType_Float, ParamInfo="Float. Read. Gets the Yaw component of  @outRotation.")
    MechanismParams(12)=(ParamName="outRotationPitch", ParamType=ParamType_Float, ParamInfo="Float. Read. Gets the Pitch component of  @outRotation.")
    MechanismParams(13)=(ParamName="outRotationRoll", ParamType=ParamType_Float, ParamInfo="Float. Read. Gets the Roll component of  @outRotation.")
    MechanismParams(14)=(ParamName="outAngularSpeed", ParamType=ParamType_Rotator, ParamInfo="Rotator. Read. Gets the angular speed for the parent pawn in simulated movement.")
    MechanismParams(15)=(ParamName="outAngularSpeedYaw", ParamType=ParamType_Float, ParamInfo="Float. Read. Gets the Yaw component of  @outAngularSpeed.")
    MechanismParams(16)=(ParamName="outAngularSpeedPitch", ParamType=ParamType_Float, ParamInfo="Float. Read. Gets the Pitch component of  @outAngularSpeed.")
    MechanismParams(17)=(ParamName="outAngularSpeedRoll", ParamType=ParamType_Float, ParamInfo="Float. Read. Gets the Roll component of  @outAngularSpeed.")
    
    ParamSource(0)=(ParamName="ForwardSpeed")
    ParamSource(1)=(ParamName="AccelerationRate")
}
