/**
 *  LBKismetEventActivator
 *
 *  Creation date: 21.05.2016 00:35
 *  Copyright 2016, Windows7
 */
class LBKismetEventActivator extends LBInteractableMechanism
dependson(LBConditionalProgramm);

var(EventActivation) name EventName;

var(EventActivation) bool bCheckEveryTick;

function FirstTickInit()
{
    if (bfirsttick==false)
        return;
    
    if (bfirsttick==true)
        bfirsttick=false;      
}

event OwnerTick(float deltatime)
{
    super.OwnerTick(deltatime);
    
    if (benabled==false)
        return;
        
    if (bCheckEveryTick)
    {
        TriggerKismetEvent();    
    }
} 
    
function TriggerKismetEvent()
{
    local int i;
    local Sequence GameSeq;
    local array<SequenceObject> AllSeqEvents;

    GameSeq = parent.WorldInfo.GetGameSequence();
    
    if(GameSeq != None)
    {
        GameSeq.FindSeqObjectsByClass(class'LBSequenceEvent',true, AllSeqEvents);
        for(i=0; i<AllSeqEvents.Length; i++)
        {
            //originator - instigator?
            if (LBSequenceEvent(AllSeqEvents[i]).EventName==EventName)
                LBSequenceEvent(AllSeqEvents[i]).CheckActivate(parent.WorldInfo, None);           
        }
    }
}
defaultproperties
{
}
