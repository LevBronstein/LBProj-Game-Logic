/**
 *  LBAttachedMovementMechanism
 *
 *  Creation date: 31.01.2017 20:53
 *  Copyright 2017, Windows7
 */
class LBAttachedMovementMechanism extends LBTransposeMechanism;

var(AttachTarget) actor AttachActor;
var(AttachTarget) name AttachSocket;

var(AttachOffset) bool bUseOnlySocketData;
var(AttachOffset) vector LocOffset <editcondition=!bUseOnlySocketData>;
var(AttachOffset) rotator OrbitOffset <editcondition=!bUseOnlySocketData>;
var(AttachOffset) rotator RotOffset <editcondition=!bUseOnlySocketData>;
var(AttachOffset) CoordinateTypes CoordSystem <editcondition=!bUseOnlySocketData>;

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
}

function PerformMovement(float dt)
{
    local vector l;
    local rotator r;
    local vector pos;
        
    if (AttachActor == none)
        return;
   
    //If parent is attached to a pawn, we can use sockets
    if (pawn(AttachActor)!=none)
    {
        //If pawn has certain socket - attach to it, otherwise - to the root location
        if (pawn(AttachActor).Mesh.GetSocketByName(AttachSocket)!=none && pawn(AttachActor).Mesh.GetSocketWorldLocationAndRotation(AttachSocket, l, r, 0)==true)
        {
            if (bUseOnlySocketData)
            {
                SetParentLocation(l);
            }
            else
            {
                if (CoordSystem==CoordinateType_World)
                    SetParentLocation(LocOffset);    
                else if (CoordSystem==CoordinateType_Local)
                    SetParentLocation(GetLocalLocation(LocOffset, l));
                else if (CoordSystem==CoordinateType_LocalOriented)
                    SetParentLocation(GetOrientedLocation(LocOffset, r+OrbitOffset, l)); 
            }   
            
            return;      
        }
    }
    
    if (CoordSystem==CoordinateType_World)
        SetParentLocation(LocOffset);    
    else if (CoordSystem==CoordinateType_Local)
        SetParentLocation(GetLocalLocation(LocOffset, AttachActor.Location));
    else if (CoordSystem==CoordinateType_LocalOriented)
        SetParentLocation(GetOrientedLocation(LocOffset, AttachActor.Rotation+OrbitOffset, AttachActor.Location));          
  
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
        if (pawn(AttachActor).Mesh.GetSocketByName(AttachSocket)!=none && pawn(AttachActor).Mesh.GetSocketWorldLocationAndRotation(AttachSocket, l, r, 0)==true)
        {
            if (bUseOnlySocketData)
            {
                SetParentRotation(r);
            }
            else
            {
                if (CoordSystem==CoordinateType_LocalOriented)
                    SetParentRotation(r+RotOffset);  
            }
                
            return;
        }
    }
        
    if (CoordSystem==CoordinateType_LocalOriented)
        SetParentRotation(AttachActor.Rotation+RotOffset);
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
    LogInfo("Collisions disabled:"@parent.Physics@parent.bBlockActors@parent.bCollideActors);    
}

function Detach()
{
    RestoreCollisionParams();    
    LogInfo("Collisions enabled:"@parent.Physics@parent.bBlockActors@parent.bCollideActors);    
}

function SetParamBool(name param, bool value, optional int priority=0)
{
    super.SetParamBool(param, value, priority);
    
    if (param == 'Detach' || param == 'PutDown')
    {
        AttachActor=none;
        Detach();
    }
    
    //if (param=='bEnabled')
    //{
    //    if (value)
    //        Attach();
    //    else
    //        Detach();
    //}
}
    
function SetParamVector(name param, vector value, optional int priority=0)
{
    super.SetParamVector(param, value, priority);    
    
    if (param=='LocOffset' || param=='LocationOffset')
    {
        LocOffset=value;    
    }
} 
  
function SetParamRotator(name param, rotator value, optional int priority=0)
{
    super.SetParamRotator(param, value, priority); 
 
    if (param=='RotOffset' || param=='RotationOffset') 
    {
        RotOffset=value;
        `log(">>>>>>>>>>>>>>>>>"@value);  
    }    
}
  
function SetParam(name param, object value, optional int priority=0)
{
    super.SetParam(param, value, priority); 
 
    if (param == 'AttachActor') 
    {
        AttachActor=Actor(value);    
    }
    else if (param == 'AttachToActor')
    {
        AttachActor=Actor(value);
        Attach();   
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
    
    CoordSystem=CoordinateType_LocalOriented
}
