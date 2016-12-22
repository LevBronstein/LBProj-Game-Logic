/**
 *  LBAttachMechanism
 *
 *  Creation date: 11.12.2016 17:18
 *  Copyright 2016, Windows7
 */
class LBAttachMechanism extends LBMechanism;

var bool bIsAttached; //Is parent currently attached

var pawn AttachPawn;
var name AttachSocket;

var(AttachOffset) vector LocOffset;
var(AttachOffset) rotator RotOffset;

//memorized from parent upon attach, restored on detach
var EPhysics phys; 
var bool bColActors, bBlockActors, bIgnoreEncroachers; 

event OwnerTick(float deltatime)
{
    super.OwnerTick(deltatime);
    
    if (benabled==false)
        return;
    
    PerfrormTick();   
} 

function PerfrormTick()
{
    local vector l;
    local rotator r;
    
    if (!bIsAttached)
        return;
    
    if (AttachPawn == none)
        return;
        
    if (AttachPawn.Mesh.GetSocketWorldLocationAndRotation(AttachSocket, l, r, 0)==false)
        return; 
        
    parent.SetLocation(l+LocOffset);
    parent.SetRotation(r+RotOffset); 
}

function bool Attach()
{
    if (AttachPawn == none && AttachSocket =='')
    {
        LogError("proc: Attach(), AttachPawn is not valid:"@AttachPawn@"or AttachSocket is not valid:"@AttachSocket);      
        return false;
    }
    
    if (bIsAttached) //if something has been already attached
        Detach();    
        
    phys=parent.Physics;
    bColActors=parent.bCollideActors;
    bBlockActors=parent.bBlockActors;
    bIgnoreEncroachers=parent.bIgnoreEncroachers;
    
    parent.SetPhysics(PHYS_NONE);
    parent.SetCollision(false,false,false);
    
    bIsAttached=true;
    
    return true;
}

function bool Detach()
{
    if (!bIsAttached)
        return false;
        
    parent.SetPhysics(phys);
    parent.SetCollision(bColActors,bBlockActors,bIgnoreEncroachers);
    
    bIsAttached=false; 
   
    return true; 
}

function bool GetParamBool(name param)
{
    if (param=='IsAttached')
        return bIsAttached;
}

function SetParam(name param, object value, optional int priority=0)
{
    if (param=='AttachPawn')
        AttachPawn=pawn(value);
} 

function SetParamName(name param, name value, optional int priority=0)
{
    if (param=='AttachSocket')
        AttachSocket=value;
} 
    
function SetParamBool(name param, bool value, optional int priority=0)
{
    if (param=='IsAttached')
    {
        if (value)
            Attach();
        else
            Detach();
    }
    else if (param=='Attach')
    {
        Attach();
    } 
    else if (param=='Detach')
    {
        Detach();
    }    
}    

defaultproperties
{
    mechname="Attach_Mechanism"
    
    MechanismParams(0)=(ParamName="AttachPawn", ParamInfo="Object (LBPawn). Write. The pawn, to which parent is attached.")
    MechanismParams(1)=(ParamName="AttachSocket", ParamInfo="Name. Write. The name of the socket in pawn's mesh, to which parent is attached.")
    MechanismParams(2)=(ParamName="IsAttached", ParamInfo="Bool. Read, write. Get the attached state. Or set to true to attach the parent to [AttachPawn] and [AttachSocket]. Set false to detach.")
    MechanismParams(3)=(ParamName="Attach", ParamInfo="Bool. Write. Attach the parent to [AttachPawn] and [AttachSocket].")
    MechanismParams(4)=(ParamName="Detach", ParamInfo="Bool. Write. Detach the parent and restore its physics.")
}
