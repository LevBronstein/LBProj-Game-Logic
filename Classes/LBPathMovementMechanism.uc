/**
 *  LBPathMovementMechanism
 *
 *  Creation date: 08.01.2017 00:10
 *  Copyright 2017, Windows7
 */
class LBPathMovementMechanism extends LBTransposeMechanism;

var (PathMovement) float ForwardSpeed; 

var (PathMovementSystem) SplineActor Path;
var (PathMovementSystem) float dError;
var (PathMovementSystem) float dStepLength; //Should be less then ForwardSpeed

var float dist;
var float pathstep;

//function InitMechanism();
//{
//    pathsteps=Path.Connections[0].SplineComponent.GetLocationAtDistanceAlongSpline(dist) / dStep;        
//}

//function FirstTickInit()
//{
//    if (bfirsttick==false)
//        return;
//    
//    if (bfirsttick==true)
//        bfirsttick=false;    
//}

function PeformActorMovement(float dt)
{
    local SplineConnection node;
    local float spd;
    local vector v;
    local rotator r;
    
    if (Path == none || Path.Connections.Length == 0)
        return;
        
    node=Path.Connections[0];
    
    spd=ForwardSpeed;
        
    if (spd < node.SplineComponent.GetSplineLength() - dist)
    {
        dist=dist+spd;
        
        v=node.SplineComponent.GetLocationAtDistanceAlongSpline(dist);

        `log("Cur point: "@v@","@dist@"/"@node.SplineComponent.GetSplineLength()@path);
        //r=rotator(node.SplineComponent.GetTangentAtDistanceAlongSpline(dist));
    }
    else
    {
        dist=node.SplineComponent.GetSplineLength();
        
        v=node.SplineComponent.GetLocationAtDistanceAlongSpline(dist);
        //r=rotator(node.SplineComponent.GetTangentAtDistanceAlongSpline(node.SplineComponent.GetSplineLength()))
        
        Path=Path.Connections[0].ConnectTo;  
        
        dist=0;  
    }   
   
    parent.SetLocation(v);
}
 
function PeformPawnMovement(float dt)
{
    local SplineConnection node;
    local float pos;
    local vector v;
    local rotator r;
    
    if (Path == none || Path.Connections.Length == 0)
    {
        LogInfo("Reached the last point!"); 
        return;
    }
        
    node=Path.Connections[0];
    
    v=(node.SplineComponent.GetLocationAtDistanceAlongSpline(dist) * vect(1,1,0)) - (parent.Location * vect(1,1,0));
    
    if (VSize(v) > dError)
    {
        parent.Velocity=Normal(v)*ForwardSpeed;
        
        if (bShowDebugGraphics)
        {
            DGDisplaySpeedVector(parent,v);
            DGDisplayLocationSphere(parent,node.SplineComponent.GetLocationAtDistanceAlongSpline(dist));                
        }
    }
    else
    { 
        dist=dist + dStepLength;
        
        if (dist >= node.SplineComponent.GetSplineLength())
        {
            if (Path.Connections[0].ConnectTo!=none)
            {
                Path=Path.Connections[0].ConnectTo;  
                dist=0;
                
                LogInfo("Going to next path point"@Path);
                
                parent.Velocity=Normal(v)*ForwardSpeed;
            } 
            else
            {
                LogInfo("We've reached the last point!");    
            }    
        }       
    }
}

function PerformActorRotation(float dt)
{
    local SplineConnection node;
    local float spd;
    local vector v;
    local rotator r;

    if (Path == none || Path.Connections.Length == 0)
        return;
    
    node=Path.Connections[0];
        
    r=rotator(node.SplineComponent.GetTangentAtDistanceAlongSpline(dist));
    
    parent.SetRotation(r);    
}

function PerformPawnRotation(float dt)
{
    local SplineConnection node;
    local float spd;
    local vector v;
    local rotator r;

    if (Path == none || Path.Connections.Length == 0)
        return;
    
    node=Path.Connections[0];
        
    r=rotator(node.SplineComponent.GetTangentAtDistanceAlongSpline(dist));
    r.Pitch=0;
    r.Roll=0;
    
    parent.SetRotation(r);  
}

function PerformMovement(float dt)
{
    if (LBActor(parent)!=none)
        PeformActorMovement(dt);
    else if (LBPawn(parent)!=none)
        PeformPawnMovement(dt);
}

function PerformRotation(float dt)
{
    if (LBActor(parent)!=none)
        PerformActorRotation(dt);
    else if (LBPawn(parent)!=none)
        PerformPawnRotation(dt);  
}
    
function DGDisplaySpeedVector(actor a, vector v)
{
    local float r,h;
    a.GetBoundingCylinder(r,h);
    parent.DrawDebugLine(a.Location,a.Location+v*h,255,0,0);  
}

function DGDisplayLocationSphere(actor a, vector v)
{
    local float r,h;
    
    a.GetBoundingCylinder(r,h);
    a.DrawDebugSphere(v,h+h/4,12,0,0,128);        
}

function SetParamFloat(name param, float value, optional int priority=0)
{
    if (param=='ForwardSpeed' || param=='FwdSpeed')
    {
        ForwardSpeed=value;
    }
}

defaultproperties
{
    dError=5.0f
    dStepLength=1.0f
    
    mechname="Path_Movement_Mechanism"
}
