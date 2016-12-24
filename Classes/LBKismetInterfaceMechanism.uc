/**
 *  LBKismetInterfaceMechanism
 *
 *  Creation date: 24.12.2016 20:57
 *  Copyright 2016, Windows7
 */
class LBKismetInterfaceMechanism extends LBMechanism;

function ActivateKismetEvent(name EventName, actor Originator, actor Instigator)
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
}
