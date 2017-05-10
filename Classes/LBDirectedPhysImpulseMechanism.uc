/**
 *  LBDirectedPhysImpulseMechanism
 *
 *  Creation date: 22.03.2017 02:00
 *  Copyright 2017, Windows7
 */
class LBDirectedPhysImpulseMechanism extends LBDirectedMovementMechanism;

var (PhysicalMovement) bool bIgnorantMovement;
//var (PhysicalMovementDirection) 

function PerformMovement(float dt)
{    
    local vector v;
    local PrimitiveComponent c;
    
    if (bIgnorantMovement)
    {
        if (LBSMPhysicsActor(parent)!=none)
        {
            v=ForwardSpeed*kForwardSpeed*Vector(MoveDirection);
            LBSMPhysicsActor(parent).CollisionComponent.SetRBPosition(parent.location+v);
        }
        if (LBSKMPhysicsActor(parent)!=none)
        {
            v=ForwardSpeed*kForwardSpeed*Vector(MoveDirection);
            LBSKMPhysicsActor(parent).CollisionComponent.SetRBPosition(parent.location+v);    
        }
            
        if (bShowDebugGraphics)
            DGDisplayLocationSphere(parent, parent.location+v);     
    }
    else
    {
        if (LBSMPhysicsActor(parent)!=none)
        {
            v=ForwardSpeed*kForwardSpeed*Vector(MoveDirection);
            c=LBSMPhysicsActor(parent).CollisionComponent;
            c.AddImpulse(v);
        }
        if (LBSKMPhysicsActor(parent)!=none)
        {
            v=ForwardSpeed*kForwardSpeed*Vector(MoveDirection);
            c=LBSKMPhysicsActor(parent).CollisionComponent;
            c.AddImpulse(v);     
        }
        
        if (bShowDebugGraphics)
            DGDisplayComponentSpeedVector(c, v);
    } 
        
    if (bShowDebugGraphics)
        DGDisplayVector(parent, Vector(MoveDirection)*16, 0, 128, 128);
}

function PerformRotation(float dt)
{
    //parent.CollisionComponent.AddTorque(vector(MoveDirection));    
}

function DGDisplayComponentSpeedVector(PrimitiveComponent c, vector v)
{
    parent.DrawDebugLine(c.GetPosition(),c.GetPosition()+Normal(v)*32,255,0,0);
    parent.DrawDebugLine(c.GetPosition(),c.GetPosition()+vector(c.GetRotation())*32,0,0,255); 
}

function DGDisplayLocationSphere(actor a, vector v)
{
    local float r,h;
    
    a.GetBoundingCylinder(r,h);
    a.DrawDebugSphere(v,h+h/4,12,0,0,128);        
}

defaultproperties
{
}
