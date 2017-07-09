/**
 *  LBInventoryPawnMechanism
 *
 *  Creation date: 11.12.2016 15:51
 *  Copyright 2016, Windows7
 */
class LBInventoryPawnMechanism extends LBInteractableMechanism;

var(InventoryMechanismSystem) name AttachSocket; //a socket in the mesh, where object is attached

var(OtherObjectInteraction) bool bCheckOtherObjectMechanism;
var(OtherObjectInteraction) LBConstNoActorTypedParamPtr bCanBePickedUp;
var(OtherObjectInteraction) LBConstNoActorTypedParamPtr PickUp;
var(OtherObjectInteraction) LBConstNoActorTypedParamPtr PutDown;

var actor HeldObject; //currently held object

var actor CheckingObject; //object to be tested in CanAddToIvnentory

event OwnerTick(float deltatime)
{
    super.OwnerTick(deltatime);
    
    if (benabled==false)
        return;
} 

function bool AddToIvnentory(actor a)
{
    local LBPawn p;
    local vector l;
    local rotator r;
    
    p=LBPawn(parent);
    
    if (p == none)
    {
        LogError("proc: AddToIvnentory(), parent is not a pawn or none:"@p);  
        return false;
    }
    
    if (HeldObject != none)
    {
        LogError("proc: AddToIvnentory(), there's already an object held:"@HeldObject); 
        return false;
    }
    
    if (p.Mesh.GetSocketWorldLocationAndRotation(AttachSocket, l, r, 0)==false)
    {
        LogError("proc: AddToIvnentory(), parent mesh doesn't have socket"@AttachSocket@"or is none:"@p.Mesh); 
        return false;   
    }
    
    if (!TargetIsLBObject(a))
    {
        LogError("proc: AddToIvnentory(), other object is not an LBActor:"@LBActor(a)@"!"); 
        return false;     
    }
    
    if (!TargetHasMechanism(a,bCanBePickedUp.MechanismName))
    {
        if (bCheckOtherObjectMechanism)
        {
            LogError("proc: AddToIvnentory(), other object doesn't have a"@bCanBePickedUp.MechanismName@"mechanism!"); 
            return false; 
        }    
    }
    
    if (!GetTargetParamBool(a,bCanBePickedUp.MechanismName,bCanBePickedUp.ParamName))
    {
        if (bCheckOtherObjectMechanism)
        { 
            return false; 
        }       
    } 
    
    SetTargetParam(a, PickUp.MechanismName, PickUp.ParamName, parent);
    //LBActor(a).SetParam(OtherObjectMechanism, 'PickUpBy', parent);
    //LBActor(a).SetParamName(OtherObjectMechanism, 'AttachSocket', AttachSocket);
    
    HeldObject=a;
    
    return true;
}

function bool ClearInventory()
{
    if (HeldObject == none)
    {
        LogError("proc: ClearInventory(), the inventory is already empty:"@HeldObject); 
        return false;
    }
    
    SetTargetParamBool(HeldObject, PutDown.MechanismName, PutDown.ParamName, true);
    
    HeldObject=none;
    
    return true;
}

function bool CanAddToIvnentory()
{
    local LBPawn p;
    local vector l;
    local rotator r;
    
    p=LBPawn(parent);
    
    if (p == none)
    {
        return false;
    }
    
    if (HeldObject != none)
    {
        return false;
    }
    
    if (p.Mesh.GetSocketWorldLocationAndRotation(AttachSocket, l, r, 0)==false)
    {
        return false;   
    }
    
    ////if (LBActor(CheckingObject) == none || LBActor(CheckingObject).GetMechanismByName(OtherObjectMechanism) == none)
    //if (!TargetIsLBObject(CheckingObject) || !TargetHasMechanism(CheckingObject, OtherObjectMechanism))
    //{
    //    return false;     
    //} 
    
    if (!TargetIsLBObject(CheckingObject))
    {
        return false;     
    }
    
    if (!TargetHasMechanism(CheckingObject, bCanBePickedUp.MechanismName))
    {
        if (bCheckOtherObjectMechanism)
        { 
            return false; 
        }    
    }
    
    if (!GetTargetParamBool(CheckingObject,bCanBePickedUp.MechanismName,bCanBePickedUp.ParamName))
    {
        if (bCheckOtherObjectMechanism)
        { 
            return false; 
        }       
    } 
    
    return true;
}
    
function bool CanRemoveFromIvnentory()
{
    if (HeldObject == none)
        return false;
    else
        return true;
}

function SetParam(name param, object value, optional int priority=0)
{
    super.SetParam(param,value,priority);
    
    if (param=='AddObject')
        AddToIvnentory(actor(value));
    else if (param=='CheckingObject')
        CheckingObject=actor(value);    
} 
    
function SetParamBool(name param, bool value, optional int priority=0)
{
    super.SetParamBool(param,value,priority);
    
    if (param=='RemoveAllObjects' || param=='RemoveObject')
        ClearInventory();
    else if (param=='AddCheckingObject')
        AddToIvnentory(CheckingObject);        
}
    
function object GetParam(name param)
{
    if (param=='HeldObject')
    {
        return HeldObject;
    }   
    else
        return super.GetParam(param);
}

function bool GetParamBool(name param)
{
    if (param=='CanAddToIvnentory')
    {
        return CanAddToIvnentory();
    } 
    else if (param=='CanRemoveFromIvnentory')
    {
        return CanRemoveFromIvnentory();
    }  
    else
        return super.GetParamBool(param);
}

defaultproperties
{
    mechname="Inventory_Mechanism"
    
    OtherObjectMechanism="Attach_Mechanism"
    
    AttachSocket="InventorySocket"
    
    PickUp=(ParamType=ParamType_Object,MechanismName="Attached_Movement_Mechanism",ParamName="AttachToActor")
    PutDown=(ParamType=ParamType_Boolean,MechanismName="Attached_Movement_Mechanism",ParamName="Detach")
    bCanBePickedUp=(ParamType=ParamType_Boolean,MechanismName="Attached_Movement_Mechanism",ParamName="bIsAvailable")
        
    MechanismParams.Add((ParamName="AddObject", ParamType=ParamType_Object, ParamInfo="Object. Write. Add corresponding object to the inventory. Only one object can be held."))
    MechanismParams.Add((ParamName="RemoveObject", ParamType=ParamType_Boolean, ParamInfo="Bool. Write. Remove held object from the inventory."))
    MechanismParams.Add((ParamName="RemoveAllObjects", ParamType=ParamType_Boolean, ParamInfo="Bool. Write. Same as [RemoveAllObjects]."))
    MechanismParams.Add((ParamName="HeldObject", ParamType=ParamType_Object, ParamInfo="Object. Read. Get held object, that is currently held."))
    MechanismParams.Add((ParamName="CheckingObject", ParamType=ParamType_Object, ParamInfo="Object. Write. Set to an object which is check, whether it can be added to invetory."))
    MechanismParams.Add((ParamName="CanAddToIvnentory", ParamType=ParamType_Boolean, ParamInfo="Bool. Read. Returns true if [CheckingObject] can be added to inventory, otherwise - false."))
    MechanismParams.Add((ParamName="CanRemoveFromIvnentory", ParamType=ParamType_Boolean, ParamInfo="Bool. Read. Returns true if there is any object in inventory and it can be dropped down."))
    MechanismParams.Add((ParamName="AddCheckingObject", ParamType=ParamType_Boolean, ParamInfo="Bool. Wrie. Add @CheckingObject to the inventory. The @CheckingObject should be set."))
    
    ParamSource.Add((ParamName="AddObject"))
    ParamSource.Add((ParamName="RemoveObject"))
    ParamSource.Add((ParamName="RemoveAllObjects"))
    ParamSource.Add((ParamName="CheckingObject"))
    ParamSource.Add((ParamName="AddCheckingObject"))
}
