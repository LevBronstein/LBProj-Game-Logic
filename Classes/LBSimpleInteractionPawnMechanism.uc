/**
 *  LBSimpleInteractionPawnMechanism
 *
 *  Creation date: 20.07.2017 00:21
 *  Copyright 2017, Win10
 */
class LBSimpleInteractionPawnMechanism extends LBInteractableMechanism;

struct LBSimpleInteraction
{
    var() array<LBTargetValueContainer> Values;
};

var actor TargetObject;
var int CurInteraction;

var(InteractionList) array<LBSimpleInteraction> Interactions;

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

function bool GetParamBool(name param)
{
    if (param=='CanInteract' || param=='bCanInteract')
    {
        return CanInteract();
    }
    else 
        return super.GetParamBool(param);
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
    
    if (param=='Interact' || param=='PerformInteraction')
    {
        if (value)
        {
            Interact();    
        }
    }
}

function SetParamInt(name param, int value, optional int priority=0)
{
    super.SetParamInt(param,value,priority);

    if (param=='CurInteraction' || param=='CurentInteraction')
        SetCurInteraction(value);  
} 
    
    
defaultproperties
{
    mechname="Simple_Interaction_Mechanism"    
    
    MechanismParams.Add((ParamName="TargetObject", ParamType=ParamType_Object, ParamInfo="Object (Actor). Read, write. Gets or set @TargetObject, which is the counterpart of any interaction."))
    MechanismParams.Add((ParamName="CurentInteraction", ParamType=ParamType_Integer, ParamInfo="Integer. Read. Gets or sets @CurInteraction, which holds the id in interaction list."))
    MechanismParams.Add((ParamName="Interact", ParamType=ParamType_Boolean, ParamInfo="Boolean. Write. Set true to execute interaction, described by @CurInteraction with @TargetObject."))
    MechanismParams.Add((ParamName="bCanInteract", ParamType=ParamType_Boolean, ParamInfo="Boolean. Read. Returns true if interaction can be executed whith curent @CurInteraction with @TargetObject."))
    
    ParamSource.Add((ParamName="TargetObject"))
    ParamSource.Add((ParamName="CurentInteraction"))
    ParamSource.Add((ParamName="Interact"))
}
