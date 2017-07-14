/**
 *  LBTargetedCameraModifier
 *
 *  Creation date: 14.07.2017 14:09
 *  Copyright 2017, Win10
 */
class LBTargetedCameraModifier extends LBTransposeMechanism;

enum LBTargetCameraModes
{
    LBTargetCameraModes_TargetPoint,
    LBTargetCameraModes_TargetActor,
};

var (LBTargetedCamera) LBTargetCameraModes CameraTargetMode;
var (LBTargetedCamera) Actor TargetActor;
var (LBTargetedCamera) vector TargetPoint;

var (LBTargetedCameraOffset) vector LocationOffset;
var (LBTargetedCameraOffset) vector TargetOffset;
var (LBTargetedCameraOffset) rotator RotationOffset;

var (LBTargetedCameraMovement) vector TruckSpeed;
var (LBTargetedCameraMovement) rotator OrbitSpeed;

function vector CalcTargetLocation()
{
    local vector p;
    
    if (CameraTargetMode == LBTargetCameraModes_TargetPoint)
    {
        p=TargetPoint+TargetOffset;
    }
    else
    {
        p = TargetActor.Location+TargetOffset;
    }   
    
    return p;    
}

function vector CalcCameraLocation(vector target)
{
    local vector l;
    
    l=GetOrientedLocation(LocationOffset,RotationOffset,target);

    return l;
}

function rotator CaclCameraRotation(vector target)
{
    local vector v;
    local rotator r;    
 
    v=(target-parent.Location);
    r=rotator(v);
    
    return r;   
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

function PerformRotation(float dt)
{
    local vector t;
    local rotator r; 
 
    t=CalcTargetLocation();
    r=CaclCameraRotation(t);
    
    parent.SetRotation(r);
}

function ChangeTargetActor(actor a)
{
}

function SetParam(name param, object value, optional int priority=0)
{
    if (param == 'TargetActor')
    {
        TargetActor = Actor(value);
    }
}

function float GetParamFloat(name param)
{
    if (param == 'DistanceToTarget')
    {
        return 0;
    }
    else if (param == 'Location-X')
    {
        return parent.Location.X;
    }
    else if (param == 'Location-Y')
    {
        return parent.Location.Y;
    }
    else if (param == 'Location-Z')
    {
        return parent.Location.Z;
    }
    else if (param == 'Rotation-X')
    {
        return parent.Rotation.Yaw * UnrRotToDeg;
    }
    else if (param == 'Rotation-Y')
    {
        return parent.Rotation.Pitch * UnrRotToDeg;
    }
    else if (param == 'Rotation-Z')
    {
        return parent.Rotation.Roll * UnrRotToDeg;
    }
    else if (param == 'RotationOffset-X')
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
}

function SetParamFloat(name param, float value, optional int priority=0)
{
    local vector v;
    local rotator r;
        
    if (param == 'DistanceToTarget')
    {
        //what?!
    }
    else if (param == 'Location-X')
    {
        v = parent.Location;
        v.X = value;
        parent.SetLocation(v);
    }
    else if (param == 'Location-Y')
    {
        v = parent.Location;
        v.Y = value;
        parent.SetLocation(v);
    }
    else if (param == 'Location-Z')
    {
        v = parent.Location;
        v.Z = value;
        parent.SetLocation(v);
    }
    else if (param == 'Rotation-X')
    {
        r = parent.Rotation;
        r.Yaw = value * DegToUnrRot;
        parent.SetRotation(r);
    }
    else if (param == 'Rotation-Y')
    {
        r = parent.Rotation;
        r.Pitch = value * DegToUnrRot;
        parent.SetRotation(r);
    }
    else if (param == 'Rotation-Z')
    {
        r = parent.Rotation;
        r.Roll = value * DegToUnrRot;
        parent.SetRotation(r);
    }
    else if (param == 'RotationOffset-X')
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
}

function SetParamVector(name param, vector value, optional int priority=0)
{
    if (param == 'TargetPoint')
    {
        TargetPoint = value;
    }
    else if (param == 'LocationOffset')
    {
        LocationOffset = value;
    }
    //else if (param == 'Location')
    //{
    //    SetLocation(value);
    //}
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
    if (param == 'TargetPoint')
    {
        return TargetPoint;
    }
    else if (param == 'LocationOffset')
    {
        return LocationOffset;
    }
    else if (param == 'Location')
    {
        return parent.Location;
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
}

defaultproperties
{
    mechname="Targeted_Camera_Modifier"
}
