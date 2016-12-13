/**
 *  LBKismetEventActivator
 *
 *  Creation date: 21.05.2016 00:35
 *  Copyright 2016, Windows7
 */
class LBKismetEventActivator extends LBInteractableMechanism
dependson(LBConditionalProgramm);

var(EventActivation) name EventName;
var(EventActivation) bool bSilent; //If set to true, kismet events won't be activated (for based classes)
var(EventActivation) bool bCheckOnTick;
var(EventActivation) int CheckEveryNthTick; //0 means check every tick

var int curtick;

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
        
    if (bCheckOnTick)
    {
        if (CheckEveryNthTick==0)
        {
            if (CheckConditions())
                TriggerKismetEvent(); 
        }
        else
        {
            if (curtick>=CheckEveryNthTick)
            {
                if (CheckConditions())
                    TriggerKismetEvent();
                    
                curtick=0;
            }     
            else
                curtick=curtick+1;
                
        }   
    }
} 
 
function bool CheckConditions()
{
    return true;
}
    
function TriggerKismetEvent()
{
    local int i;
    local Sequence GameSeq;
    local array<SequenceObject> AllSeqEvents;

    if (bSilent)
        return;
    
    GameSeq = parent.WorldInfo.GetGameSequence();
    
    if(GameSeq != None && EventName!='')
    {
        GameSeq.FindSeqObjectsByClass(class'LBSequenceEvent', true, AllSeqEvents);
        for(i=0; i<AllSeqEvents.Length; i++)
        {
            //originator - instigator?
            if (LBSequenceEvent(AllSeqEvents[i]).EventName==EventName)
            {
                LBSequenceEvent(AllSeqEvents[i]).CheckActivate(parent.WorldInfo, None);           
            }
        }
    }
}
defaultproperties
{
    bSilent=false
}
