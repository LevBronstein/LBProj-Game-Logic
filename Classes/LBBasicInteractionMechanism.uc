/**
 *  LBBasicInteractionMechanism
 *
 *  Creation date: 22.07.2017 15:58
 *  Copyright 2017, Win10
 */
class LBBasicInteractionMechanism extends LBInteractableMechanism;

function bool CanInteract()
{
    return true;
}

function bool CanReact()
{
    return true;
}

function Interact()
{    
}

function React()
{    
}

function bool GetParamBool(name param)
{
    if (param=='CanInteract' || param=='bCanInteract')
    {
        return CanInteract();
    }
    else if (param=='CanReact' || param=='bCanReact')
    {
        return CanReact();    
    }
    else 
        return super.GetParamBool(param);
} 


defaultproperties
{
    mechname="Basic_Interaction_Mechanism"
    
    MechanismParams.Add((ParamName="Interact", ParamType=ParamType_Boolean, ParamInfo="Boolean. Write. Set true to execute interaction whithin current mechanism state."))
    MechanismParams.Add((ParamName="bCanInteract", ParamType=ParamType_Boolean, ParamInfo="Boolean. Read. Returns true if interaction can be executed whithin current mechanism state."))
    MechanismParams.Add((ParamName="bCanReact", ParamType=ParamType_Boolean, ParamInfo="Boolean. Read. Returns true if reaction can be executed whithin current mechanism state."))
}
