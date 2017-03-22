/**
 *  LBRollingBouncingMovementMechanism
 *
 *  Creation date: 11.03.2017 01:15
 *  Copyright 2017, Windows7
 */
class LBRollingBouncingMovementMechanism extends LBRollingMovementMechanism;

var(RollingBouncingMovementMechanism) float BounceMoment;
var(RollingBouncingMovementMechanism) float BounceMomentLength;
var(RollingBouncingMovementMechanism) vector BounceImpulse;

function PerformMovement(float dt)
{   
    `log(abs(Normalize(parent.Rotation).Pitch)*UnrRotToDeg @ "/" @ BounceMoment);
    if (LBActor(parent)!=none)
        if (abs(abs(Normalize(parent.Rotation).Pitch*UnrRotToDeg) - BounceMoment) <= BounceMomentLength)
            parent.SetLocation(parent.location+ForwardSpeed*kForwardSpeed*Vector(MoveDirection)+BounceImpulse);    
        else
            parent.SetLocation(parent.location+ForwardSpeed*kForwardSpeed*Vector(MoveDirection));
        
    if (LBPawn(parent)!=none)
        if  (abs(abs(Normalize(parent.Rotation).Pitch*UnrRotToDeg) - BounceMoment) <= BounceMomentLength)
        {
            `log("!!!!!");
            parent.SetPhysics(PHYS_Falling);
            parent.Velocity=ForwardSpeed*kForwardSpeed*Vector(MoveDirection)+BounceImpulse;        
        }
        else
            parent.Velocity=ForwardSpeed*kForwardSpeed*Vector(MoveDirection);    
    //`log(parent.Velocity);
}

defaultproperties
{
    mechname="Rolling_Bouncing_Movement_Mechanism"
}
