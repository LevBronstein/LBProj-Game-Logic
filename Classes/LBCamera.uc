/**
 *  LBCamera
 *
 *  Creation date: 13.07.2016 20:30
 *  Copyright 2016, Windows7
 */
class LBCamera extends CameraActor;

//enum LBCameraMode
//{
//    LBCameraMode_TargetPoint,
//    LBCameraMode_TargetActor,
//};
//
//enum LBTargetMode
//{
//    LBTargetMode_WorldCoordinates,
//    LBCameraMode_LocalCoordinates,
//};
//
//var (LBCamera) LBCameraMode CameraMode;
//var (LBCamera) LBTargetMode TargetMode;
//
//var (LBCamera) actor TargetActor;
//var (LBCamera) vector TargetPoint;
//
//var (LBCamera) vector LocationOffset;
//var (LBCamera) vector TargetOffset;
//var (LBCamera) rotator RotationOffset;
//
//var (Smooth) bool bSmooth;
//var (Smooth) float VInterpSpeed; //Interpolation speed for vectors
//var (Smooth) float RInterpSpeed; //Interpolation speed for rotator
//
//var(MovementSynchronization) bool bTickIndependent;
//var(MovementSynchronization) float MovementTimeScale;
// 
//event PostBeginPlay()
//{
//    super.PostBeginPlay();
//}
//
//event Tick(float deltatime)
//{
//    local vector t;
//    local vector l;
//    local rotator r;
//    
//    t=CalcTargetLocation();
//    l=CalcCameraLocation(t);
//    r=CaclCameraRotation(t);
//    
//    if (bSmooth)
//    {
//        SetLocation(VInterpTo(Location, l, DeltaTime, VInterpSpeed));  
//    }
//    else
//        SetLocation(l);
//    
//    if (bSmooth)
//    {
//        SetRotation(RInterpTo(Rotation, r, DeltaTime, RInterpSpeed*DegToUnrRot, true));    
//    }
//    else
//        SetRotation(r);
//}
//
//function vector CalcTargetLocation()
//{
//    local vector X, Y, Z;
//    local vector p;
//    
//    if (CameraMode == LBCameraMode_TargetPoint)
//    {
//        p = TargetPoint;
//    }
//    else
//    {
//        if (TargetMode == LBCameraMode_LocalCoordinates)
//        {
//            GetAxes(TargetActor.Rotation,X,Y,Z);
//            p = TargetActor.Location+TargetOffset.X*X+TargetOffset.Y*Y+TargetOffset.Z*Z;    
//        }
//        else
//            p = TargetActor.Location+TargetOffset;
//    }   
//    
//    return p;    
//}
//
//function vector CalcCameraLocation(vector target)
//{
//    local vector X, Y, Z;  
//    local vector l;
//  
//    GetAxes(RotationOffset,X,Y,Z);
//    
//    l=target+LocationOffset.X*X+LocationOffset.Y*Y+LocationOffset.Z*Z;
//    
//    return l;
//}
//
//function rotator CaclCameraRotation(vector target)
//{
//    local vector v;
//    local rotator r;    
// 
//    v=(target-Location);
//    r=rotator(v);
//    
//    return r;   
//}
//
//function float GetParamFloat(name mechanism, name param)
//{
//    if (mechanism == 'LBCamera')
//    {
//        if (param == 'DistanceToTarget')
//        {
//            return 0;
//        }
//        else if (param == 'Location-X')
//        {
//            return Location.X;
//        }
//        else if (param == 'Location-Y')
//        {
//            return Location.Y;
//        }
//        else if (param == 'Location-Z')
//        {
//            return Location.Z;
//        }
//        else if (param == 'Rotation-X')
//        {
//            return Rotation.Yaw * UnrRotToDeg;
//        }
//        else if (param == 'Rotation-Y')
//        {
//            return Rotation.Pitch * UnrRotToDeg;
//        }
//        else if (param == 'Rotation-Z')
//        {
//            return Rotation.Roll * UnrRotToDeg;
//        }
//        else if (param == 'RotationOffset-X')
//        {
//            return RotationOffset.Yaw * UnrRotToDeg;
//        }
//        else if (param == 'RotationOffset-Y')
//        {
//            return RotationOffset.Pitch * UnrRotToDeg;
//        }
//        else if (param == 'RotationOffset-Z')
//        {
//            return RotationOffset.Roll * UnrRotToDeg;
//        }
//        else if (param == 'LocationOffset-X')
//        {
//            return LocationOffset.X;
//        }
//        else if (param == 'LocationOffset-Y')
//        {
//            return LocationOffset.Y;
//        }
//        else if (param == 'LocationOffset-Z')
//        {
//            return LocationOffset.Z;
//        }
//    }
//}
//
//function SetParamFloat(name mechanism, name param, float value)
//{
//    local vector v;
//    local rotator r;
//    
//    if (mechanism == 'LBCamera')
//    {
//        if (param == 'DistanceToTarget')
//        {
//            //what?!
//        }
//        else if (param == 'Location-X')
//        {
//            v = Location;
//            v.X = value;
//            SetLocation(v);
//        }
//        else if (param == 'Location-Y')
//        {
//            v = Location;
//            v.Y = value;
//            SetLocation(v);
//        }
//        else if (param == 'Location-Z')
//        {
//            v = Location;
//            v.Z = value;
//            SetLocation(v);
//        }
//        else if (param == 'Rotation-X')
//        {
//            r = Rotation;
//            r.Yaw = value * DegToUnrRot;
//            SetRotation(r);
//        }
//        else if (param == 'Rotation-Y')
//        {
//            r = Rotation;
//            r.Pitch = value * DegToUnrRot;
//            SetRotation(r);
//        }
//        else if (param == 'Rotation-Z')
//        {
//            r = Rotation;
//            r.Roll = value * DegToUnrRot;
//            SetRotation(r);
//        }
//        else if (param == 'RotationOffset-X')
//        {
//            RotationOffset.Yaw = value * DegToUnrRot;
//        }
//        else if (param == 'RotationOffset-Y')
//        {
//            RotationOffset.Pitch = value * DegToUnrRot;
//        }
//        else if (param == 'RotationOffset-Z')
//        {
//            RotationOffset.Roll = value * DegToUnrRot;
//        }
//         else if (param == 'LocationOffset-X')
//        {
//            LocationOffset.X = value;
//        }
//        else if (param == 'LocationOffset-Y')
//        {
//            LocationOffset.Y = value;
//        }
//        else if (param == 'LocationOffset-Z')
//        {
//            LocationOffset.Z = value;
//        }
//    }
//}
//
//function vector GetParamVector(name mechanism, name param)
//{
//    if (mechanism == 'LBCamera')
//    {
//        if (param == 'TargetPoint')
//        {
//            return TargetPoint;
//        }
//        else if (param == 'LocationOffset')
//        {
//            return LocationOffset;
//        }
//        else if (param == 'Location')
//        {
//            return Location;
//        }
//    }
//}
//
//function SetParamVector(name mechanism, name param, vector value)
//{
//    if (mechanism == 'LBCamera')
//    {
//        if (param == 'TargetPoint')
//        {
//            TargetPoint = value;
//        }
//        else if (param == 'LocationOffset')
//        {
//            LocationOffset = value;
//        }
//        else if (param == 'Location')
//        {
//            SetLocation(value);
//        }
//    }
//}
//
//function rotator GetParamRotator(name mechanism, name param)
//{
//    if (mechanism == 'LBCamera')
//    {
//        if (param == 'RotationOffset')
//        {
//            return RotationOffset;
//        }
//    }
//}
//
//function SetParamRotator(name mechanism, name param, rotator value)
//{
//    if (mechanism == 'LBCamera')
//    {
//        if (param == 'RotationOffset')
//        {
//            RotationOffset = value;
//        }
//    }
//}
//
//function SetParam(name mechanism, name param, object value)
//{
//    if (mechanism == 'LBCamera')
//    {
//        if (param == 'TargetActor')
//        {
//            TargetActor = Actor(value);
//        }
//    }
//}

var(Mechanisms) instanced array<LBMechanism> AllMechanisms; //mechanisms used for this actor

event PostBeginPlay()
{
    super.PostBeginPlay();
    
    InitMechanisms();
}

function InitMechanisms()
{
    local int i;
    
    //init mechanisms
    for(i=0;i<AllMechanisms.length;i++)
    {
        if(AllMechanisms[i].parent==none)
            AllMechanisms[i].parent=self;
    }
}

function TickAllMechanisms(float deltatime)
{
    local int i;
    
    for(i=0;i<AllMechanisms.length;i++)
    {
        AllMechanisms[i].OwnerTick(deltatime);
    }
}

function LBMechanism GetMechanismByName(name mechname)
{
    local int i;
    
    for(i=0;i<AllMechanisms.length;i++)
    {
        if(AllMechanisms[i].mechname==mechname)
            return AllMechanisms[i];
    }
    return none;
}

function AnimNotifyAllMechanisms(AnimNodeSequence notifynode, AnimNotify notify)
{
    local int i;
    
    for(i=0;i<AllMechanisms.length;i++)
    {
        AllMechanisms[i].OwnerAnimNotify(notifynode,notify);
    }    
}

/********************** SET PARAM OVERLOADS **********************/

function SetParam(name mechanism, name param, object value)
{
    local LBMechanism m;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return;
        
    m.SetParam(param, value);    
}

function SetParams(name mechanism, name param, array<object> value)
{
    local LBMechanism m;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return;
        
    m.SetParams(param, value);    
}

function SetParamInt(name mechanism, name param, int value)
{
    local LBMechanism m;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return;
 
    m.SetParamInt(param, value);    
}

function SetParamFloat(name mechanism, name param, float value)
{
    local LBMechanism m;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return;
        
    m.SetParamFloat(param, value);    
}

function SetParamBool(name mechanism, name param, bool value)
{
    local LBMechanism m;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return;
        
    m.SetParamBool(param, value);    
}

function SetParamVector(name mechanism, name param, vector value)
{
    local LBMechanism m;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return;
        
    m.SetParamVector(param, value);    
}

function SetParamRotator(name mechanism, name param, rotator value)
{
    local LBMechanism m;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return;
        
    m.SetParamRotator(param, value);    
}

function SetParamName(name mechanism, name param, name value)
{
    local LBMechanism m;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return;
        
    m.SetParamName(param, value);    
}

/********************** GET PARAM OVERLOADS **********************/


function object GetParam(name mechanism, name param)
{
    local LBMechanism m;
    local object res;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return none;
        
    res=m.GetParam(param);    
    return res;
}

function array<object> GetParams(name mechanism, name param)
{
    local LBMechanism m;
    local array<object> res;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return res; //!!!
        
    res=m.GetParams(param);    
    return res;
}

function float GetParamFloat(name mechanism, name param)
{
    local LBMechanism m;
    local float res;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return 0;
        
    res=m.GetParamFloat(param);    
    return res;
}

function bool GetParamBool(name mechanism, name param)
{
    local LBMechanism m;
    local bool res;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return false;
        
    res=m.GetParamBool(param);    
    return res;
}

function int GetParamInt(name mechanism, name param)
{
    local LBMechanism m;
    local int res;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return 0;
        
    res=m.GetParamInt(param);    
    return res;
}

function vector GetParamVector(name mechanism, name param)
{
    local LBMechanism m;
    local vector res;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return vect(0,0,0);
        
    res=m.GetParamVector(param);    
    return res;
}

function rotator GetParamRotator(name mechanism, name param)
{
    local LBMechanism m;
    local rotator res;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return rot(0,0,0);
        
    res=m.GetParamRotator(param);    
    return res;
}

function name GetParamName(name mechanism, name param)
{
    local LBMechanism m;
    local name res;
    
    m=GetMechanismByName(mechanism);
    if(m==none)
        return '';
        
    res=m.GetParamName(param);    
    return res;
}

event Tick(float deltatime)
{
    TickAllMechanisms(deltatime);
}


defaultproperties
{
    Physics=PHYS_Flying 
}
