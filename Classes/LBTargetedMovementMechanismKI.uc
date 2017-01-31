/**
 *  LBTargetedMovementMechanismKI
 *
 *  Creation date: 23.12.2016 00:20
 *  Copyright 2016, Windows7
 */
class LBTargetedMovementMechanismKI extends LBTargetedMovementMechanism;

var(EventActivation) bool bActivateOnTargetLocReached;
var(EventActivation) name OnTargetLocReached;

var bool bnewloc;

function SetTargetLocation(vector newloc)
{
    super.SetTargetLocation(newloc);
    bnewloc=true;
}

function bool PerformPawnMovement(float dt)
{
    local bool b;
    
    b=super.PerformPawnMovement(dt);
    
    //Тут проблема в случае, если bnewloc==false, но актор был
    //либо отодвинут, либо перемещён без участия этого мехнаизма,
    //то второй раз при достижении TargetLocation событие не сработает
    
    if (!b && bEnableMovement && bActivateOnTargetLocReached && bnewloc)
    {
        bnewloc=false;
        TriggerKismetEvent(OnTargetLocReached,parent,parent.WorldInfo);
        LogInfo("Target location"@TargetLocation@"was reached");
        return true;
    }
    else
        return false;
}

function bool PerformActorMovement(float dt)
{
    local bool b;
    
    b=super.PerformActorMovement(dt);
    
    if (!b && bEnableMovement && bActivateOnTargetLocReached)
    {
        bnewloc=false;
        TriggerKismetEvent(OnTargetLocReached,parent,parent.WorldInfo);
        LogInfo("Target location"@TargetLocation@"was reached");
        return true;
    } 
    else
        return false;   
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
    bActivateOnTargetLocReached=false
    OnTargetLocReached=""
}
