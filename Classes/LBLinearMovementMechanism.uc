/**
 *  LBLinearMovementMechanism
 *
 *  Creation date: 02.04.2016 22:27
 *  Copyright 2016, Windows7
 */
class LBLinearMovementMechanism extends LBMechanism;

var(ParamSource) name ForwardSpeedParam; //A name for a float param, that sets the FwdSpeed
var(ParamSource) name AngularSpeedParam; //A name for a float param, that sets the AngSpeed
var(LinearMovement) float FwdSpeed; //Forward speed if < 0 then moves backwards
var(LinearMovement) float kFwdSpeed; //Coefficient that modifies the FwdSpeed: k*FwdSpeed
var(LinearMovement) float AngSpeed; //Angular speed turns right or left if <0
var(LinearMovement) float kAngSpeed; //Coefficient that modifies the AngSpeed: k*AngSpeed
var(MechanismDebug) bool bShowDebugLines; //Display debug in game

var float currot;

function FirstTickInit()
{
    super.FirstTickInit();
}

event OwnerTick(float deltatime)
{
    super.OwnerTick(deltatime);
    
    if(benabled==false)
        return;
    
    if (bUseParamSource)
        GetParameters();
          
    PerformMovement();  
}

function PerformMovement()
{
    local vector v;
    local rotator r;
  
    r=rot(0,0,0);
    currot=parent.Rotation.Yaw * UnrRotToDeg;
    
    r.pitch=LBActor(parent).Rotation.pitch;
    r.roll=LBActor(parent).Rotation.roll;
    currot=currot+AngSpeed;
    
    r.yaw=currot*DegToUnrRot;
    parent.SetRotation(r);
    
    v=vect(0,0,0);
    v.x=FwdSpeed;
    v=v>>parent.rotation;
    
    v=v*kFwdSpeed;
    parent.MoveSmooth(v);
    //parent.Velocity=v;
    
    if (bShowDebugLines)
        parent.DrawDebugLine(parent.location+vect(0,0,25), parent.location+parent.Velocity+vect(0,0,25), 0, 255, 0);
    
    LogError(v@r*unrrottodeg@"|"@FwdSpeed@AngSpeed);
    
}

function GetParameters()
{
    //всё же как преобразовать в parentclass?
    if (LBActor(parent)!=none)
    {
        FwdSpeed=LBActor(parent).GetParamFloat(ParameterSource,ForwardSpeedParam);
        AngSpeed=LBActor(parent).GetParamFloat(ParameterSource,AngularSpeedParam);
        return;
    }
    if (LBPawn(parent)!=none)
    {
        FwdSpeed=LBPawn(parent).GetParamFloat(ParameterSource,ForwardSpeedParam);
        AngSpeed=LBPawn(parent).GetParamFloat(ParameterSource,AngularSpeedParam);
        return;
    }
}

defaultproperties
{
    ParameterSource=""
    bUseParamSource=false
    FwdSpeed=0
    kFwdSpeed=100
    AngSpeed=0
    kAngSpeed=1
    
    currot=0
}
