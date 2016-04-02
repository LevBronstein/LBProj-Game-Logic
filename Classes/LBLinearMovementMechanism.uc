/**
 *  LBLinearMovementMechanism
 *
 *  Creation date: 02.04.2016 22:27
 *  Copyright 2016, Windows7
 */
class LBLinearMovementMechanism extends LBMechanism;

var(ParamSource) name ParameterSource;
var(ParamSource) name ForwardSpeedParam;
var(ParamSource) name AngularSpeedParam;
var(ParamSource) bool bUseParamSource;
var(LinearMovement) float FwdSpeed;
var(LinearMovement) float AngSpeed;

event OwnerTick(float deltatime)
{
    super.OwnerTick(deltatime);
    
    if(benabled==false)
        return;
    
    PerformMovement();
    if (bUseParamSource)
    GetParameters();
}

function PerformMovement()
{
    local vector v;
    local rotator r;
    
    v.x=FwdSpeed;
    v=v<<parent.rotation;
    r=parent.rotation;
    r.yaw+=AngSpeed*DegToUnrRot;
    parent.Move(v);
    parent.SetRotation(r);
}

function GetParameters()
{
    //всё же как преобразовать в parentclass?
    FwdSpeed=LBActor(parent).GetParamFloat(ParameterSource,ForwardSpeedParam);
    AngSpeed=LBActor(parent).GetParamFloat(ParameterSource,AngularSpeedParam);
}

defaultproperties
{
    ParameterSource=''
    bUseParamSource=false
    FwdSpeed=0
    AngSpeed=0
}
