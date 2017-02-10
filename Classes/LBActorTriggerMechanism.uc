/**
 *  LBActorTriggerMechanism
 *
 *  Creation date: 07.02.2017 20:34
 *  Copyright 2017, Windows7
 */
class LBActorTriggerMechanism extends LBConditionalTrigger;

/*An array of objects, which are tested for certain condition.
If at least one of them match this condition, the trigger is
set to TRUE*/
var(ActorTrigger) array<actor> CheckingActors;
/*If set to true, this mechanism's parent is checked for certain
conditions just like other checking objects. If @CheckingObjects array
is empty, only parent is checked*/
var(ActorTrigger) bool bIncludeParent; 

event OwnerTick(float deltatime)
{
    if(benabled==false)
        return;

    PerformTick(deltatime);           
}

function PerformTick(float dt)
{
    UpdateTriggerState(dt);
}

function bool CheckConditions()
{
    local int i;
    local bool b;
    local bool match;
   
    LogInfo("Checking actors total:"@CheckingActors.Length);    
    
    for (i=0;i<CheckingActors.Length;i++)
    {
        b=CheckActor(CheckingActors[i]); 
        match=match || b;
        LogInfo(i@": actor"@CheckingActors[i]@"matches"@b);    
    }
      
    if (bIncludeParent)
    {
        b=CheckActor(parent);
        match=match || b;
        LogInfo("Parent: actor"@CheckingActors[i]@"matches"@b);
    }
    
    LogInfo("Check result:"@match);
     
    return match;  
}

function array<actor> GetActorsMatchingTrue()
{
    local int i;
    local array<actor> arr;
    
    for (i=0;i<CheckingActors.Length;i++)
    {
        if(CheckActor(CheckingActors[i]))
        {
            arr.AddItem(CheckingActors[i]);
        }
    }
    
    if (bIncludeParent)
    {
        if (CheckActor(parent))
            arr.AddITem(parent);
    }
   
    return arr;       
}

function array<actor> GetActorsMatchingFalse()
{
    local int i;
    local array<actor> arr;
    
    for (i=0;i<CheckingActors.Length;i++)
    {
        if(!CheckActor(CheckingActors[i]))
        {
            arr.AddItem(CheckingActors[i]);
        }
    }
   
    if (bIncludeParent)
    {
        if (!CheckActor(parent))
            arr.AddITem(parent);
    }
    
    return arr; 
}

function bool CheckActor(actor a)
{}
    
function SetParams(name param, array<object> value, optional int priority=0)
{
    local int i;
    
    if (param=='CheckingActors' || param=='CheckingObjects')
    {
        CheckingActors.Length=0;
        
        for (i=0;i<value.Length;i++)
        {
            CheckingActors.AddItem(actor(value[i]));
        }  
    }
} 

function array<object> GetParams(name param)
{
    if (param=='GetActorsMatchingTrue' || param=='GetObjectsMatchingTrue' ||
    param=='ActorsMatchingTrue' || param=='ObjectsMatchingTrue')
    {
        return GetActorsMatchingTrue();
    }    
    else if (param=='GetActorsMatchingFalse' || param=='GetObjectsMatchingFalse' ||
    param=='ActorsMatchingFalse' || param=='ObjectsMatchingFalse')
    {
        return GetActorsMatchingFalse();
    }  
}

function bool GetParamBool(name param)
{
    super.GetParamBool(param);
    
    if (param=='bHasMatchingActors' || param=='HasMatchingActors' ||
    param=='bHasMatchingObjects' || param=='HasMatchingObjects' )
    {
        return TriggerState;
    } 
}
    
defaultproperties
{
}
