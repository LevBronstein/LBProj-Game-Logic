/**
 *  LBUnCoreHandleMechanism
 *
 *  Creation date: 09.12.2017 02:31
 *  Copyright 2017, Win10
 */
class LBUnCoreHandleMechanism extends LBInteractableMechanism;

function vector GetActorLocation(actor a)
{
    if (LBActor(a)!=none || LBPawn(a)!=none)
        return a.Location;
    else if (LBSMPhysicsActor(a)!=none || LBSKMPhysicsActor(a)!=none)
        return a.CollisionComponent.GetPosition();    
}
    
function rotator GetActorRotation(actor a)
{
    if (LBActor(a)!=none || LBPawn(a)!=none)
        return a.Rotation;
    else if (LBSMPhysicsActor(a)!=none || LBSKMPhysicsActor(a)!=none)
        return a.CollisionComponent.GetRotation();    
}

function vector GetParentLocation()
{
    if (LBActor(parent)!=none || LBPawn(parent)!=none)
        return parent.Location;
    else if (LBSMPhysicsActor(parent)!=none || LBSKMPhysicsActor(parent)!=none)
        return parent.CollisionComponent.GetPosition();     
}
    
function rotator GetParentRotation()
{
    if (LBActor(parent)!=none || LBPawn(parent)!=none)
        return parent.Rotation;
    else if (LBSMPhysicsActor(parent)!=none || LBSKMPhysicsActor(parent)!=none)
        return parent.CollisionComponent.GetRotation();     
}    

function SetParentLocation(vector v)
{
    if (LBActor(parent)!=none || LBPawn(parent)!=none)
        parent.SetLocation(v);
    else if (LBSMPhysicsActor(parent)!=none || LBSKMPhysicsActor(parent)!=none)
    {
        parent.SetLocation(v);
        parent.CollisionComponent.SetRBPosition(v);    
    }
}

function SetParentRotation(rotator r)
{
    if (LBActor(parent)!=none || LBPawn(parent)!=none)
        parent.SetRotation(r);
    else if (LBSMPhysicsActor(parent)!=none || LBSKMPhysicsActor(parent)!=none)
        parent.CollisionComponent.SetRBRotation(r); 
        `log(parent@parent.CollisionComponent);
}
    
function bool GetSocket(actor a, name socketname, out vector location, out rotator rotation, optional int space=0)
{
    if (pawn(a)!=none && socketname!='' && pawn(a).Mesh.GetSocketByName(socketname)!=none)
        return pawn(a).Mesh.GetSocketWorldLocationAndRotation(socketname, location, rotation, space);
     
    if (kasset(a)!=none && socketname!='' && kasset(a).SkeletalMeshComponent.GetSocketByName(socketname)!=none)
        return kasset(a).SkeletalMeshComponent.GetSocketWorldLocationAndRotation(socketname, location, rotation, space);   
       
    return false; 
}

defaultproperties
{
}
