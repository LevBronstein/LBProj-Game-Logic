/**
 *  LBInventoryPawnMechanism
 *
 *  Creation date: 11.12.2016 15:51
 *  Copyright 2016, Windows7
 */
class LBInventoryPawnMechanism extends LBInteractableMechanism;

var(InventoryMechanismSystem) name AttachSocket; //a socket in the mesh, where object is attached
var(InventoryMechanismSystem) name OtherObjectMechanism; //A mechanism, which is used in interacted objects

var actor HeldObject; //currently held object

var actor CheckingObject; //object to be tested in CanAddToIvnentory

event OwnerTick(float deltatime)
{
    super.OwnerTick(deltatime);
    
    if (benabled==false)
        return;
    
    PerformTick();
} 

function PerformTick()
{
    local LBPawn p;
    local vector l;
    local rotator r;
    
    if (HeldObject == none)       
        return;
        
    p=LBPawn(parent);
    
    //if (p == none)
    //    return;
    //    
    //if (p.Mesh.GetSocketWorldLocationAndRotation(AttachSocket, l, r, 0)==false)
    //    return;  
    // 
    //HeldObject.SetLocation(l); 
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
    
    if (LBActor(a) == none || LBActor(a).GetMechanismByName(OtherObjectMechanism) == none)
    {
        LogError("proc: AddToIvnentory(), other object is not an LBActor:"@LBActor(a)@"or doesn't have a"@OtherObjectMechanism@"mechanism!"); 
        return false;     
    }
    
    LBActor(a).SetParam(OtherObjectMechanism, 'AttachPawn', parent);
    LBActor(a).SetParamName(OtherObjectMechanism, 'AttachSocket', AttachSocket);
    LBActor(a).SetParamBool(OtherObjectMechanism, 'Attach', true);
    
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
    
    LBActor(HeldObject).SetParam(OtherObjectMechanism, 'AttachPawn', none);
    LBActor(HeldObject).SetParamName(OtherObjectMechanism, 'AttachSocket', '');
    LBActor(HeldObject).SetParamBool(OtherObjectMechanism, 'Detach', true);
    
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
    
    if (LBActor(CheckingObject) == none || LBActor(CheckingObject).GetMechanismByName(OtherObjectMechanism) == none)
    {
        return false;     
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
    if (param=='AddObject')
        AddToIvnentory(actor(value));
    else if (param=='CheckingObject')
        CheckingObject=actor(value);    
} 
    
function SetParamBool(name param, bool value, optional int priority=0)
{
    if (param=='RemoveAllObjects' || param=='RemoveObject')
        ClearInventory();
}
    
function object GetParam(name param)
{
    if (param=='HeldObject')
    {
        return HeldObject;
    }   
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
}

defaultproperties
{
    mechname="Inventory_Mechanism"
    
    OtherObjectMechanism="Attach_Mechanism"
    
    AttachSocket="InventorySocket"
    
    bLogFullInfo=true
        
    MechanismParams(0)=(ParamName="AddObject", ParamInfo="Object. Write. Add corresponding object to the inventory. Only one object can be held.")
    MechanismParams(1)=(ParamName="RemoveObject", ParamInfo="Bool. Write. Remove held object from the inventory.")
    MechanismParams(2)=(ParamName="RemoveAllObjects", ParamInfo="Bool. Write. Same as [RemoveAllObjects].")
    MechanismParams(3)=(ParamName="HeldObject", ParamInfo="Object. Read. Get held object, that is currently held.")
    MechanismParams(4)=(ParamName="CheckingObject", ParamInfo="Object. Write. Set to an object which is check, whether it can be added to invetory.")
    MechanismParams(5)=(ParamName="CanAddToIvnentory", ParamInfo="Bool. Read. Returns true if [CheckingObject] can be added to inventory, otherwise - false.")
    MechanismParams(6)=(ParamName="CanRemoveFromIvnentory", ParamInfo="Bool. Read. Returns true if there is any object in inventory and it can be dropped down.")
}
