/**
 *  LBDirectedPhysImpulseMechanism
 *
 *  Creation date: 22.03.2017 02:00
 *  Copyright 2017, Windows7
 */
class LBDirectedPhysImpulseMechanism extends LBDirectedMovementMechanism;

var (PhysicalMovement) bool bIgnorantMovement;
var (PhysicalMovement) bool bKeepLocationWhenNotMoving;

var bool bwasmovinglasttick;
var vector lastloc;

function InitMechanism()
{
    super.InitMechanism();
 
    lastloc=parent.location;
}

function PerformMovement(float dt)
{    
    local vector v;
    local PrimitiveComponent c;
    
    if (bIgnorantMovement)
    {
        v=ForwardSpeed*kForwardSpeed*Vector(MoveDirection);
        
        if (LBSMPhysicsActor(parent)!=none)
        { 
            LBSMPhysicsActor(parent).CollisionComponent.SetRBPosition(parent.location+v);
        }
        if (LBSKMPhysicsActor(parent)!=none)
        {
            LBSKMPhysicsActor(parent).CollisionComponent.SetRBPosition(parent.location+v);    
        }
            
        if (bShowDebugGraphics)
            DGDisplayLocationSphere(parent, parent.location+v);     
    }
    else
    {
        v=ForwardSpeed*kForwardSpeed*Vector(MoveDirection);  
        
        if (LBSMPhysicsActor(parent)!=none)
        {
            c=LBSMPhysicsActor(parent).CollisionComponent;
        }
        
        if (LBSKMPhysicsActor(parent)!=none)
        {
            c=LBSKMPhysicsActor(parent).CollisionComponent;     
        }
        
        c.AddImpulse(v);
        
        if (bShowDebugGraphics)
            DGDisplayComponentSpeedVector(c, v);
    } 
        
    if (bShowDebugGraphics)
        DGDisplayVector(parent, Vector(MoveDirection)*16, 0, 128, 128);
}

function PerformRotation(float dt)
{
    //Super.PerformRotation(dt);
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
