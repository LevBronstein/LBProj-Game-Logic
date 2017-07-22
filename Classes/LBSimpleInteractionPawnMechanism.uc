/**
 *  LBSimpleInteractionPawnMechanism
 *
 *  Creation date: 20.07.2017 00:21
 *  Copyright 2017, Win10
 */
class LBSimpleInteractionPawnMechanism extends LBSimpleInteractionMechanism;
    
function bool CanInteract()
{
    local LBPawn p;
    local int i;
    
    p=LBPawn(parent);
    
    if (p == none)
    {
        LogError("proc: CanInteract(), parent is not a pawn or none:"@p);
        return false;
    }
     
    if (Interactions.Length==0)
    {
        LogError("proc: CanInteract(), interaction list is empty");
        return false;    
    }
    
    if (Interactions[CurInteraction].Values.Length==0)
    {
        LogError("proc: CanInteract(), current interaction"@CurInteraction@"has no values to set");
        return false;    
    }
    
    for (i=0;i<Interactions[CurInteraction].Values.Length;i++)
    {
        if (Interactions[CurInteraction].Values[i].bOverrideParentActor)
        {
            if (!TargetIsLBObject(TargetObject)) 
            {
                LogError("proc: CanInteract(), @TargetObject is not an LBObject or none:"@TargetObject);
                return false;
            }
            
            if (!TargetHasMechanism(TargetObject, Interactions[CurInteraction].Values[i].Target.MechanismName))
            {
                LogError("proc: CanInteract(), mechanism"@Interactions[CurInteraction].Values[i].Target.MechanismName@" in value"@i@"of interaction"@CurInteraction@"was not found in @TargetObject:"@TargetObject);
                return false;          
            }      
        }
        else
        {
            if (!TargetIsLBObject(Interactions[CurInteraction].Values[i].Target.ParentActor)) 
            {
                LogError("proc: CanInteract(), @ParentActor in value"@i@"of interaction"@CurInteraction@"is not a pawn or none:"@Interactions[CurInteraction].Values[i].Target.ParentActor);
                return false;
            }  

            if (!TargetHasMechanism(Interactions[CurInteraction].Values[i].Target.ParentActor, Interactions[CurInteraction].Values[i].Target.MechanismName))
            {
                LogError("proc: CanInteract(), mechanism"@Interactions[CurInteraction].Values[i].Target.MechanismName@" in value"@i@"of interaction"@CurInteraction@"was not found in @TargetObject:"@Interactions[CurInteraction].Values[i].Target.ParentActor);
                return false;          
            }    
        }
    }
   
    return true;
}

    
    
defaultproperties
{
 
}
