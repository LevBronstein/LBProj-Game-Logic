/**
 *  LBCamera
 *
 *  Creation date: 13.07.2016 20:30
 *  Copyright 2016, Windows7
 */
class LBCamera extends CameraActor;

enum LBCameraMode
{
    LBCameraMode_TargetPoint,
    LBCameraMode_TargetActor,
};

var (LBCamera) LBCameraMode CameraMode;
var (LBCamera) actor TargetActor;
var (LBCamera) vector TargetPoint;
var (LBCamera) vector LocationOffset;
var (LBCamera) float DistanceToTarget;
var (LBCamera) rotator RotationOffset;

event PostBeginPlay()
{
    super.PostBeginPlay();
}

event Tick(float deltatime)
{
    local vector p;
    local vector v;
    local rotator r;
    
    if (CameraMode == LBCameraMode_TargetPoint)
    {
        p = TargetPoint;
    }
    else
    {
        p = TargetActor.Location;
    }
        
    v = p - Location;
    v = ((vect(1,0,0) * DistanceToTarget) << RotationOffset) + p + LocationOffset;
    r = rotator(p - v);
    
    SetLocation(v);   
    SetRotation(r);
}

function float GetParamFloat(name mechanism, name param)
{
    if (mechanism == 'LBCamera')
    {
        if (param == 'DistanceToTarget')
        {
            return DistanceToTarget;
        }
        else if (param == 'Location-X')
        {
            return Location.X;
        }
        else if (param == 'Location-Y')
        {
            return Location.Y;
        }
        else if (param == 'Location-Z')
        {
            return Location.Z;
        }
        else if (param == 'Rotation-X')
        {
            return Rotation.Yaw * UnrRotToDeg;
        }
        else if (param == 'Rotation-Y')
        {
            return Rotation.Pitch * UnrRotToDeg;
        }
        else if (param == 'Rotation-Z')
        {
            return Rotation.Roll * UnrRotToDeg;
        }
        else if (param == 'RotationOffset-X')
        {
            `log (RotationOffset * unrrottodeg);
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
    }
}

function SetParamFloat(name mechanism, name param, float value)
{
    local vector v;
    local rotator r;
    
    if (mechanism == 'LBCamera')
    {
        if (param == 'DistanceToTarget')
        {
            DistanceToTarget = value;
        }
        else if (param == 'Location-X')
        {
            v = Location;
            v.X = value;
            SetLocation(v);
        }
        else if (param == 'Location-Y')
        {
            v = Location;
            v.Y = value;
            SetLocation(v);
        }
        else if (param == 'Location-Z')
        {
            v = Location;
            v.Z = value;
            SetLocation(v);
        }
        else if (param == 'Rotation-X')
        {
            r = Rotation;
            r.Yaw = value * DegToUnrRot;
            SetRotation(r);
        }
        else if (param == 'Rotation-Y')
        {
            r = Rotation;
            r.Pitch = value * DegToUnrRot;
            SetRotation(r);
        }
        else if (param == 'Rotation-Z')
        {
            r = Rotation;
            r.Roll = value * DegToUnrRot;
            SetRotation(r);
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
    }
}

function vector GetParamVector(name mechanism, name param)
{
    if (mechanism == 'LBCamera')
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
            return Location;
        }
    }
}

function SetParamVector(name mechanism, name param, vector value)
{
    if (mechanism == 'LBCamera')
    {
        if (param == 'TargetPoint')
        {
            TargetPoint = value;
        }
        else if (param == 'LocationOffset')
        {
            LocationOffset = value;
        }
        else if (param == 'Location')
        {
            SetLocation(value);
        }
    }
}

function rotator GetParamRotator(name mechanism, name param)
{
    if (mechanism == 'LBCamera')
    {
        if (param == 'RotationOffset')
        {
            return RotationOffset;
        }
    }
}

function SetParamRotator(name mechanism, name param, rotator value)
{
    if (mechanism == 'LBCamera')
    {
        if (param == 'RotationOffset')
        {
            RotationOffset = value;
        }
    }
}

function SetParam(name mechanism, name param, object value)
{
    if (mechanism == 'LBCamera')
    {
        if (param == 'TargetActor')
        {
            TargetActor = Actor(value);
        }
    }
}

defaultproperties
{
    Physics=PHYS_Flying 
    
    DistanceToTarget=128
}
