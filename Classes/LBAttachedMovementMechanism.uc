/**
 *  LBAttachedMovementMechanism
 *
 *  Creation date: 31.01.2017 20:53
 *  Copyright 2017, Windows7
 */
class LBAttachedMovementMechanism extends LBTransposeMechanism;

var(AttachTarget) actor AttachActor;
var(AttachTarget) name AttachSocket;

var(AttachOffset) vector LocOffset;
var(AttachOffset) rotator RotOffset;

var(DefaultParams) EPhysics phys; 
var(DefaultParams) bool bColActors, bBlockActors, bIgnoreEncroachers;
var(DefaultParams) bool bRestoreDefaultPhysCol; /*If set to true, the phys/collision params 
would be set from @DefaultParams, rather than taken from the object. Use it when this
mechanism's @FirstTickInit is called after other significant mechanisms' @FirstTickInit,
for example, those mechanisms, that modify this mechanism's @bEanbled value*/ 

function FirstTickInit()
{
    super.FirstTickInit();
    
    if (bfirsttick==false)
        return;
    
    if (bfirsttick==true)
        bfirsttick=false;  
}

function PerformMovement(float dt)
{
    local vector l;
    local rotator r;
        
    if (AttachActor == none)
        return;
   
    //If parent is attached to a pawn, we can use sockets
    if (pawn(AttachActor)!=none)
    {
        //If pawn has certain socket attach to it, otherwise - to the root location
        if (pawn(AttachActor).Mesh.GetSocketWorldLocationAndRotation(AttachSocket, l, r, 0)==false)
        {
            parent.SetLocation(AttachActor.Location+LocOffset);
            //parent.SetRotation(AttachActor.Rotation+RotOffset);    
        }
        else
        {
            parent.SetLocation(l+LocOffset);
            //parent.SetRotation(r+RotOffset);    
        }      
    }
    else
    {
        parent.SetLocation(AttachActor.Location+LocOffset);        
    }             
}

function PerformRotation(float dt)
{
    local vector l;
    local rotator r;

    if (AttachActor == none)
        return;
   
    //If parent is attached to a pawn, we can use sockets
    if (pawn(AttachActor)!=none)
    {
        //If pawn has certain socket attach to it, otherwise - to the root location
        if (pawn(AttachActor).Mesh.GetSocketWorldLocationAndRotation(AttachSocket, l, r, 0)==false)
        {
            parent.SetLocation(AttachActor.Location+LocOffset);
            //parent.SetRotation(AttachActor.Rotation+RotOffset);    
        }
        else
        {
            parent.SetLocation(l+LocOffset);
            //parent.SetRotation(r+RotOffset);    
        }      
    }
    else
    {
        parent.SetLocation(AttachActor.Location+LocOffset);        
    }
     
}

function SaveCollisionParams()
{
    if (!bRestoreDefaultPhysCol)
    {
        phys=parent.Physics;
        bColActors=parent.bCollideActors;
        bBlockActors=parent.bBlockActors;
        bIgnoreEncroachers=parent.bIgnoreEncroachers;
    }
}

function RestoreCollisionParams()
{
    parent.SetPhysics(phys);
    parent.SetCollision(bColActors,bBlockActors,bIgnoreEncroachers);     
}

function Attach()
{
    SaveCollisionParams();
    
    parent.SetPhysics(PHYS_NONE);
    parent.SetCollision(false,false,false); 
    `log("Collisions disabled:"@parent.Physics@parent.bBlockActors@parent.bCollideActors);    
}

function Detach()
{
    RestoreCollisionParams();    
    `log("Collisions enabled:"@parent.Physics@parent.bBlockActors@parent.bCollideActors);    
}

function SetParamBool(name param, bool value, optional int priority=0)
{
    super.SetParamBool(param, value, priority);
    
    if (param=='bEnabled')
    {
        if (value)
            Attach();
        else
            Detach();
    }
}
    
function SetParam(name param, object value, optional int priority=0)
{
    super.SetParam(param, value, priority); 
 
    if (param=='AttachActor') 
    {
        AttachActor=Actor(value);    
    }
}

//Может работать неправильно?
function SetParamName(name param, name value, optional int priority=0)
{
    if (param=='AttachSocket')
        AttachSocket=value;
}    

defaultproperties
{
    mechname="Attached_Movement_Mechanism"
}
