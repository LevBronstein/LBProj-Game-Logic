/**
 *  LBFloatingPhysImpulseMechanism
 *
 *  Creation date: 10.08.2017 00:12
 *  Copyright 2017, Win10
 */
class LBFloatingPhysImpulseMechanism extends LBDirectedPhysImpulseMechanism;

var(FloatingMovement) float AttitudeZ;
var(FloatingMovement) float UpImpulseZ;
var(FloatingMovement) float AnitGravityImpulseZ;
 
function PerformMovement(float dt) 
{
    local float k;
    local vector impulse;

    super.PerformMovement(dt);
    
    if (parent.Location.Z<AttitudeZ)
    {
        impulse.Z=-parent.Velocity.Z+UpImpulseZ;
    }
    else
    {
        impulse.Z=-parent.Velocity.Z+AnitGravityImpulseZ;       
    }
    
    if (LBSMPhysicsActor(parent)!=none)
    { 
        //LBSMPhysicsActor(parent).CollisionComponent.AddImpulse(impulse);
        LBSMPhysicsActor(parent).CollisionComponent.AddForce(impulse);    
    }
    if (LBSKMPhysicsActor(parent)!=none)
    {
        //LBSKMPhysicsActor(parent).CollisionComponent.SetRBPosition(parent.location*vect(1,1,0)+vect(0,0,64));
        LBSMPhysicsActor(parent).CollisionComponent.AddForce(impulse);  
        
    } 
}

function SetParamFloat(name param, float value, optional int priority=0)
{
    super.SetParamFloat(param, value, priority);
    
    if (param=='UpImpulseZ' || param== 'UpImpulse-Z')
        UpImpulseZ=value; 
     else if (param=='AnitGravityImpulseZ' || param== 'AnitGravityImpulse-Z')
        AnitGravityImpulseZ=value;
    else if (param=='AttitudeZ' || param== 'Attitude-Z')
        AttitudeZ=value;  
}
    
function float GetParamFloat(name param)
{
    if (param=='UpImpulseZ' || param== 'UpImpulse-Z')
        return UpImpulseZ;
    else if (param=='AnitGravityImpulseZ' || param== 'AnitGravityImpulse-Z')
    {
        return AnitGravityImpulseZ;
    }
    else if (param=='AttitudeZ' || param== 'Attitude-Z')
    {
        return AttitudeZ;
    }
    else
        return super.GetParamFloat(param);    
}  

defaultproperties
{
    AnitGravityImpulseZ=66;
    UpImpulseZ=67;
    Attitude-Z=256;
}
