/**
 *  LBConditionalTrigger
 *
 *  Creation date: 07.02.2017 02:17
 *  Copyright 2017, Windows7
 */
class LBConditionalTrigger extends LBTriggerMechanism;

function UpdateTriggerState(float dt)
{
    if (CheckConditions())
        SetTrigger();
    else 
        SetUnTrigger();     
}
    
function bool CheckConditions()
{}  

defaultproperties
{
}
