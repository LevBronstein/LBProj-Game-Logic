/**
 *  LBFloatingMovementMechanism
 *
 *  Creation date: 22.12.2016 21:01
 *  Copyright 2016, Windows7
 */
class LBFloatingMovementMechanism extends LBDirectedMovementMechanism;

var(FloatingMovement) float AttitudeZ;
var(FloatingMovement) float MaxSpeedZ;

function PerformMovement(float dt) 
{
    local vector v;

    if (LBSMPhysicsActor(parent)!=none || LBSKMPhysicsActor(parent)!=none)
    {
        v=ForwardSpeed*kForwardSpeed*Vector(MoveDirection);
        
        if (GetParentLocation().z < AttitudeZ || GetParentLocation().z > AttitudeZ)
        {
            v.z=Fclamp(AttitudeZ-GetParentLocation().z,-MaxSpeedZ,MaxSpeedZ);
        }
 
        parent.CollisionComponent.SetRBLinearVelocity(v); 
    }
    else
    {
        super.PerformMovement(dt);
    }
}

function PerformRotation(float dt)
{
    if (LBSMPhysicsActor(parent)!=none || LBSKMPhysicsActor(parent)!=none)
    {
    }
    else
        parent.SetRotation(MoveDirection);
}

function SetParamFloat(name param, float value, optional int priority=0)
{
    super.SetParamFloat(param, value, priority);
    
    if (param=='AttitudeZ' || param== 'Attitude-Z')
        AttitudeZ=value;  
}
    
function float GetParamFloat(name param)
{
    if (param=='AttitudeZ' || param== 'Attitude-Z')
    {
        return AttitudeZ;
    }
    else
        return super.GetParamFloat(param);    
}  

defaultproperties
{
    MaxSpeedZ=100;
}