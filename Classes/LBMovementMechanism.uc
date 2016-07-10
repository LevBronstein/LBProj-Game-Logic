/**
 *  LBMovementMechanism
 *
 *  Creation date: 31.05.2016 19:18
 *  Copyright 2016, Windows7
 */
class LBMovementMechanism extends LBInteractableMechanism;

var(ParamSource) LBParamSourcePointer SpeedXSrc;
var(ParamSource) LBParamSourcePointer SpeedYSrc;
var(ParamSource) LBParamSourcePointer SpeedZSrc;
var(ParamSource) LBParamSourcePointer AngSpeedYawSrc;
var(ParamSource) LBParamSourcePointer AngSpeedPtichSrc;
var(ParamSource) LBParamSourcePointer AngSpeedRollSrc;

var(Movement) float SpeedX;
var(Movement) float SpeedY;
var(Movement) float SpeedZ;
var(Movement) float AngularSpeedYaw;
var(Movement) float AngularSpeedPitch;
var(Movement) float AngularSpeedRoll;

var(MechanismDebug) bool bShowDebugLines; //Display debug in game

var float currotY, currotP, currotR;

function FirstTickInit()
{
    super.FirstTickInit();
    
    currotY = parent.Rotation.Yaw * UnrRotToDeg;
    currotP = parent.Rotation.Pitch * UnrRotToDeg;
    currotR = parent.Rotation.Roll * UnrRotToDeg;
}

event OwnerTick(float deltatime)
{
    super.OwnerTick(deltatime);
    
    if (benabled == false)
        return;
        
    PerformMovement(); 
    PerformRotation(); 
}

function PerformMovement()
{
    local vector v;
    
    v.X = SpeedX;
    v.Y = SpeedY;
    v.Z = SpeedZ;
  
    parent.SetLocation(parent.location+v);
}

function PerformRotation()
{
    local rotator r;
    
    r.Yaw = parent.Rotation.Yaw + AngularSpeedYaw * DegToUnrRot;
    r.Pitch = parent.Rotation.Pitch + AngularSpeedPitch * DegToUnrRot;
    r.Roll = parent.Rotation.Roll + AngularSpeedRoll * DegToUnrRot;
    
    parent.SetRotation(r);
}

function GetParameters()
{
    if (SpeedXSrc.bUseSource)
    {
        SpeedX=GetTargetParamFloat(SpeedXSrc.SourceActor, SpeedXSrc.SourceMechanismName, SpeedXSrc.SourceParamName);
    }
    
    if (SpeedYSrc.bUseSource)
    {
        SpeedY=GetTargetParamFloat(SpeedYSrc.SourceActor, SpeedYSrc.SourceMechanismName, SpeedYSrc.SourceParamName);
    }
    
    if (SpeedZSrc.bUseSource)
    {
        SpeedZ=GetTargetParamFloat(SpeedZSrc.SourceActor, SpeedZSrc.SourceMechanismName, SpeedZSrc.SourceParamName);
    }
}

function vector GetParamVector(name param)
{
    if (param=='Location')
        return parent.Location;
}

function SetParamFloat(name param, float value, optional int priority=0)
{
    if (param=='SpeedX')
        SpeedX=value;
    else if (param=='SpeedY')
        SpeedY=value;
    else if (param=='SpeedZ')
        SpeedZ=value;
}
    
defaultproperties
{
    MechanismParams.Empty
    
    MechanismParams(0)=(ParamName="Location", ParamInfo="Vector. Read. Gets the location of the parent actor.")
    MechanismParams(1)=(ParamName="SpeedX", ParamInfo="Float. Read, Write. Sets the speed on X axis.")
    MechanismParams(2)=(ParamName="SpeedY", ParamInfo="Float. Read, Write. Sets the speed on Y axis.")
    MechanismParams(3)=(ParamName="SpeedZ", ParamInfo="Float. Read, Write. Sets the speed on Z axis.")

    mechname="Movement_Mechanism"
}
