/**
 *  LBTargetedCameraModifier
 *
 *  Creation date: 14.07.2017 14:09
 *  Copyright 2017, Win10
 */
class LBThirdPersonCameraModifier extends LBTargetCameraModifier;

var (LBTargetedCameraOffset) vector LocationOffset;
var (LBTargetedCameraOffset) rotator RotationOffset;

var (LBTargetedCameraMovement) vector TruckSpeed;
var (LBTargetedCameraMovement) rotator OrbitSpeed;


function vector CalcCameraLocation(vector target)
{
    local vector l;
    
    l=GetOrientedLocation(LocationOffset,RotationOffset,target);

    return l;
}

function UpdateOffset(float dt)
{
    if (bTickIndependent)
        LocationOffset=LocationOffset+TickIndependentVector(TruckSpeed,dt,MovementTimeScale);
    else
        LocationOffset=LocationOffset+TruckSpeed;
    
    if (bTickIndependent)
        RotationOffset=RotationOffset+TickIndependentRotator(OrbitSpeed,dt,RotationTimeScale);  
    else
        RotationOffset=RotationOffset+OrbitSpeed; 
}

function PerfromTick(float dt) 
{   
    UpdateOffset(dt);
    
    super.PerfromTick(dt); 
}
    
function PerformMovement(float dt)
{
    local vector t;
    local vector l;
    
    t=CalcTargetLocation();
    l=CalcCameraLocation(t);
    
    parent.SetLocation(l);
}

function ChangeTargetActor(actor a)
{
}

function float GetParamFloat(name param)
{
    if (param == 'RotationOffset-X')
    {
        return RotationOffset.Yaw * UnrRotToDeg;
    }
    else if (param == 'RotationOffset-Y')
    {
        return RotationOffset.Pitch * UnrRotToDeg;
    }
    else if (param == 'RotationOffset-Z')
    {
        return RotationOffset.Roll * UnrRotToDeg;
    }
    else if (param == 'LocationOffset-X')
    {
        return LocationOffset.X;
    }
    else if (param == 'LocationOffset-Y')
    {
        return LocationOffset.Y;
    }
    else if (param == 'LocationOffset-Z')
    {
        return LocationOffset.Z;
    }
    else if (param == 'TruckSpeed-X')
    {
        return TruckSpeed.X;
    }
    else if (param == 'TruckSpeed-Y')
    {
        return TruckSpeed.Y;
    }
    else if (param == 'TruckSpeed-Z')
    {
        return TruckSpeed.Z;
    }
    else if (param == 'OrbitSpeed-X')
    {
        return OrbitSpeed.Yaw * UnrRotToDeg;
    }
    else if (param == 'OrbitSpeed-Y')
    {
        return OrbitSpeed.Pitch * UnrRotToDeg;
    }
    else if (param == 'OrbitSpeed-Z')
    {
        return OrbitSpeed.Roll * UnrRotToDeg; 
    }
    else
    {
        return super.GetParamFloat(param);    
    }
}

function SetParamFloat(name param, float value, optional int priority=0)
{
    local vector v;
    local rotator r;
        
    if (param == 'RotationOffset-X')
    {
        RotationOffset.Yaw = value * DegToUnrRot;
    }
    else if (param == 'RotationOffset-Y')
    {
        RotationOffset.Pitch = value * DegToUnrRot;
    }
    else if (param == 'RotationOffset-Z')
    {
        RotationOffset.Roll = value * DegToUnrRot;
    }
    else if (param == 'LocationOffset-X')
    {
        LocationOffset.X = value;
    }
    else if (param == 'LocationOffset-Y')
    {
        LocationOffset.Y = value;
    }
    else if (param == 'LocationOffset-Z')
    {
        LocationOffset.Z = value;
    }
    else if (param == 'TruckSpeed-X')
    {
        TruckSpeed.X = value;
    }
    else if (param == 'TruckSpeed-Y')
    {
        TruckSpeed.Y = value;
    }
    else if (param == 'TruckSpeed-Z')
    {
        TruckSpeed.Z = value;
    }
    else if (param == 'OrbitSpeed-X')
    {
        OrbitSpeed.Yaw = value * DegToUnrRot;
    }
    else if (param == 'OrbitSpeed-Y')
    {
        OrbitSpeed.Pitch = value * DegToUnrRot;
    }
    else if (param == 'OrbitSpeed-Z')
    {
        OrbitSpeed.Roll = value * DegToUnrRot; 
    }
    else 
    {
        super.SetParamFloat(param, value, priority);
    }
}

function SetParamRotator(name param, rotator value, optional int priority=0)
{
    if (param == 'RotationOffset')
    {
        RotationOffset = value;
    }
}

function vector GetParamVector(name param)
{
    if (param == 'LocationOffset')
    {
        return LocationOffset;
    }
    else if (param == 'Location')
    {
        return parent.Location;
    }
    else
    {
        return super.GetParamVector(param); 
    }
}

function rotator GetParamRotator(name param)
{
    if (param == 'RotationOffset')
    {
        return RotationOffset;
    }
    else if (param == 'Rotation')
    {
        return parent.Rotation;    
    }
    else
    {
        return super.GetParamRotator(param); 
    }
}

defaultproperties
{
    mechname="ThirdPerson_Camera_Modifier"
}
