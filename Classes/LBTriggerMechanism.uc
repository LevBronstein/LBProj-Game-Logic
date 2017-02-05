/**
 *  LBTriggerMechanism
 *
 *  Creation date: 24.12.2016 20:48
 *  Copyright 2016, Windows7
 */
class LBTriggerMechanism extends LBKismetInterfaceMechanism;

var(TriggerMechanism) bool TriggerState;

var(EventActivation) name OnTriggerEventName; //Activated when TriggerState changes to true
var(EventActivation) name OnUnTriggerEventName; //Activated when TriggerState changes to false

function SetTrigger()
{
    if (!TriggerState)
    {
        TriggerState=true;
        OnChangedTriggerState(TriggerState);    
    }
}

function SetUnTrigger()
{
    if (TriggerState)
    {
        TriggerState=false; 
        OnChangedTriggerState(TriggerState);       
    }    
}

function OnChangedTriggerState(bool bnewstate)
{
    //Activating kismet event, parent is used as instigator
    if (bnewstate)
    {
        ActivateKismetEvent(OnTriggerEventName,parent.WorldInfo,parent);    
    } 
    else
    {
        ActivateKismetEvent(OnUnTriggerEventName,parent.WorldInfo,parent);    
    }   
}

defaultproperties
{
}
