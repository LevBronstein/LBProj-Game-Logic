/**
 *  LBTargetCameraModifier
 *
 *  Creation date: 13.10.2017 00:51
 *  Copyright 2017, Win10
 */
class LBTargetCameraModifier extends LBTransposeMechanism;

struct PawnMeshSocket
{
    var() pawn Pawn;
    var() name Socket;    
};

enum LBTargetCameraModes
{
    LBTargetCameraModes_TargetPoint,
    LBTargetCameraModes_TargetActor,
    LBTargetCameraModes_MeshSocket,
};

var (LBTargetedCamera) LBTargetCameraModes CameraTargetMode;
var (LBTargetedCamera) Actor TargetActor;
var (LBTargetedCamera) vector TargetPoint;
var (LBTargetedCamera) PawnMeshSocket TargetPawnMeshSocket;

var (LBTargetedCameraOffset) vector TargetOffset;

function vector CalcTargetLocation()
{
    local vector p;
    local vector l;
    local rotator r;
    
    if (CameraTargetMode == LBTargetCameraModes_TargetPoint)
    {
        p=TargetPoint+TargetOffset;
    }
    else if (CameraTargetMode == LBTargetCameraModes_TargetActor)
    {
        p=TargetActor.Location+TargetOffset;
    } 
    else if (CameraTargetMode == LBTargetCameraModes_MeshSocket)
    {
        if (TargetPawnMeshSocket.Pawn!=none && TargetPawnMeshSocket.Pawn.Mesh.GetSocketWorldLocationAndRotation(TargetPawnMeshSocket.Socket, l, r, 0)==true)
        {
            p=l+TargetOffset;
        }   
        else
        {
            if (TargetPawnMeshSocket.Pawn!=none)
                p=TargetPawnMeshSocket.Pawn.Location;  
            else
                p=vect(0,0,0);  
        } 
    }
    
    return p;    
}

function rotator CaclCameraRotation(vector target)
{
    local vector v;
    local rotator r;    
 
    v=(target-parent.Location);
    r=rotator(v);
    
    return r;   
}

function PerformRotation(float dt)
{
    local vector t;
    local rotator r; 
 
    t=CalcTargetLocation();
    r=CaclCameraRotation(t);
    
    parent.SetRotation(r);
}

function SetParam(name param, object value, optional int priority=0)
{
    if (param == 'TargetActor')
    {
        TargetActor = Actor(value);
    }
}

function SetParamVector(name param, vector value, optional int priority=0)
{
    if (param == 'TargetPoint')
    {
        TargetPoint = value;
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
    else
    {
        return super.GetParamFloat(param);    
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
    else 
    {
        super.SetParamFloat(param, value, priority);
    }
}

function vector GetParamVector(name param)
{
    if (param == 'TargetPoint')
    {
        return TargetPoint;
    }
}

function rotator GetParamRotator(name param)
{
    if (param == 'Rotation')
    {
        return parent.Rotation;    
    }
}

defaultproperties
{
    mechname="Targeted_Camera_Modifier"
}