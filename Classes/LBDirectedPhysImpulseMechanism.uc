/**
 *  LBDirectedPhysImpulseMechanism
 *
 *  Creation date: 22.03.2017 02:00
 *  Copyright 2017, Windows7
 */
class LBDirectedPhysImpulseMechanism extends LBDirectedMovementMechanism;

var (PhysicalMovement) bool bIgnorantMovement;

function PerformMovement(float dt)
{       
    if (bIgnorantMovement)
    {
        if (LBSMPhysicsActor(parent)!=none)
            LBSMPhysicsActor(parent).CollisionComponent.SetRBPosition(parent.location+ForwardSpeed*kForwardSpeed*Vector(MoveDirection));
        if (LBSKMPhysicsActor(parent)!=none)
            LBSKMPhysicsActor(parent).CollisionComponent.SetRBPosition(parent.location+ForwardSpeed*kForwardSpeed*Vector(MoveDirection));    
    }
    else
    {
        if (LBSMPhysicsActor(parent)!=none)
            LBSMPhysicsActor(parent).CollisionComponent.AddImpulse(ForwardSpeed*kForwardSpeed*Vector(MoveDirection));
        if (LBSKMPhysicsActor(parent)!=none)
            LBSKMPhysicsActor(parent).CollisionComponent.AddImpulse(ForwardSpeed*kForwardSpeed*Vector(MoveDirection));     
    }
}

function PerformRotation(float dt)
{
    //parent.CollisionComponent.SetRBRotation(MoveDirection);    
}

defaultproperties
{
}
