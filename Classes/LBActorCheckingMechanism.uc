/**
 *  LBActorCheckingMechanism
 *
 *  Creation date: 10.02.2017 19:51
 *  Copyright 2017, Windows7
 */
class LBActorCheckingMechanism extends LBInteractableMechanism;

struct ParamValue
{
    var() LBParam TargetParam; 
    var() LBParamContainer TargetParamValue;   
};

/*An array of actors, which are tested for certain condition*/
var(CheckingActors) array<actor> CheckingActors;
/*Set to true to check @parent with other actors in @CheckingActors*/
var(CheckingActors) bool bIncludeParent; 
/*Set to true if an iterator (All actors or another) should be used instead
of the given array of actors @CheckingActors. Default is TRUE. 
WARNING: may be extremely slow!!!*/
var(CheckingActors) bool bCheckAllActors; 

var(CheckingActors) bool bCheckOnlyLBActors; 

var(MechanismTick) bool bCheckEveryTick;

/*A set of conditions, which should be correct for checking actor (ALL of them)
to pass the test. NOTE: if specified mechanism or param doesn't exist 
in actor, this actor fails the test. WARNING: don't set param values,
which are not typed by @TargetParamValue.ParamType, it causes bugs!!!*/
var(Conditions) array<ParamValue> Conditions;

var(EventActivation) bool bActivateOnHasActorsMatchingTrue;
var(EventActivation) name OnHasActorsMatchingTrueEvent;

var(EventActivation) bool bActivateOnHasNoActorsMatchingTrue;
var(EventActivation) name OnHasNoActorsMatchingTrueEvent;

var(MechanismDebug) bool bShowDebugGraphics;
var(MechanismDebug) bool bMarkPositiveActors;
var(MechanismDebug) Color PositiveActorsHighlightColor;
var(MechanismDebug) bool bMarkNegativeActors;
var(MechanismDebug) Color NegativeActorsHighlightColor;

function PerfromTick(float dt)
{   
    local array<actor> actors;
    
    if (bCheckEveryTick)
    {
        actors=GetActorsMatchingTrue();    
        
        if (actors.Length!=0)
        {
            if (bActivateOnHasActorsMatchingTrue)
            {
                ActivateKismetEvent(OnHasActorsMatchingTrueEvent,parent.WorldInfo,parent);    
            }    
        }
        else
        {
            if (bActivateOnHasNoActorsMatchingTrue)
            {
                ActivateKismetEvent(OnHasNoActorsMatchingTrueEvent,parent.WorldInfo,parent);    
            }        
        }
    }
}

function bool CheckActorValidity(actor a)
{
    if (bCheckOnlyLBActors && !TargetIsLBObject(a))
    {
        LogError("proc: CheckActorValidity(), actor"@a@"is not valid LB-Object");
        return false;
    }

    return true;    
}

/*Use this function to implement any custom code in derived class*/
function bool CustomActorCheck(actor a)
{
    return true;
}

/*Use this function to implement any custom iterator*/
function GetCheckingActors()
{
    local Actor a;
    
    CheckingActors.Length=0;
    
    foreach parent.AllActors(class 'Actor', a)
    {
        if (a!=parent)
            CheckingActors.AddItem(a);
    } 
}

function bool CheckActor(actor a)
{
    local int i;
    local LBParamContainer value;
    
    //проверяем, имеет ли актор соответствующие интерфейсы
    if (!CheckActorValidity(a))
        return false;
    
    //проверяем, проходит ли актор пользовательскую проверку    
    if (!CustomActorCheck(a))
        return false;
    
    //проверяем все условия для выбранного объекта
    for (i=0;i<Conditions.Length;i++)
    {
        value=GetTargetParamContainer(a,Conditions[i].TargetParam.MechanismName,Conditions[i].TargetParam.ParamName,Conditions[i].TargetParamValue.ParamType);
        if (value!=Conditions[i].TargetParamValue)
        {
            LogInfo("actor"@a@"doesn't pass the check by"@i@"condition");
            return false;    
        }
    }
    
    LogInfo("actor"@a@"passes the check by all conditions");

    return true;
}

function array<actor> GetActorsMatchingTrue()
{
    local array<actor> arr;
    local int i;
    local float h, r;
    
    if (bCheckAllActors)
        GetCheckingActors();    
    
    for (i=0;i<CheckingActors.Length;i++)
    {
        if(CheckActor(CheckingActors[i]))
        {
            arr.AddItem(CheckingActors[i]);
            DGHighlightActor(CheckingActors[i],true);
        }
        else
        {
            DGHighlightActor(CheckingActors[i],false);    
        }
    }
    
    if (bIncludeParent)
    {
        if (CheckActor(parent))
        {
            arr.AddItem(parent);
            DGHighlightActor(parent,true);
        }
        else
        {
            DGHighlightActor(parent,false);    
        }
    }
    
    if (arr.Length==0)
        LogInfo("no actors have passed the <MatchingTrue> test");
    
    return arr;
}

function array<actor> GetActorsMatchingFalse()
{
    local array<actor> arr;
    local int i;
    
    if (bCheckAllActors)
        GetCheckingActors();
    
    for (i=0;i<CheckingActors.Length;i++)
    {
        if(!CheckActor(CheckingActors[i]))
        {
            arr.AddItem(CheckingActors[i]);
            DGHighlightActor(CheckingActors[i],false);
        }
        else
        {
            DGHighlightActor(CheckingActors[i],true);
        }
    }
    
    if (bIncludeParent)
    {
        if (!CheckActor(parent))
        {
            arr.AddItem(parent);
            DGHighlightActor(parent,false);
        }
        else
        {
            DGHighlightActor(parent,true);    
        }   
    }
        
    if (arr.Length==0)
        LogInfo("no actors have passed the <MatchingFalse> test");
    
    return arr;
}

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

function DGHighlightActor(actor a, bool b)
{
    local float r,h;
    
    if (bShowDebugGraphics)
    { 
        if (b)
        {
            if (bMarkPositiveActors)
            {
                a.GetBoundingCylinder(r,h);
                a.DrawDebugSphere(a.Location,h+h/4,12,PositiveActorsHighlightColor.R,PositiveActorsHighlightColor.G,PositiveActorsHighlightColor.B); 
            } 
        }
        else
        {
            if (bMarkNegativeActors)
            {
                a.GetBoundingCylinder(r,h);
                a.DrawDebugSphere(a.Location,h+h/4,12,NegativeActorsHighlightColor.R,NegativeActorsHighlightColor.G,NegativeActorsHighlightColor.B);
            }  
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
   

defaultproperties
{
    mechname="Actor_Checking_Mechanism"
    
    PositiveActorsHighlightColor=(B=0,G=0,R=200)
    NegativeActorsHighlightColor=(B=200,G=0,R=0)
    
    bMarkPositiveActors=true
    bMarkNegativeActors=false
}