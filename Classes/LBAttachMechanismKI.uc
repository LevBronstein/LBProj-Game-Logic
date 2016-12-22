/**
 *  LBAttachMechanismKI
 *
 *  Creation date: 22.12.2016 19:25
 *  Copyright 2016, Windows7
 */
class LBAttachMechanismKI extends LBAttachMechanism;

var(EventActivation) bool bActivateOnAttach;
var(EventActivation) name OnAttachEventName;
var(EventActivation) bool bActivateOnDetach;
var(EventActivation) name OnDetachEventName;

function bool Attach()
{
    local bool b;
    
    b=super.Attach();
    
    //Now activating kismet event OnAttach
    if (b && bActivateOnAttach)
    {
        TriggerKismetEvent(OnAttachEventName,parent,AttachPawn);
        LogInfo("The object "@parent@"was attached to the"@AttachPawn@"to socket"@AttachSocket);         
    }
    
    return b;
}

function bool Detach()
{
    local bool b;
    local name sock;
    local actor p;
    
    p=AttachPawn;
    sock=AttachSocket;
    
    b=super.Detach();
    
    //Now activating kismet event OnDetach
    if (b && bActivateOnDetach)
    {
        TriggerKismetEvent(OnDetachEventName,parent,p);
        LogInfo("The object "@parent@"was detached from the"@p@"from socket"@sock);         
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
    bActivateOnAttach=false
    bActivateOnDetach=false
}
