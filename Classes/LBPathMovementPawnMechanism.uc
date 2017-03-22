/**
 *  LBPathMovementPawnMechanism
 *
 *  Creation date: 08.03.2017 00:59
 *  Copyright 2017, Windows7
 */
class LBPathMovementPawnMechanism extends LBPathMovementMechanism;

function PeformPawnMovement(float dt)
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
   
    parent.Velocity=Normal(v)*ForwardSpeed;
    `log(parent.Velocity);
    //parent.SetLocation(v);
}

//function PeformPawnMovement(float dt)
//{
//    local SplineConnection node;
//    local float spd;
//    local vector v;
//    local rotator r;
//    
//    if (Path == none || Path.Connections.Length == 0)
//        return;
//        
//    node=Path.Connections[0];
//    
//    spd=VSize(ForwardSpeed);
//        
//    if (spd < node.SplineComponent.GetSplineLength() - dist)
//    {
//        dist=dist+spd;
//        
//        v=node.SplineComponent.GetLocationAtDistanceAlongSpline(dist);
//
//        `log("Cur point: "@v@","@dist@"/"@node.SplineComponent.GetSplineLength()@path);
//        //r=rotator(node.SplineComponent.GetTangentAtDistanceAlongSpline(dist));
//    }
//    else
//    {
//        dist=node.SplineComponent.GetSplineLength();
//        
//        v=node.SplineComponent.GetLocationAtDistanceAlongSpline(dist);
//        //r=rotator(node.SplineComponent.GetTangentAtDistanceAlongSpline(node.SplineComponent.GetSplineLength()))
//        
//        Path=Path.Connections[0].ConnectTo;  
//        
//        dist=0;  
//    }   
//   
//    parent.SetLocation(v);
//}

defaultproperties
{
}
