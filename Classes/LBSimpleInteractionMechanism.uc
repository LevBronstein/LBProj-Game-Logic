/**
 *  LBReactionMechanism
 *
 *  Creation date: 22.07.2017 15:42
 *  Copyright 2017, Win10
 */
class LBSimpleInteractionMechanism extends LBBasicInteractionMechanism;

struct LBSimpleInteraction
{
    var() name InteractionName;
    var() array<LBTargetValueContainer> Values;
};

struct LBSimpleReaction
{
    var() name ReactionName;
    var() array<LBTargetValueContainer> Values;
};

var(InteractionList) array<LBSimpleInteraction> Interactions;
var(ReactionList) array<LBSimpleInteraction> Reactions;

var actor TargetObject;
var int CurInteraction;
var int CurReaction;

function bool IsValidInteraction(int id)
{
    if (id>=0 && id<=Interactions.Length)    
        return true;
    else 
        return false;    
}

function SetTargetObject(actor a)
{
    TargetObject=a;    
}

function SetCurInteraction(int id)
{
    if (id>=0 && id<=Interactions.Length)    
        CurInteraction=id;    
}
   
function SetCurReaction(int id)
{
    if (id>=0 && id<=Reactions.Length)    
        CurReaction=id;    
}
      
function bool CanInteract()
{
    local int i;
     
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
   
function bool CanReact()
{
    local int i;
    
    if (Reactions.Length==0)
    {
        LogError("proc: CanReact(), reaction list is empty");
        return false;    
    }
    
    if (Reactions[CurReaction].Values.Length==0)
    {
        LogError("proc: CanReact(), current reaction"@CurReaction@"has no values to set");
        return false;    
    }
    
    for (i=0;i<Reactions[CurReaction].Values.Length;i++)
    {
        if (Reactions[CurReaction].Values[i].bOverrideParentActor)
        {
            if (!TargetIsLBObject(parent)) 
            {
                LogError("proc: CanInteract(), @TargetObject is not an LBObject or none:"@parent);
                return false;
            }
            
            if (!TargetHasMechanism(parent, Reactions[CurReaction].Values[i].Target.MechanismName))
            {
                LogError("proc: CanInteract(), mechanism"@Reactions[CurReaction].Values[i].Target.MechanismName@" in value"@i@"of reaction"@CurReaction@"was not found in @parent:"@parent);
                return false;          
            }      
        }
        else
        {
            if (!TargetIsLBObject(Reactions[CurReaction].Values[i].Target.ParentActor)) 
            {
                LogError("proc: CanInteract(), @ParentActor in value"@i@"of reaction"@CurReaction@"is not a pawn or none:"@Reactions[CurReaction].Values[i].Target.ParentActor);
                return false;
            }  

            if (!TargetHasMechanism(Reactions[CurReaction].Values[i].Target.ParentActor, Reactions[CurReaction].Values[i].Target.MechanismName))
            {
                LogError("proc: CanInteract(), mechanism"@Reactions[CurReaction].Values[i].Target.MechanismName@" in value"@i@"of interaction"@CurReaction@"was not found in @TargetObject:"@Reactions[CurReaction].Values[i].Target.ParentActor);
                return false;          
            }    
        }
    }
    
    return true;
}

function Interact()
{
    local int i;
    local LBMechanismParam target;
    
    if (!CanInteract())
    {
        LogError("proc: Interact(), cannot perform interaction"@CurInteraction@"with actor"@TargetObject);
        return;
    }   
       
    for (i=0;i<Interactions[CurInteraction].Values.Length;i++)
    {
        target=Interactions[CurInteraction].Values[i].Target;
            
        if (Interactions[CurInteraction].Values[i].bOverrideParentActor)
        {
            target.ParentActor=TargetObject;        
        }        
        
        SetTargetParamContainerPtr(target,Interactions[CurInteraction].Values[i].Value);
    }
    
    LogInfo("Interaction"@CurInteraction@"was activated");
}

function React()
{
    local int i;
    local LBMechanismParam target;
    
    if (!CanReact())
    {
        LogError("proc: React(), cannot perform reaction"@CurReaction);
        return;
    }  
    
    for (i=0;i<Reactions[CurReaction].Values.Length;i++)
    {
        target=Reactions[CurReaction].Values[i].Target;
            
        if (Reactions[CurReaction].Values[i].bOverrideParentActor)
        {
            target.ParentActor=parent;        
        }        
        
        SetTargetParamContainerPtr(target,Reactions[CurReaction].Values[i].Value);
    }
    
    LogInfo("Interaction"@CurReaction@"was activated");  
}

function SetParam(name param, object value, optional int priority=0)
{
    super.SetParam(param,value,priority);
        
    if (param=='TargetObject' || param=='TargetObj')
    {
        SetTargetObject(actor(value));    
    }
} 

function SetParamBool(name param, bool value, optional int priority=0)
{
    super.SetParamBool(param,value,priority);
    
    if (param=='Interact')
    {
        if (value)
        {
            Interact();    
        }
    }
    else if (param=='React')
    {
        if (value)
        {
            React();    
        }
    }
}

function SetParamInt(name param, int value, optional int priority=0)
{
    super.SetParamInt(param,value,priority);

    if (param=='CurInteraction' || param=='CurentInteraction')
        SetCurInteraction(value); 
    else if (param=='CurReaction' || param=='CurentReaction')
        SetCurReaction(value);     
    else if (param=='PerformInteraction')
    {
        SetCurInteraction(value); 
        Interact();   
    }
    else if (param=='PerformReaction')
    {
        SetCurReaction(value); 
        React();   
    }
}

defaultproperties
{
    mechname="Simple_Interaction_Mechanism"    
    
    MechanismParams.Add((ParamName="TargetObject", ParamType=ParamType_Object, ParamInfo="Object (Actor). Read, write. Gets or set @TargetObject, which is the counterpart of any interaction."))
    MechanismParams.Add((ParamName="CurentInteraction", ParamType=ParamType_Integer, ParamInfo="Integer. Read. Gets or sets @CurInteraction, which holds the id in interaction list."))
    
    ParamSource.Add((ParamName="TargetObject"))
    ParamSource.Add((ParamName="CurentInteraction"))
    ParamSource.Add((ParamName="Interact"))
}
