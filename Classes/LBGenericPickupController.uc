/**
 *  LBGenericPickupController
 *
 *  Creation date: 22.12.2016 20:02
 *  Copyright 2016, Windows7
 */
class LBGenericPickupController extends LBTriggerMechanism;

var(GenericPickupControllerGameplay) bool bCanBePickedUp;

var(GenericPickupControllerSystem) name MovementManagementMechanism; 
var(GenericPickupControllerSystem) int PickedUpMovementID;
var(GenericPickupControllerSystem) int DefaultMovementID;
var(GenericPickupControllerSystem) name AttachedMovementMechanism;
var(GenericPickupControllerSystem) actor AttachActor;

function PickUp()
{   
    if (!bCanBePickedUp)
        return;
       
    SetTrigger();
}

function PickUpBy(actor a)
{
    AttachActor=a;
    
    PickUp();
}

function PutDown()
{
    SetUnTrigger(); 
}

function OnChangedTriggerState(bool bnewstate)
{
    if (bnewstate)
    {
        //If Parent was picked up - activate corresponding movement
        SetTargetParam(parent,AttachedMovementMechanism,'AttachActor',AttachActor);
        SetTargetParamInt(parent,MovementManagementMechanism,'ActivateMovement',PickedUpMovementID);                 
    }
    else
    {
        //If Parent was put down - activate corresponding movement
        SetTargetParamInt(parent,MovementManagementMechanism,'ActivateMovement',DefaultMovementID);                    
    }
    
    super.OnChangedTriggerState(bnewstate);
}

function bool GetParamBool(name param)
{
    if (param=='IsAttached' || param=='IsPickedUp')
        return TriggerState;
    else if (param== 'bCanBeAttached' || param=='bCanBePickedUp')
        return bCanBePickedUp;
}
    
function SetParamBool(name param, bool value, optional int priority=0)
{
    if (param=='IsPickedUp' || param=='IsAttached')
    {
        if (value)
            PickUp();
        else
            PutDown();    
    }
    else if (param=='Attach' || param=='PickUp')
    {
        PickUp();
    } 
    else if (param=='Detach' || param=='PutDown')
    {
        PutDown();
    }   
    else if (param== 'bCanBeAttached' || param=='bCanBePickedUp')
    {
        bCanBePickedUp=value;
    } 
}

function SetParam(name param, object value, optional int priority=0)
{
    if (param=='AttachTo' || param=='PickUpBy')
    {
        PickUpBy(actor(value)); 
    }    
}

defaultproperties
{
    mechname="Generic_Pickup_Controller"
    
    bCanBePickedUp=true
}
