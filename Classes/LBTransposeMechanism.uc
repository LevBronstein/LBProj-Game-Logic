/**
 *  LBTransposeMechanism
 *
 *  Creation date: 01.02.2017 01:16
 *  Copyright 2017, Windows7
 */
class LBTransposeMechanism extends LBInteractableMechanism;

enum CoordinateTypes
{
    /*The default coordinate type, when the point location is calculated
    in global coordinates*/
    CoordinateType_World,
    /*Local coordinates, it means that the base actor's location is
    added to the point location*/
    CoordinateType_Local,
    /*Local oriented coordinates, it means that the point location
    is projected into base actor's local coordinate system with
    certain orientation (GetAxes is used)*/
    CoordinateType_LocalOriented,
};

var(MovementClamps) bool bEnableMovement;
var(MovementClamps) bool bEnableRotation;
var(MovementClamps) bool bPreserveRotation; //A pure hack, which allows the pawn not to perform weird rotations, when @PerformRotation is not executed

var(MovementTransformOrder) bool bRotateFirst;

var(MovementSynchronization) bool bTickIndependent;
var(MovementSynchronization) float MovementTimeScale; //A value, x, which affects 1/x (unit / second) ratio
var(MovementSynchronization) float RotationTimeScale; //A value, x, which affects 1/x (degree / second) ratio

var(MechanismDebug) bool bShowDebugGraphics;

//event OwnerTick(float deltatime)
//{
//    `log(mechname$" before getparams bEnabled:"$benabled);
//  
//    GetParameters();
//    
//    PerfromTick(deltatime); 
//
//    `log(mechname$" after getparams bEnabled:"$benabled);    
//}

function PerfromTick(float dt)
{
    if (bRotateFirst)
    {
        if (bEnableRotation) 
            PerformRotation(dt);
        else   
        {
            if (bPreserveRotation)
                PreserveRotation(dt);    
        }
            
        if (bEnableMovement) 
            PerformMovement(dt);       
    }
    else   
    {
        if (bEnableMovement) 
            PerformMovement(dt);
            
        if (bEnableRotation) 
            PerformRotation(dt); 
        else   
        {
            if (bPreserveRotation)
                PreserveRotation(dt);    
        }
    }
}

function PerformMovement(float dt)
{
}

function PerformRotation(float dt)
{  
}

function PreserveRotation(float dt)
{
}

function PerformPhysics(float dt)
{
}

function SetParentLocation(vector v)
{
    parent.SetLocation(v);
}

function SetParentRotation(rotator r)
{
    parent.SetRotation(r);
}

function AddParentLocation(vector v, optional bool bTickIndependent=TRUE, optional float deltatime=1, optional float seconds=1)
{
    if (bTickIndependent)
        parent.SetLocation(parent.Location+TickIndependentVector(v,deltatime,seconds));
    else
        parent.SetLocation(parent.Location+v);
}

function AddParentRotation(rotator r, optional bool bTickIndependent=TRUE, optional float deltatime=1, optional float seconds=1)
{
    if (bTickIndependent)
        parent.SetRotation(parent.Rotation+TickIndependentRotator(r,deltatime,seconds));
    else
        parent.SetRotation(parent.Rotation+r);
}

function vector GetLocalLocation(vector p, vector base)
{
    return base+p;        
}

function vector GetOrientedLocation(vector p, rotator dir, vector base)
{
    local vector X, Y, Z;  
    local vector v;
    
    GetAxes(dir,X,Y,Z);
    v=base+X*p.X+Y*p.Y+Z*p.Z;
    
    return v; 
}

/*Interp value-retrievemnt functions
Supported types of interpolation:
-- Linear interpolation float (units, degrees)
*/

function float LinearInerpFloatValue(float current, float target, float step, float dt)
{
    local float value;
    
    if (abs(current - target) > abs(step))
    {
        if (current < target)
            value=current+abs(step); 
        else
            value=current-abs(step);   
    }
    else
    {
        if (current < target)
            value=current+abs(current - target); 
        else
            value=current-abs(current - target);      
    }
        
     return value;
}

function float LinearInterpAngle(float current, float target, float step, float dt)
{
    local float value;
    local float sign;
    
    if (current < target)
    {
        if (abs(target-current) < 180)
        {
            if (abs(current - target) > abs(step))
                value=current+step;
            else
                value=current+abs(current - target);
        }
        else
        {
            if (abs(current - target) > abs(step))
                value=current-step;
            else
                value=current-abs(current - target);
            
            if (value < 0)
                value=value+360;
        }    
    }
    else
    {
        if (abs(target-current) < 180)
        {
            if (abs(current - target) > abs(step))
                value=current-step;
            else
                value=current-abs(current - target);
        }
        else
        {
            if (abs(current - target) > abs(step))
                value=current+step;
            else
                value=current+abs(current - target);
            
            if (value > 360)
                value=value-360;
        }        
    }
    
    return value;
}

function vector LinearInerpVectorValue(vector current, vector target, float step, float dt)
{
    local vector value;
    local vector v;
    
    v=Normal(target-current);
    
    if (VSize(current - target) > VSize(v*step))
    {
        value=current+v*step; 
    }
    else
    {
        value=current+(current - target);   
    }
        
     return value;
}


/*Tick independent value-retrievemnt functions
Works like (<DeltaTime>/<Time in seconds>)*<Value>, where <Value> is instant value
*/

function int TickIndependentInt(int i, float deltatime, float seconds)
{
    return int((deltatime/seconds) * i);
}

function float TickIndependentFloat(float f, float deltatime, float seconds)
{
    return (deltatime/seconds) * f;
}

function vector TickIndependentVector(vector v, float deltatime, float seconds)
{
    return (deltatime/seconds) * v;
}

function rotator TickIndependentRotator(rotator r, float deltatime, float seconds)
{
    return (deltatime/seconds) * r;
}

function vector GetParamVector(name param)
{
    if (param=='Location' || param=='Parent-Location')
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
    if (param=='Rotation' || param=='Parent-Rotation')
    {
        return parent.Rotation;
    }
    else
    {
        return super.GetParamRotator(param);    
    }
} 

function SetParamBool(name param, bool value, optional int priority=0)
{
    super.SetParamBool(param, value, priority);
    
    if (param=='bEnabled')
    {
        bEnabled=value;
    }
    else if (param=='bEnableMovement')
    {
        bEnableMovement=value;
    }
    else if (param=='bEnableRotation')
    {
        bEnableRotation=value;    
    }
}

defaultproperties
{
    bTickIndependent=true
 
    MovementTimeScale=0.01
    RotationTimeScale=0.01
    
    bEnableMovement=true
    bEnableRotation=true
    bPreserveRotation=true
    
    MechanismParams.Add((ParamName="bEnableMovement", ParamType=ParamType_Boolean, ParamInfo="Boolean. Read, write. Enables or disables movement."))
    MechanismParams.Add((ParamName="bEnableRotation", ParamType=ParamType_Boolean, ParamInfo="Boolean. Read, write. Enables or disables rotation."))
    
    ParamSource.Add((ParamName="bEnableMovement"))
    ParamSource.Add((ParamName="bEnableRotation"))
}
