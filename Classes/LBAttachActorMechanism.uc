/**
 *  LBAttachActorMechanism
 *
 *  Creation date: 24.12.2016 22:08
 *  Copyright 2016, Windows7
 */
class LBAttachActorMechanism extends LBMechanism;

var(AttachActor) actor AttachedActor;
var(AttachActor) bool bIsInitiallyAttached;

var bool bIsAttached; //Is the actor currently attached

var(AttachOffset) vector LocOffset;
var(AttachOffset) rotator RotOffset;

//memorized from parent upon attach, restored on detach
var EPhysics phys; 
var bool bColActors, bBlockActors, bIgnoreEncroachers;

function FirstTickInit()
{
    if (bfirsttick==false)
        return;
    
    if (bfirsttick==true)
        bfirsttick=false;   
     
    if (bIsInitiallyAttached)
        Attach();    
}

event OwnerTick(float deltatime)
{
    super.OwnerTick(deltatime);
    
    if (benabled==false)
        return;
    
    PerfrormTick();   
}

function PerfrormTick()
{    
    if (!bIsAttached || AttachedActor == none)
        return;
                
    AttachedActor.SetLocation(parent.Location+LocOffset);
    AttachedActor.SetRotation(parent.Rotation+RotOffset); 
}

function bool Attach()
{
    if (AttachedActor == none)
    {
        LogError("proc: Attach(), AttachActor is none");      
        return false;
    }
    
    if (bIsAttached) //if something has been already attached
        Detach();    
        
    phys=AttachedActor.Physics;
    bColActors=AttachedActor.bCollideActors;
    bBlockActors=AttachedActor.bBlockActors;
    bIgnoreEncroachers=AttachedActor.bIgnoreEncroachers;
    
    AttachedActor.SetPhysics(PHYS_NONE);
    AttachedActor.SetCollision(false,false,false);
    
    bIsAttached=true;
    
    return true;
}

function bool Detach()
{
    if (AttachedActor == none)
    {
        LogError("proc: Detach(), AttachActor is none");      
        return false;
    }
    
    if (!bIsAttached)
        return false;
                
    AttachedActor.SetPhysics(phys);
    AttachedActor.SetCollision(bColActors,bBlockActors,bIgnoreEncroachers);
    
    bIsAttached=false; 
   
    return true; 
}

defaultproperties
{
    mechname="Attach_Actor_Mechanism"
}
