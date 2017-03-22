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

event OwnerTick(float deltatime)
{
    super.OwnerTick(deltatime);
    
    if (benabled == false)
        return;
        
    PerformTick(deltatime);
}

function PerformTick(float dt)
{
    if (bEnableMovement) 
        PerformMovement(dt);
        
    if (bEnableRotation) 
        PerformRotation(dt);    
}

function PerformMovement(float dt)
{
}

function PerformRotation(float dt)
{     
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

function SetParamBool(name param, bool value, optional int priority=0)
{
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
    bEnableMovement=true
    bEnableRotation=true
}
