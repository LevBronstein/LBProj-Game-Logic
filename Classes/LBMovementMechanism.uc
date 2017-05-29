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
    if (LBActor(parent)!=none)
        parent.SetLocation(parent.location+ForwardSpeed);
    else if (LBPawn(parent)!=none)
        parent.Velocity=ForwardSpeed;  
    else if (LBSMPhysicsActor(parent)!=none)
        LBSMPhysicsActor(parent).CollisionComponent.SetRBPosition(parent.Location+ForwardSpeed);
    
}

function PerformRotation(float dt)
{    
    if (LBActor(parent)!=none || LBPawn(parent)!=none)
        parent.SetRotation(parent.Rotation+AngularSpeed);
    else if (LBSMPhysicsActor(parent)!=none)
        LBSMPhysicsActor(parent).CollisionComponent.SetRBRotation(parent.Rotation+AngularSpeed);
}

//function GetParameters()
//{
//    if (SpeedXSrc.bUseSource)
//    {
//        ForwardSpeed.X=GetTargetParamFloat(SpeedXSrc.SourceActor, SpeedXSrc.SourceMechanismName, SpeedXSrc.SourceParamName);
//    }
//    
//    if (SpeedYSrc.bUseSource)
//    {
//        ForwardSpeed.Y=GetTargetParamFloat(SpeedYSrc.SourceActor, SpeedYSrc.SourceMechanismName, SpeedYSrc.SourceParamName);
//    }
//    
//    if (SpeedZSrc.bUseSource)
//    {
//        ForwardSpeed.Z=GetTargetParamFloat(SpeedZSrc.SourceActor, SpeedZSrc.SourceMechanismName, SpeedZSrc.SourceParamName);
//    }
//    
//    if (AngSpeedYawSrc.bUseSource)
//    {
//        AngularSpeed.Yaw=GetTargetParamFloat(AngSpeedYawSrc.SourceActor, AngSpeedYawSrc.SourceMechanismName, AngSpeedYawSrc.SourceParamName);
//    }
//    
//    if (AngSpeedPitchSrc.bUseSource)
//    {
//        AngularSpeed.Pitch=GetTargetParamFloat(AngSpeedPitchSrc.SourceActor, AngSpeedPitchSrc.SourceMechanismName, AngSpeedPitchSrc.SourceParamName);
//    }
//    
//    if (AngSpeedRollSrc.bUseSource)
//    {
//        AngularSpeed.Roll=GetTargetParamFloat(AngSpeedRollSrc.SourceActor, AngSpeedRollSrc.SourceMechanismName, AngSpeedRollSrc.SourceParamName);
//    }
//}

function vector GetParamVector(name param)
{
    if (param=='Location')
        return parent.Location;
    else if (param=='Speed' || param=='ForwardSpeed' || param=='FwdSpeed')
        return ForwardSpeed;    
}
    
function SetParamVector(name param, vector value, optional int priority=0)
{
    if (param=='Speed' || param=='ForwardSpeed' || param=='FwdSpeed')
        ForwardSpeed=value;    
}     

function rotator GetParamRotator(name param)
{
    if (param=='Rotation')
        return parent.Rotation;
    else if (param=='AngSpeed' || param=='AngularSpeed')
        return AngularSpeed;    
}    
   
function SetParamRotator(name param, rotator value, optional int priority=0)
{
    if (param=='AngSpeed' || param=='AngularSpeed')
        AngularSpeed=value;    
}  
    
function SetParamFloat(name param, float value, optional int priority=0)
{
    if (param=='SpeedX' || param=='Speed-X')
        ForwardSpeed.X=value;
    else if (param=='SpeedY' || param=='Speed-Y')
        ForwardSpeed.Y=value;
    else if (param=='SpeedZ' || param=='Speed-Z')
        ForwardSpeed.Z=value;
    else if (param=='AngularSpeedYaw' || param=='AngSpeedYaw' || param=='AngSpeedYaw-Yaw')
        AngularSpeed.Yaw=value;
    else if (param=='AngularSpeedPitch' || param=='AngSpeedPitch' || param=='AngSpeedYaw-Pitch')
        AngularSpeed.Pitch=value;
    else if (param=='AngularSpeedRoll' || param=='AngSpeedRoll' || param=='AngSpeedYaw-Roll')
        AngularSpeed.Roll=value; 
     
    //`log(">>>>>>>>>>"@param@"->"@value);   
}
    
function SetParamBool(name param, bool value, optional int priority=0) 
{
    if (param=='bEnabled')
        benabled=value;
    else if (param=='bEnableMovement')
        bEnableMovement=value;
    else if (param=='bEnableRotation')
        bEnableRotation=value;
}
    
defaultproperties
{
    mechname="Movement_Mechanism"
    
    MechanismParams.Empty
    
    MechanismParams(0)=(ParamName="Location", ParamType=ParamType_Vector, ParamInfo="Vector. Read. Gets the location of the parent actor.")
    MechanismParams(1)=(ParamName="Rotation", ParamType=ParamType_Rotator, ParamInfo="Rotator. Read. Gets the rotation of the parent actor.")
    MechanismParams(2)=(ParamName="Speed", ParamType=ParamType_Vector, ParamInfo="Vector. Read, Write. Gets or sets the speed.")
    MechanismParams(3)=(ParamName="SpeedX", ParamType=ParamType_Float, ParamInfo="Float. Read, Write. Sets the speed on X axis.")
    MechanismParams(4)=(ParamName="SpeedY", ParamType=ParamType_Float, ParamInfo="Float. Read, Write. Sets the speed on Y axis.")
    MechanismParams(5)=(ParamName="SpeedZ", ParamType=ParamType_Float, ParamInfo="Float. Read, Write. Sets the speed on Z axis.")
    MechanismParams(6)=(ParamName="AngularSpeed", ParamType=ParamType_Rotator, ParamInfo="Rotator. Read, Write. Gets or sets the angular speed.")
    MechanismParams(7)=(ParamName="AngularSpeedYaw", ParamType=ParamType_Float, ParamInfo="Float. Read, Write. Sets the angular speed on Yaw axis.")
    MechanismParams(8)=(ParamName="AngularSpeedPitch", ParamType=ParamType_Float, ParamInfo="Float. Read, Write. Sets the angular speed on Pitch axis.")
    MechanismParams(9)=(ParamName="AngularSpeedRoll", ParamType=ParamType_Float, ParamInfo="Float. Read, Write. Sets the angular speed on Roll axis.")
    
    ParamSource(0)=(ParamName="Location")
    ParamSource(1)=(ParamName="Speed")
    ParamSource(2)=(ParamName="SpeedX")
    ParamSource(3)=(ParamName="SpeedY")
    ParamSource(4)=(ParamName="SpeedZ")
    ParamSource(5)=(ParamName="AngularSpeed")
    ParamSource(6)=(ParamName="AngularSpeedYaw")
    ParamSource(7)=(ParamName="AngularSpeedPitch")
    ParamSource(8)=(ParamName="AngularSpeedRoll")
}
