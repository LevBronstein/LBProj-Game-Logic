/**
 *  LBAddSkeletalMeshModifier
 *
 *  Creation date: 22.02.2017 23:12
 *  Copyright 2017, Windows7
 */
class LBAddSkeletalMeshModifier extends LBMechanism;

var(SkeletalMesh) SkeletalMeshComponent SkeletalMesh;

event OwnerTick(float deltatime)
{
    FirstTickInit();
    
    if(benabled==false)
        return;
  
        //PerfromTick(deltatime);      
}

function FirstTickInit()
{
    AttachSkeletalMesh(SkeletalMesh, parent);        
}

function AttachSkeletalMesh(SkeletalMeshComponent mesh, actor a)
{
    a.AttachComponent(mesh);
}

defaultproperties
{
}
