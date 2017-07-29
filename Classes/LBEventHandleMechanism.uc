/**
 *  LBEventHandleMechanism
 *
 *  Creation date: 25.07.2017 01:52
 *  Copyright 2017, Win10
 */
class LBEventHandleMechanism extends LBInteractableMechanism;

struct LBSimpleEventHandler
{
    var() name EventName;
    var() array<LBTargetValueContainer> Values;
    var() bool bActivateKismetEvent;
    var() name KismetEventName;
};

var(EventHandlersList) array<LBSimpleEventHandler> EventHandlers;

//Do not set any values, if any target is not correct
var(EventHandlersList) bool bStrictCheck;

function bool IsValidEvent(int id)
{
    if (id>=0 && id<=EventHandlers.Length)    
        return true;
    else 
        return false;    
}

function HandleEvent(int id)
{
    local int i;
    
    if (!IsValidEvent(id))
    {
        LogError("proc: HandleEvent(), the event"@id@"does not have a handler");
        return;    
    }
    
    for (i=0;i<EventHandlers[id].Values.Length;i++)
    {
        if (bStrictCheck && !TargetIsLBObject(EventHandlers[id].Values[i].Target.ParentActor)) 
        {
            LogError("proc: HandleEvent(), @ParentActor in value"@i@"of event"@id@"is not an LBObject or none:"@EventHandlers[id].Values[i].Target.ParentActor);
            return;
        }  

        if (bStrictCheck && !TargetHasMechanism(EventHandlers[id].Values[i].Target.ParentActor, EventHandlers[id].Values[i].Target.MechanismName))
        {
            LogError("proc: HandleEvent(), mechanism"@EventHandlers[id].Values[i].Target.MechanismName@" in value"@i@"of event"@id@"was not found in actor:"@EventHandlers[id].Values[i].Target.ParentActor);
            return;          
        }    
    }
    
    for (i=0;i<EventHandlers[id].Values.Length;i++)
    {        
        SetTargetParamContainerPtr(EventHandlers[id].Values[i].Target,EventHandlers[id].Values[i].Value);
    }
    
    LogInfo("Event handler for event"@id@EventHandlers[id].EventName@"was activated");
    
    if (EventHandlers[id].bActivateKismetEvent)
    {
        TriggerKismetEvent(EventHandlers[id].KismetEventName,parent.WorldInfo,parent.Instigator);
        LogInfo("Kismet event"@EventHandlers[id].KismetEventName@"was activated");
    }   
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

function SetParamInt(name param, int value, optional int priority=0)
{
    if (param=='Event' || param=='RaiseEvent')
        HandleEvent(value);   
}

defaultproperties
{
    mechname="Event_Handler_Mechanism"
}
