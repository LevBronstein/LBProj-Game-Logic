/**
 *  LBInventoryPawnMechanismKI (Kismet Interface)
 *
 *  Creation date: 22.12.2016 17:45
 *  Copyright 2016, Windows7
 */
class LBInventoryPawnMechanismKI extends LBInventoryPawnMechanism;

var(EventActivation) bool bActivateOnAddToInventory;
var(EventActivation) name OnAddToInventoryEventName;
var(EventActivation) bool bActivateOnClearInventory;
var(EventActivation) name OnClearInventoryEventName;

function bool AddToIvnentory(actor a)
{
    local bool b;
    
    b=super.AddToIvnentory(a);
    
    //Now activating kismet event OnAddToInventory
    if (b && bActivateOnAddToInventory)
    {
        TriggerKismetEvent(OnAddToInventoryEventName,parent,a);
        LogInfo("Inventory was filled, object"@a@"was added to inventory");         
    }
    
    return b; 
}

function bool ClearInventory()
{
    local bool b;
    local actor h;
    
    h=HeldObject; //Разве так можно?!
    
    b=super.ClearInventory();
    
    //Now activating kismet event OnClearToInventoryEvent
    if (b && bActivateOnAddToInventory)
    {
        TriggerKismetEvent(OnClearInventoryEventName,parent,h); 
        LogInfo("Inventory was cleared, object"@h@"was thrown away");    
    }
    
    return b;
}

function TriggerKismetEvent(name EventName, actor Originator, actor Instigator)
{
    local int i;
    local Sequence GameSeq;
    local array<SequenceObject> AllSeqEvents;
    
    GameSeq = parent.WorldInfo.GetGameSequence();
    
    if(GameSeq != None && EventName!='')
    {
        GameSeq.FindSeqObjectsByClass(class'LBSequenceEvent', true, AllSeqEvents);
        for(i=0; i<AllSeqEvents.Length; i++)
        {
            if (LBSequenceEvent(AllSeqEvents[i]).EventName==EventName)
            {
                LBSequenceEvent(AllSeqEvents[i]).CheckActivate(Originator, Instigator);           
            }
        }
    }
}

defaultproperties
{
    bActivateOnAddToInventory=false
    bActivateOnClearInventory=false
}
