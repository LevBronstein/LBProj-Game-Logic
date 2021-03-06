/**
 *  LBMovementMechanism
 *
 *  Creation date: 31.05.2016 19:18
 *  Copyright 2016, Windows7
 */
class LBMovementMechanism extends LBTransposeMechanism;

//var(Movement) float SpeedX;
//var(Movement) float SpeedY;
//var(Movement) float SpeedZ;
var(Movement) vector ForwardSpeed;
//var(Movement) float AngularSpeedYaw;
//var(Movement) float AngularSpeedPitch;
//var(Movement) float AngularSpeedRoll;
var(Movement) rotator AngularSpeed;

var(MechanismDebug) bool bShowDebugLines; //Display debug lines in game

var float currotY, currotP, currotR;

event OwnerTick(float deltatime)
{
    super.OwnerTick(deltatime);
    
    if (benabled == false)
        return;
        
    PerformTick(deltatime);
}

function PerformTick(float dt)
{
    if (bEnableMovement) 
        PerformMovement(dt);
        
    if (bEnableRotation) 
        PerformRotation(dt);    
}

function PerformMovement(float dt)
{
    if (bTickIndependent)
    {
        SetParentLocation(GetParentLocation()+TickIndependentVector(ForwardSpeed,dt,MovementTimeScale));
        
        //if (LBActor(parent)!=none)
        //    parent.SetLocation(parent.location+TickIndependentVector(ForwardSpeed,dt,MovementTimeScale));
        //else if (LBPawn(parent)!=none)
        //    parent.Velocity=TickIndependentVector(ForwardSpeed,dt,MovementTimeScale);  
        //else if (LBSMPhysicsActor(parent)!=none)
        //    LBSMPhysicsActor(parent).CollisionComponent.SetRBPosition(parent.Location+TickIndependentVector(ForwardSpeed,dt,MovementTimeScale));
        //else if (LBSKMPhysicsActor(parent)!=none)
        //    LBSKMPhysicsActor(parent).CollisionComponent.SetRBPosition(parent.Location+TickIndependentVector(ForwardSpeed,dt,MovementTimeScale));
    }
    else
    {
        SetParentLocation(GetParentLocation()+ForwardSpeed);
        
        //if (LBActor(parent)!=none)
        //    parent.SetLocation(parent.location+ForwardSpeed);
        //else if (LBPawn(parent)!=none)
        //    parent.Velocity=ForwardSpeed;  
        //else if (LBSMPhysicsActor(parent)!=none)
        //    LBSMPhysicsActor(parent).CollisionComponent.SetRBPosition(parent.Location+ForwardSpeed);    
        //else if (LBSKMPhysicsActor(parent)!=none)
        //    LBSKMPhysicsActor(parent).CollisionComponent.SetRBPosition(parent.Location+ForwardSpeed);
    }
}

function PerformRotation(float dt)
{    
    if (bTickIndependent)
    {
        SetParentRotation(GetParentRotation()+TickIndependentRotator(AngularSpeed,dt,RotationTimeScale));
        
        //if (LBActor(parent)!=none || LBPawn(parent)!=none)
        //    parent.SetRotation(parent.Rotation+TickIndependentRotator(AngularSpeed,dt,RotationTimeScale));
        //else if (LBSMPhysicsActor(parent)!=none)
        //    LBSMPhysicsActor(parent).CollisionComponent.SetRBRotation(parent.Rotation+TickIndependentRotator(AngularSpeed,dt,RotationTimeScale));
        //else if (LBSKMPhysicsActor(parent)!=none)
        //    LBSKMPhysicsActor(parent).CollisionComponent.SetRBRotation(parent.Rotation+TickIndependentRotator(AngularSpeed,dt,RotationTimeScale));
    }
    else
    {
        SetParentRotation(GetParentRotation()+AngularSpeed);
        
        //if (LBActor(parent)!=none || LBPawn(parent)!=none)
        //    parent.SetRotation(parent.Rotation+AngularSpeed);
        //else if (LBSMPhysicsActor(parent)!=none)
        //    LBSMPhysicsActor(parent).CollisionComponent.SetRBRotation(parent.Rotation+AngularSpeed);
        //else if (LBSKMPhysicsActor(parent)!=none)
        //    LBSKMPhysicsActor(parent).CollisionComponent.SetRBRotation(parent.Rotation+AngularSpeed);
    }
}

function vector GetParamVector(name param)
{
    if (param=='Location')
        return parent.Location;
    else if (param=='Speed' || param=='ForwardSpeed' || param=='FwdSpeed')
        return ForwardSpeed;   
    else 
        return super.GetParamVector(param); 
}
    
function SetParamVector(name param, vector value, optional int priority=0)
{
    super.SetParamVector(param,value,priority);
    
    if (param=='Speed' || param=='ForwardSpeed' || param=='FwdSpeed')
        ForwardSpeed=value;  
}     

function rotator GetParamRotator(name param)
{
    if (param=='Rotation')
        return parent.Rotation;
    else if (param=='AngSpeed' || param=='AngularSpeed')
        return AngularSpeed;  
    else
        return super.GetParamRotator(param);
}    
   
function SetParamRotator(name param, rotator value, optional int priority=0)
{
    super.SetParamRotator(param,value,priority);
    
    if (param=='AngSpeed' || param=='AngularSpeed')
        AngularSpeed=value;    
}  
    
function SetParamFloat(name param, float value, optional int priority=0)
{
    super.SetParamFloat(param,value,priority);
    
    if (param=='SpeedX' || param=='Speed-X')
        ForwardSpeed.X=value;
    else if (param=='SpeedY' || param=='Speed-Y')
        ForwardSpeed.Y=value;
    else if (param=='SpeedZ' || param=='Speed-Z')
        ForwardSpeed.Z=value;
    else if (param=='AngularSpeedYaw' || param=='AngSpeedYaw' || param=='AngSpeedYaw-Yaw' || param=='AngularSpeed-Yaw')
        AngularSpeed.Yaw=value;
    else if (param=='AngularSpeedPitch' || param=='AngSpeedPitch' || param=='AngSpeedYaw-Pitch' || param=='AngularSpeed-Pitch')
        AngularSpeed.Pitch=value;
    else if (param=='AngularSpeedRoll' || param=='AngSpeedRoll' || param=='AngSpeedYaw-Roll' || param=='AngularSpeed-Roll')
        AngularSpeed.Roll=value;   
}
    
defaultproperties
{
    mechname="Movement_Mechanism"
    
    MechanismParams.Empty
    
    MechanismParams(0)=(ParamName="Location", ParamType=ParamType_Vector, ParamInfo="Vector. Read. Gets the location of the parent actor.")
    MechanismParams(1)=(ParamName="Rotation", ParamType=ParamType_Rotator, ParamInfo="Rotator. Read. Gets the rotation of the parent actor.")
    MechanismParams(2)=(ParamName="Speed", ParamType=ParamType_Vector, ParamInfo="Vector. Read, Write. Gets or sets the speed.")
    MechanismParams(3)=(ParamName="Speed-X", ParamType=ParamType_Float, ParamInfo="Float. Read, Write. Sets the speed on X axis.")
    MechanismParams(4)=(ParamName="Speed-Y", ParamType=ParamType_Float, ParamInfo="Float. Read, Write. Sets the speed on Y axis.")
    MechanismParams(5)=(ParamName="Speed-Z", ParamType=ParamType_Float, ParamInfo="Float. Read, Write. Sets the speed on Z axis.")
    MechanismParams(6)=(ParamName="AngularSpeed", ParamType=ParamType_Rotator, ParamInfo="Rotator. Read, Write. Gets or sets the angular speed.")
    MechanismParams(7)=(ParamName="AngularSpeed-Yaw", ParamType=ParamType_Float, ParamInfo="Float. Read, Write. Sets the angular speed on Yaw axis.")
    MechanismParams(8)=(ParamName="AngularSpeed-Pitch", ParamType=ParamType_Float, ParamInfo="Float. Read, Write. Sets the angular speed on Pitch axis.")
    MechanismParams(9)=(ParamName="AngularSpeed-Roll", ParamType=ParamType_Float, ParamInfo="Float. Read, Write. Sets the angular speed on Roll axis.")
    
    ParamSource(0)=(ParamName="Location")
    ParamSource(1)=(ParamName="Speed")
    ParamSource(2)=(ParamName="Speed-X")
    ParamSource(3)=(ParamName="Speed-Y")
    ParamSource(4)=(ParamName="Speed-Z")
    ParamSource(5)=(ParamName="AngularSpeed")
    ParamSource(6)=(ParamName="AngularSpeed-Yaw")
    ParamSource(7)=(ParamName="AngularSpeed-Pitch")
    ParamSource(8)=(ParamName="AngularSpeed-Roll")
}
