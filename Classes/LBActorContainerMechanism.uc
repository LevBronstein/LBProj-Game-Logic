/**
 *  LBActorContainerMechanism
 *
 *  Creation date: 08.02.2017 20:29
 *  Copyright 2017, Windows7
 */
class LBActorContainerMechanism extends LBInteractableMechanism;

var(ActorContainer) array<actor> ContainedActors;

var int SelectedActor;
var array<bool> SelectedActorMask;

function SelectActor(int id)
{
    if (ContainedActors.Length==0)
        SelectedActor=-1;
    else
        SelectedActor=Clamp(id, 0, ContainedActors.Length-1); 
}

function bool AddActor(actor a)
{
    if (LBActor(a)==none && LBPawn(a)==none)
    {
        LogError("Actor"@a@"is not valid");
        return false;
    }
 
    if (ContainedActors.Find(a)!=-1)
    {
        LogError("Actor"@a@"is in the list");
        return false;   
    }
        
    ContainedActors.AddItem(a);
    SelectActor(SelectedActor);
    
    if (bLogFullInfo)
        LogContaindeActorList();
        
    return true;
}
    
function bool AddActors(array<object> arr)
{
    local int i;
    local bool b;
    local int c;
    
    b=false;
    c=0;

    for (i=0;i<arr.Length;i++)
    {
        if (AddActor(actor(arr[i])))
        {
            b=true;
            c++;
        }
    } 
 
    if (b)
    {
        LogInfo("actors were added ("@c@"from"@arr.Length@")");
    }
    else
    {
        LogInfo("no actors were added");    
    }
        
    return b;   
}
    
function bool RemoveActorByID(int id)
{    
    if (id<0 || id>=ContainedActors.Length)
    {
        LogError("Given id"@id@"is not valid");
        return false;   
    }
    
    ContainedActors.Remove(id, 1);
    SelectActor(SelectedActor);
    
    if (bLogFullInfo)
        LogContaindeActorList();
        
    return true;
}

function bool RemoveActor(actor a)
{    
    if (LBActor(a)==none && LBPawn(a)==none)
    {
        LogError("Actor"@a@"is not valid");
        return false;
    }
        
    if (ContainedActors.Find(a)==-1)
    {
        LogError("Actor"@a@"is not in the list");
        return false;
    }
        
    ContainedActors.RemoveItem(a);
    SelectActor(SelectedActor);
    
    if (bLogFullInfo)
        LogContaindeActorList();
        
    return true;
}

function bool RemoveAllActors()
{
    local int i;
    local bool b;
    local int c;
    
    b=false;
    c=0;

    for (i=0;i<ContainedActors.Length;i++)
    {
        if (RemoveActorByID(i))
        {
            b=true;
            c++;
        }    
    } 
    
    if (b)
    {
        LogInfo("actors were removed ("@c@"from"@ContainedActors.Length@")");
    }
    else
    {
        LogInfo("no actors were removed (");    
    }
 
    return b;       
}
 
function SetContainedActors(array<object> newarr)
{
    local int i;  
  
    ContainedActors.Length=0;
        
    for (i=0;i<newarr.Length;i++)
    {
        ContainedActors.AddItem(actor(newarr[i]));
    }    
    
    if (bLogFullInfo)
        LogContaindeActorList();
}
    
function array<actor> AllContainedActors()
{
    local int i;
    local array<actor> arr;
    
    for (i=0;i<ContainedActors.Length;i++)
    {
        arr.AddItem(ContainedActors[i]);
    }
    
    return arr; 
}

function array<actor> ContainedActorsByMask()
{}

function LogContaindeActorList()
{
    local int i;
    
    LogInfo("Containing actors total:"@ContainedActors.Length);
    
    for (i=0;i<ContainedActors.Length;i++)
    {
        if (SelectedActor==i)
            `log(">"$(i+1)$":"@ContainedActors[i]$"<");
        else    
            `log((i+1)$":"@ContainedActors[i]);
    }
}
    
function SetParam(name param, object value, optional int priority=0)
{
    if (param=='AddActor')
        AddActor(actor(value));
    else if (param=='RemoveActor')
        RemoveActor(actor(value));
} 
    
function SetParamBool(name param, bool value, optional int priority=0)
{
    if (param=='RemoveAllActors')
    {
        RemoveAllActors();        
    }
    else if (param=='RemoveSelectedActor')
    {
        RemoveActorByID(SelectedActor);    
    }
} 
    
function array<object> GetParams(name param)
{
    if (param=='ContainedActors')
        return AllContainedActors();
}   
    
function SetParams(name param, array<object> value, optional int priority=0)
{
    if (param=='ContainedActors')
    {
        SetContainedActors(value);   
    }
    else if (param=='AddActors')
    {
        AddActors(value);    
    }
} 

function SetParamInt(name param, int value, optional int priority=0)
{
    if (param=='SelectActor')
    {
        SelectActor(value);    
    }
    if (param=='RemoveActorByID')
    {
        RemoveActorByID(value);        
    }
}  

function GetParameters()
{
    local object o;
    local array<object> obs;
    
    if (ParamSource[0].ValueSource.bUseSource)
    {   
        if (ParamSource[0].ValueSource.SourceActor != none)
        {
             o=GetTargetParam(ParamSource[0].ValueSource.SourceActor,ParamSource[0].ValueSource.SourceMechanismName,ParamSource[0].ValueSource.SourceParamName);    
             SetParam(ParamSource[0].ParamName,o);
        }
        else
        {
            o=GetTargetParam(parent,ParamSource[0].ValueSource.SourceMechanismName,ParamSource[0].ValueSource.SourceParamName);    
            SetParam(ParamSource[0].ParamName,o);    
        }   
    } 
    
    if (ParamSource[1].ValueSource.bUseSource)
    {
        if (ParamSource[1].ValueSource.SourceActor != none)
        {
            obs=GetTargetParams(ParamSource[1].ValueSource.SourceActor,ParamSource[1].ValueSource.SourceMechanismName,ParamSource[1].ValueSource.SourceParamName);    
            SetParams(ParamSource[1].ParamName,obs);
        }
        else
        {
            obs=GetTargetParams(parent,ParamSource[1].ValueSource.SourceMechanismName,ParamSource[1].ValueSource.SourceParamName);    
            SetParams(ParamSource[1].ParamName,obs);    
        }   
    }     
}

defaultproperties
{
    mechname="Actor_Container_Mechanism"
    
    MechanismParams(0)=(ParamName="AddActor", ParamInfo="Object. Write. Add corresponding actor to the actor list.")
    MechanismParams(1)=(ParamName="AddActors", ParamInfo="Object Array. Write. Add given actor list to the existing actor list.")
    MechanismParams(2)=(ParamName="RemoveActor", ParamInfo="Object. Write. Remove corresponding object from the actor list.")
    MechanismParams(3)=(ParamName="RemoveActorByID", ParamInfo="Integer. Write. Remove actor with given index from the list.")
    MechanismParams(4)=(ParamName="RemoveSelectedActor", ParamInfo="Boolean. Write. Remove actor by @SelectedActor position from the list.")
    MechanismParams(5)=(ParamName="RemoveAllActors", ParamInfo="Boolean. Write. Remove all actors from the list.")
    MechanismParams(6)=(ParamName="ContainedActors", ParamInfo="Object Array. Read. Write. Get or set the whole actor list @ContainedActors.")
    MechanismParams(7)=(ParamName="SelectActor", ParamInfo="Integer. Write. Select certain actor to perform further actions.")

    ParamSource(0)=(ParamName="AddActor")
    ParamSource(1)=(ParamName="AddActors")
    ParamSource(2)=(ParamName="RemoveActor")
    ParamSource(3)=(ParamName="RemoveActorByID")
    ParamSource(4)=(ParamName="RemoveSelectedActor")
    ParamSource(5)=(ParamName="RemoveAllActors")
    ParamSource(6)=(ParamName="SelectActor")
    
}
