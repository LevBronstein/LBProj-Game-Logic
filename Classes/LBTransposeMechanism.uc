/**
 *  LBTransposeMechanism
 *
 *  Creation date: 01.02.2017 01:16
 *  Copyright 2017, Windows7
 */
class LBTransposeMechanism extends LBInteractableMechanism;

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

function SetParamBool(name param, bool value, optional int priority=0)
{
    if (param=='bEnabled')
    {
        bEnabled=value;
    }
}

defaultproperties
{
    bEnableMovement=true
    bEnableRotation=true
}
