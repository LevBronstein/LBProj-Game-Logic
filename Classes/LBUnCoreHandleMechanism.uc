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
    else
        return a.Location;
}
  
function name FindRootBone(actor a)
{
    local array<name> names;
    local int i;
   
    if (LBSKMPhysicsActor(a)!=none)   
    {
        LBSKMPhysicsActor(a).SkeletalMeshComponent.GetBoneNames(names);   
        
        for (i=0;i<names.Length;i++)
        {
            if (LBSKMPhysicsActor(a).SkeletalMeshComponent.GetParentBone(names[i]) == '')
                return names[i];
        }
    }
        
    if (LBPawn(a)!=none)
    {   
        LBPawn(a).Mesh.GetBoneNames(names); 
        
        for (i=0;i<names.Length;i++)
        {
            if (LBPawn(a).Mesh.GetParentBone(names[i]) == '')
                return names[i];
        }
    }
    
    return '';
}

function array<name> GetActorBoneNames(actor a)
{
    local array<name> names;
    
    if (LBPawn(a)!=none)
    { 
        LBPawn(a).Mesh.GetBoneNames(names);
    }
    else if (LBSKMPhysicsActor(a)!=none)
    {
        LBSKMPhysicsActor(a).SkeletalMeshComponent.GetBoneNames(names); 
    }
    return names;
}
   
function rotator GetActorRotation(actor a)
{
    if (LBActor(a)!=none || LBPawn(a)!=none)
        return a.Rotation;
    else if (LBSMPhysicsActor(a)!=none)
        return a.CollisionComponent.GetRotation();  
    else if (LBSKMPhysicsActor(a)!=none)  
    {
        return LBSKMPhysicsActor(a).SkeletalMeshComponent.GetRotation(); //LBSKMPhysicsActor(a).SkeletalMeshComponent.GetBoneQuaternion(FindRootBone(a));
    }
}

function vector GetParentLocation()
{
    if (LBActor(parent)!=none || LBPawn(parent)!=none)
        return parent.Location;
    else if (LBSMPhysicsActor(parent)!=none || LBSKMPhysicsActor(parent)!=none)
        return parent.CollisionComponent.GetPosition();     
}
    
function vector GetActorBoneLocation(actor a, name bonename, optional int space)
{
    local vector v;
    
    if (LBSKMPhysicsActor(a)!=none)
    {
        v=LBSKMPhysicsActor(a).SkeletalMeshComponent.GetBoneLocation(bonename,space);
        
        return v;     
    }  
    else if (LBPawn(a)!=none)
    {
        v=LBPawn(a).Mesh.GetBoneLocation(bonename,space);
        
        return v;       
    }
    else
        return vect(0,0,0);
}
    
function vector GetParentBoneLocation(name bonename, optional int space)
{
    return GetActorBoneLocation(parent, bonename, space);   
}
    
function rotator GetActorBoneRotation(actor a, name bonename)
{
    local vector X,Y,Z;  
  
    if (LBSKMPhysicsActor(a)!=none)
    {
        X=LBSKMPhysicsActor(a).SkeletalMeshComponent.GetBoneAxis(bonename,Axis_X);
        Y=LBSKMPhysicsActor(a).SkeletalMeshComponent.GetBoneAxis(bonename,Axis_Y);
        Z=LBSKMPhysicsActor(a).SkeletalMeshComponent.GetBoneAxis(bonename,Axis_Z);
        
        return OrthoRotation(X,Y,Z);     
    }  
    else if (LBPawn(a)!=none)
    {
        X=LBPawn(a).Mesh.GetBoneAxis(bonename,Axis_X);
        Y=LBPawn(a).Mesh.GetBoneAxis(bonename,Axis_Y);
        Z=LBPawn(a).Mesh.GetBoneAxis(bonename,Axis_Z);
        
        return OrthoRotation(X,Y,Z);       
    }
    else
        return OrthoRotation(vect(1,0,0),vect(0,1,0),vect(0,0,1));
}

function rotator GetParentBoneRotation(name bonename)
{
    return GetActorBoneRotation(parent, bonename);   
}

function rotator GetParentRotation()
{
    local rotator r;
    local vector X,Y,Z;
    
    if (LBActor(parent)!=none || LBPawn(parent)!=none)
        return parent.Rotation;
    else if (LBSKMPhysicsActor(parent)!=none)
    {
        //`log(LBSKMPhysicsActor(parent).SkeletalMeshComponent.PhysicsAssetInstance.Bodies[LBSKMPhysicsActor(parent).SkeletalMeshComponent.PhysicsAssetInstance.RootBodyIndex].GetUnrealWorldTM().XPlane.X);
        //LBSKMPhysicsActor(parent).SkeletalMeshComponent.TransformFromBoneSpace(FindRootBone(parent),vect(0,0,1),rot(0,0,0),v,r);
        X=LBSKMPhysicsActor(parent).SkeletalMeshComponent.GetBoneAxis(FindRootBone(parent),Axis_X);
        //parent.DrawDebugLine(parent.Location,parent.Location+X*256,255,0,0);
        Y=LBSKMPhysicsActor(parent).SkeletalMeshComponent.GetBoneAxis(FindRootBone(parent),Axis_Y);
        //parent.DrawDebugLine(parent.Location,parent.Location+Y*256,0,255,0);
        Z=LBSKMPhysicsActor(parent).SkeletalMeshComponent.GetBoneAxis(FindRootBone(parent),Axis_Z);
        //parent.DrawDebugLine(parent.Location,parent.Location+Z*256,0,0,255);
        //`log(OrthoRotation(X,Y,Z));
        return OrthoRotation(X,Y,Z);     
    }
    else if (LBSMPhysicsActor(parent)!=none)
    {
        
    }
    
    //GetRotation() ??
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
        //`log(parent@parent.CollisionComponent);
}
    
function bool GetActorSocket(actor a, name socketname, out vector location, out rotator rotation, optional int space=0)
{
    if (pawn(a)!=none && socketname!='' && pawn(a).Mesh.GetSocketByName(socketname)!=none)
        return pawn(a).Mesh.GetSocketWorldLocationAndRotation(socketname, location, rotation, space);
     
    if (kasset(a)!=none && socketname!='' && kasset(a).SkeletalMeshComponent.GetSocketByName(socketname)!=none)
        return kasset(a).SkeletalMeshComponent.GetSocketWorldLocationAndRotation(socketname, location, rotation, space);   
       
    return false; 
}

function bool GetParentSocket(name socketname, out vector location, out rotator rotation, optional int space=0)
{
    if (pawn(parent)!=none && socketname!='' && pawn(parent).Mesh.GetSocketByName(socketname)!=none)
        return pawn(parent).Mesh.GetSocketWorldLocationAndRotation(socketname, location, rotation, space);
     
    if (kasset(parent)!=none && socketname!='' && kasset(parent).SkeletalMeshComponent.GetSocketByName(socketname)!=none)
        return kasset(parent).SkeletalMeshComponent.GetSocketWorldLocationAndRotation(socketname, location, rotation, space);   
       
    return false; 
} 

defaultproperties
{
}
