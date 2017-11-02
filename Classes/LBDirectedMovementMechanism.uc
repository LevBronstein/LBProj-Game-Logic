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
    
    if (LBSMPhysicsActor(parent)!=none)
    { 
        v=ForwardSpeed*kForwardSpeed*Vector(MoveDirection);
        parent.CollisionComponent.SetRBLinearVelocity(v);
    }
    
    if (LBSKMPhysicsActor(parent)!=none)
    {
        v=ForwardSpeed*kForwardSpeed*Vector(MoveDirection);
        parent.CollisionComponent.SetRBLinearVelocity(v);    
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
    if (param=='ForwardSpeed' || param== 'FwdSpeed')
        ForwardSpeed=value; 
    else if (param=='kForwardSpeed' || param== 'kFwdSpeed')
        kForwardSpeed=value; 
    else if (param=='MoveDirection-Yaw' || param=='MoveDirectionYaw' || param== 'MoveDir-Yaw')
        MoveDirection.Yaw=value*DegToUnrRot;
    else if (param=='MoveDirection-Pitch' ||  param=='MoveDirectionPitch'|| param== 'MoveDir-Pitch')
        MoveDirection.Pitch=value*DegToUnrRot;  
    else if (param=='MoveDirection-Roll'|| param=='MoveDirectionRoll' || param== 'MoveDir-Roll')
        MoveDirection.Roll=value*DegToUnrRot;    
    else
        super.SetParamFloat(param, value, priority);
}
    
function SetParamVector(name param, vector value, optional int priority=0)
{
    if (param=='MoveDirection' || param== 'MovementDirection')
    {
        MoveDirection=Rotator(value);        
    } 
    else
         super.SetParamVector(param, value, priority);
}

function SetParamRotator(name param, rotator value, optional int priority=0)
{
    if (param=='MoveDirection' || param== 'MovementDirection')
        MoveDirection=value;  
    else
        super.SetParamRotator(param, value, priority);
}

function rotator GetParamRotator(name param)
{    
    if (param=='MoveDirection' || param== 'MovementDirection')
        return MoveDirection;
    else 
        return super.GetParamRotator(param);    
}

function float GetParamFloat(name param)
{
    if (param=='ForwardSpeed' || param== 'FwdSpeed')
        return ForwardSpeed;
    else if (param=='MoveDirection-Yaw' || param=='MoveDirectionYaw' || param== 'MoveDir-Yaw')
        return MoveDirection.Yaw*UnrRotToDeg;
    else if (param=='MoveDirection-Pitch' || param=='MoveDirectionPitch' || param== 'MoveDir-Pitch')
        return MoveDirection.Pitch*UnrRotToDeg;  
    else if (param=='MoveDirection-Roll' || param=='MoveDirectionRoll' || param== 'MoveDir-Roll')
       return MoveDirection.Roll*UnrRotToDeg;   
    else 
        return super.GetParamFloat(param);   
}  
    
defaultproperties
{
    mechname="Directed_Movement_Mechanism"
    
    ForwardSpeed=1.0f
    kForwardSpeed=100.0f
    
    MechanismParams.Add((ParamName="ForwardSpeed", ParamType=ParamType_Float, ParamInfo="Float. Read, write. Sets the forward speed."))
    MechanismParams.Add((ParamName="kForwardSpeed", ParamType=ParamType_Float, ParamInfo="Float. Read, write. Sets the @kforward speed."))
    MechanismParams.Add((ParamName="MoveDirection", ParamType=ParamType_Rotator, ParamInfo="Rotator. Read, write. Sets the @MoveDirection value."))
    MechanismParams.Add((ParamName="MoveDirectionYaw", ParamType=ParamType_Float, ParamInfo="Float. Read, write. Sets the @MoveDirection Yaw component."))
    MechanismParams.Add((ParamName="MoveDirectionPitch", ParamType=ParamType_Float, ParamInfo="Float. Read, write. Sets the @MoveDirection Pitch component.")) 
    MechanismParams.Add((ParamName="MoveDirectionRoll", ParamType=ParamType_Float, ParamInfo="Float. Read, write. Sets the @MoveDirection Roll component.")) 
    
    ParamSource.Add((ParamName="ForwardSpeed"))
    ParamSource.Add((ParamName="kForwardSpeed"))
    ParamSource.Add((ParamName="MoveDirection"))
    ParamSource.Add((ParamName="MoveDirectionYaw"))
    ParamSource.Add((ParamName="MoveDirectionPitch"))
    ParamSource.Add((ParamName="MoveDirectionRoll"))

}
