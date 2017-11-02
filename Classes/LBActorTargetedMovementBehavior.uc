/**
 *  LBActorFollowBehavior
 *
 *  Creation date: 03.11.2017 00:58
 *  Copyright 2017, Win10
 */
class LBActorTargetedMovementBehavior extends LBActorMovementBehaviorController;

var(TargetedMovementBehavior) vector MovementLocation;
var(TargetedMovementBehavior) float MinDistanceToMovementLocation;

var(TargetedMovementBehaviorSystem) vector TargetMask; //A mask to set any coord to 1 or 0 to exclude this coord from direction calculation

function vector GetTargetLocation()
{
    return MovementLocation;
}

function rotator GetTargetRotation()
{
    local vector v,m;
    local rotator r;
 
    v=MovementLocation-parent.location;

    m.X=FClamp(TargetMask.X,0,1); m.Y=FClamp(TargetMask.Y,0,1); m.Z=FClamp(TargetMask.Z,0,1);
    
    v=v*m;
    
    r=rotator(v);
    
    return r;
}

function int GetForwardMovement()
{
    local vector v,m;
 
    v=MovementLocation-parent.location;  
    `log(vsize(parent.Velocity));
    if (vsize(v)-MinDistanceToMovementLocation>=vsize(parent.Velocity))
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

function SetParamVector(name param, vector value, optional int priority=0)
{
    if (param=='MovementLocation' || param== 'MoveLoc')
        MovementLocation=value;    
    else
        super.SetParamVector(param, value, priority);
} 

function vector GetParamVector(name param)
{    
    if (param=='MovementLocation' || param== 'MoveLoc')
        return MovementLocation;
    else 
        return super.GetParamVector(param);    
}

function rotator GetParamRotator(name param)
{    
    if (param=='TargetRotation' || param== 'TargetRot')
        return TargetRotation;
    else 
        return super.GetParamRotator(param);    
}

function float GetParamFloat(name param)
{
    if (param=='ForwardMovement' || param== 'kForwardMovement')
        return ForwardMovement;
    else if (param=='MovementLocation-X' || param=='MovementLocationX' || param== 'MoveLocX' || param== 'MoveLoc-X')
        return MovementLocation.X;
    else if (param=='MovementLocation-Y' || param=='MovementLocationY' || param== 'MoveLocY' || param== 'MoveLoc-Y')
        return MovementLocation.Y;
    else if (param=='MovementLocation-Z' || param=='MovementLocationZ' || param== 'MoveLocZ' || param== 'MoveLoc-Z')
        return MovementLocation.Z;
    else
        return super.GetParamFloat(param);    
} 
    
//function bool PerformPawnMovement(float dt)
//{
//    local vector v;
//    local rotator r;
//    local bool b;
//   
//    v=vect(0,0,0); 
//
//    v=TargetLocation-parent.location;
//    v.z=0;
//    
//    r=RInterpTo(parent.rotation, rotator(normal(v)), dt, TurnSpeed*DegToUnrRot, true); //~9000!
//    
//    dRot=(r.Yaw-parent.Rotation.Yaw)*UnrRotToDeg;
// 
//    r.Pitch=0;
//    r.Roll=0;
//    
//    if (bEnableRotation)
//        parent.SetRotation(r);
//    
//    if (vsize(v)>=DistanceToStop)
//    {
//        v=normal(v);
//        
//        if (bEnableMovement)
//        {
//            parent.Velocity=normal(v)*ForwardSpeed*kForwardSpeed; 
//            b=true;
//        }
//        else
//            b=false;
//    }
//    else
//        b=false;
//    
//    if (bShowDebugLines)
//    {
//        parent.DrawDebugSphere(TargetLocation, 64, 16, 255, 0, 0);
//        parent.DrawDebugLine(parent.location+vect(0,0,32), TargetLocation, 255, 0, 0);
//    }
//    
//    return b;
//}


defaultproperties
{
    mechname="Actor_Movement_Behavior_Controller"
     
    TargetMask=(X=1,Y=1,Z=1);
    
    MechanismParams.Add((ParamName="ForwardMovement", ParamType=ParamType_Float, ParamInfo="Float. Read. Gets a value of -1, 0, 1 to be multiplied on your movement speed."))
    MechanismParams.Add((ParamName="TargetRotation", ParamType=ParamType_Rotator, ParamInfo="Rotator. Read. Gets the @TargetRotation value, which points to the movment location."))
    MechanismParams.Add((ParamName="MovementLocation", ParamType=ParamType_Vector, ParamInfo="Vector. Read, write. Gets or sets the @MovementLocation value."))
    
    ParamSource.Add((ParamName="MovementLocation"))
}
