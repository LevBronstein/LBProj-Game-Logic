/**
 *  LBPathMovementMechanism
 *
 *  Creation date: 08.01.2017 00:10
 *  Copyright 2017, Windows7
 */
class LBPathMovementMechanism extends LBTransposeMechanism;

var (PathMovement) float ForwardSpeed; 

var (PathMovementSystem) SplineActor Path;

var float dist;

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
{}

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
{}

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

defaultproperties
{
    mechname="Path_Movement_Mechanism"
}
