/**
 *  LBFloatingPhysImpulseMechanism
 *
 *  Creation date: 10.08.2017 00:12
 *  Copyright 2017, Win10
 */
class LBFloatingPhysImpulseMechanism extends LBDirectedMovementMechanism;

var(FloatingMovement) float AttitudeZ;
var(FloatingMovement) float MaxSpeedZ;

/*
* Вычислить AnitGravityImpulseZ можно при помощи следущего кода:
* impulse.Z=-parent.Velocity.Z+UpImpulseZ*fClamp((AttitudeZ-parent.Location.Z)/100,0.1,1);
* `log(impulse.Z);
*/

function PerformMovement(float dt) 
{
    local vector v;

    //super.PerformMovement(dt);
    
    v=ForwardSpeed*kForwardSpeed*Vector(MoveDirection);
    
    if (parent.Location.z < AttitudeZ || parent.Location.z > AttitudeZ)
    {
        v.z=Fclamp(256-parent.Location.z,-MaxSpeedZ,MaxSpeedZ);
    }
        
    parent.CollisionComponent.SetRBLinearVelocity(v);
    
    //if (parent.Location.Z<AttitudeZ)
    //{
    //    //impulse.Z=-parent.Velocity.Z+UpImpulseZ;
    //    impulse.Z=-parent.Velocity.Z+UpImpulseZ*fClamp((AttitudeZ-parent.Location.Z)/100,0.1,1);
    //    `log(impulse.Z);
    //}
    //else
    //{
    //    impulse.Z=AnitGravityImpulseZ;       
    //}
    
    //CalcAntigravImpulse(dt);

    //`log(parent.CollisionComponent.BodyInstance.GetBodyMass()*(parent.CollisionComponent.BodyInstance.Velocity-parent.CollisionComponent.BodyInstance.PreviousVelocity).z/dt);
    //impulse.Z=-parent.CollisionComponent.BodyInstance.GetBodyMass()*(parent.CollisionComponent.BodyInstance.Velocity-parent.CollisionComponent.BodyInstance.PreviousVelocity).z/dt;
    //impulse.Z=parent.CollisionComponent.BodyInstance.GetBodyMass()*256;
    `log(parent.Velocity);
    
    //`log(impulse);
    //impulse.Z=AnitGravityImpulseZ;
    //`log(parent.CollisionComponent.BodyInstance.Velocity);
    //if (parent.CollisionComponent.BodyInstance.Velocity.Z<-1 || parent.CollisionComponent.BodyInstance.Velocity.Z>1)
    //impulse.Z=-parent.CollisionComponent.BodyInstance.Velocity.Z;
   // `log( impulse);
    //parent.CollisionComponent.BodyInstance.CustomGravityFactor=0; //GetBodyMass()
    
    //parent.CollisionComponent.PhysMaterialOverride.Density * parent.CollisionComponent.
    //`log(parent.CollisionComponent.BodyInstance.Velocity);
    
    //if (LBSMPhysicsActor(parent)!=none)
    //{ 
    //    LBSMPhysicsActor(parent).CollisionComponent.AddImpulse(impulse);
    //    LBSMPhysicsActor(parent).CollisionComponent.AddForce(impulse);    
    //}
    //if (LBSKMPhysicsActor(parent)!=none)
    //{
    //    LBSKMPhysicsActor(parent).CollisionComponent.SetRBPosition(parent.location*vect(1,1,0)+vect(0,0,64));
    //    LBSMPhysicsActor(parent).CollisionComponent.AddForce(impulse);  
    //    
    //} 
}

function SetParamFloat(name param, float value, optional int priority=0)
{
    super.SetParamFloat(param, value, priority);
    
    //if (param=='UpImpulseZ' || param== 'UpImpulse-Z')
    //    UpImpulseZ=value; 
    //if (param=='AnitGravityImpulseZ' || param== 'AnitGravityImpulse-Z')
    //    AnitGravityImpulseZ=value;
    if (param=='AttitudeZ' || param== 'Attitude-Z')
        AttitudeZ=value;  
}
    
function float GetParamFloat(name param)
{
    //if (param=='UpImpulseZ' || param== 'UpImpulse-Z')
    //    return UpImpulseZ;
    //if (param=='AnitGravityImpulseZ' || param== 'AnitGravityImpulse-Z')
    //{
    //    return AnitGravityImpulseZ;
    //}
    if (param=='AttitudeZ' || param== 'Attitude-Z')
    {
        return AttitudeZ;
    }
    else
        return super.GetParamFloat(param);    
}  

defaultproperties
{
    //AnitGravityImpulseZ=66.912;
    MaxSpeedZ=100;
    //UpImpulseZ=67;
    //Attitude-Z=256;
}
