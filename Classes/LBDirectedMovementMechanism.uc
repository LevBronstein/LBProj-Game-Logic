/**
 *  LBDirectedMovementMechanism
 *
 *  Creation date: 09.03.2017 00:48
 *  Copyright 2017, Windows7
 */
class LBDirectedMovementMechanism extends LBTransposeMechanism;

var(DirectedMovement) float ForwardSpeed;
var(DirectedMovement) float kForwardSpeed;
var(DirectedMovement) rotator MoveDirection;

function PerformMovement(float dt)
{   
    local vector v;
        
    if (LBActor(parent)!=none)
    {
        v=ForwardSpeed*kForwardSpeed*Vector(MoveDirection);
        parent.SetLocation(parent.location+v);   
    }
        
    if (LBPawn(parent)!=none)
    {
        v=ForwardSpeed*kForwardSpeed*Vector(MoveDirection);
        parent.Velocity=v;
    }
    
     if (bShowDebugGraphics)
        DGDisplaySpeedVector(parent, v);      
}

function PerformRotation(float dt)
{
    parent.SetRotation(MoveDirection);
}

function DGDisplaySpeedVector(actor a, vector v)
{
    local float r,h;
    a.GetBoundingCylinder(r,h);
    parent.DrawDebugLine(a.Location,a.Location+v*h,255,0,0);  
}

function DGDisplayVector(actor a, vector v, byte red, byte green, byte blue)
{
    local float r,h;
    a.GetBoundingCylinder(r,h);
    parent.DrawDebugLine(a.Location,a.Location+v*h,red,green,blue);  
}

function SetParamFloat(name param, float value, optional int priority=0)
{
    super.SetParamFloat(param, value, priority);
    
    if (param=='ForwardSpeed' || param== 'FwdSpeed')
        ForwardSpeed=value; 
    else if (param=='MoveDirection-Yaw' || param== 'MoveDir-Yaw')
        MoveDirection.Yaw=value*DegToUnrRot;
    else if (param=='MoveDirection-Pitch' || param== 'MoveDir-Pitch')
        MoveDirection.Pitch=value*DegToUnrRot;  
    else if (param=='MoveDirection-Roll' || param== 'MoveDir-Roll')
        MoveDirection.Roll=value*DegToUnrRot;    
}
    
function SetParamVector(name param, vector value, optional int priority=0)
{
    super.SetParamVector(param, value, priority);
    
    if (param=='MoveDirection' || param== 'MovementDirection')
    {
        MoveDirection=Rotator(value);        
    } 
}

function SetParamRotator(name param, rotator value, optional int priority=0)
{
    super.SetParamRotator(param, value, priority);
    
    if (param=='MoveDirection' || param== 'MovementDirection')
        MoveDirection=value;  
}

function rotator GetParamRotator(name param)
{
    local rotator r;
    
    r=super.GetParamRotator(param);
    
    if (param=='MoveDirection' || param== 'MovementDirection')
        return MoveDirection;
    else 
        return r;    
}

function float GetParamFloat(name param)
{
    local float f;
    
    f=super.GetParamFloat(param);
    
    if (param=='ForwardSpeed' || param== 'FwdSpeed')
        return ForwardSpeed;
    else if (param=='MoveDirection-Yaw' || param== 'MoveDir-Yaw')
        return MoveDirection.Yaw*UnrRotToDeg;
    else if (param=='MoveDirection-Pitch' || param== 'MoveDir-Pitch')
        return MoveDirection.Pitch*UnrRotToDeg;  
    else if (param=='MoveDirection-Roll' || param== 'MoveDir-Roll')
       return MoveDirection.Roll*UnrRotToDeg;   
    else 
        return f;    
}  
    
defaultproperties
{
    mechname="Directed_Movement_Mechanism"
    
    ForwardSpeed=1.0f
    kForwardSpeed=100.0f
}
