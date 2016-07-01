/**
 *  LBInteractionPawnMechanism
 *
 *  Creation date: 25.05.2016 20:42
 *  Copyright 2016, Windows7
 */
class LBInteractionPawnMechanism extends LBInteractableMechanism;

struct LBInteractionValue
{
    var() name TargetMechanism;
    var() name TargetParamName;
    var() LBParamContainer Value;
    var() LBParamContainer DefaultValue;
};

struct LBInteraction
{
    var() string InteractionName;
    
    var() actor TargetActor;
    var() bool bUsePresetActor; //Set to true if @TargetActor should be used as an override 
    var() bool bIsInstant; //Set to true if this interaction is executed once, with no need to default its value
    
    var() array<LBInteractionValue> Values;
    
    var() bool bIsActive; //When set to true this interaction will be automatically applied
};

var(InteractionMechanism) array<Actor> TargetActors;
var(InteractionMechanism) array<LBInteraction> Interactions;
var(InteractionMechanism) int CurInteraction; //An interaction to apply to selected actors
var(InteractionMechanism) bool bNotifyTarget; //Set to true if bInteracting should be sent to the target

var(ParamSource) LBParamSourcePointer TargetActorsSource;
var(ParamSource) LBParamSourcePointer ActivateInteractionSource;
var(ParamSource) LBParamSourcePointer DeactivateInteractionSource;

function PerformInteraction(bool b)
{
    local int i,j;
    
    for (i=0; i<TargetActors.Length; i++)
    {
        //if (bNotifyTarget)
        //     SetTargetParamBool(TargetActors[i], ); 
        
        for (j=0; j<Interactions[CurInteraction].Values.Length; j++)
        {
            if (b)
            {
                LogInfo("applying"@Interactions[CurInteraction].InteractionName@"to"@TargetActors[i]);
                SetTargetParamContainer(TargetActors[i], Interactions[CurInteraction].Values[j].TargetMechanism, Interactions[CurInteraction].Values[j].TargetParamName, Interactions[CurInteraction].Values[j].Value);
            }
            else
            {
                LogInfo("applying"@Interactions[CurInteraction].InteractionName@"(default) to"@TargetActors[i]);
                SetTargetParamContainer(TargetActors[i], Interactions[CurInteraction].Values[j].TargetMechanism, Interactions[CurInteraction].Values[j].TargetParamName, Interactions[CurInteraction].Values[j].DefaultValue);
            }
        }
    }
}

function ActivateInteraction(int id)
{
    local int i, j;
    
    if (id<0 || id>=Interactions.Length || Interactions[id].bIsActive)
        return;
        
    LogInfo("activating interaction"@id@Interactions[id].InteractionName);    
    Interactions[id].bIsActive=true;
    
    for (i=0; i<TargetActors.Length; i++)
    {
        for (j=0; j<Interactions[id].Values.Length; j++)
        {
            LogInfo("applying"@Interactions[id].InteractionName@"to"@TargetActors[i]);
            SetTargetParamContainer(TargetActors[i], Interactions[id].Values[j].TargetMechanism, Interactions[id].Values[j].TargetParamName, Interactions[id].Values[j].Value);
        }
    }
}

function DeactivateInteraction(int id)
{
    local int i, j;
    
    if (id<0 || id>=Interactions.Length || !Interactions[id].bIsActive)
        return;
        
    LogInfo("deactivating interaction"@id@Interactions[id].InteractionName);    
    Interactions[id].bIsActive=false;
    
    for (i=0; i<TargetActors.Length; i++)
    {
        for (j=0; j<Interactions[id].Values.Length; j++)
        {
            LogInfo("applying"@Interactions[id].InteractionName@"(default) to"@TargetActors[i]);
            SetTargetParamContainer(TargetActors[i], Interactions[id].Values[j].TargetMechanism, Interactions[id].Values[j].TargetParamName, Interactions[id].Values[j].DefaultValue);
        }
    }
}

function GetTargetActors(array<object> arr)
{
    local int i;
    
    TargetActors.Length=0;
    
    for (i=0; i<arr.Length; i++)
    {
        if (actor(arr[i])!=none)
            TargetActors.AddItem(actor(arr[i]));
    }
}

function GetParameters()
{
    local int v;
    local array<object> vs;
    
    if (ActivateInteractionSource.bUseSource)
    {
        v=GetTargetParamInt(ActivateInteractionSource.SourceActor, ActivateInteractionSource.SourceMechanismName, ActivateInteractionSource.SourceParamName);    
        ActivateInteraction(v);
    } 
   
    if (DeactivateInteractionSource.bUseSource)
    {
        v=GetTargetParamInt(DeactivateInteractionSource.SourceActor, DeactivateInteractionSource.SourceMechanismName, DeactivateInteractionSource.SourceParamName);    
        DeactivateInteraction(v);
    } 
    
    if (TargetActorsSource.bUseSource)
    {
        vs=GetTargetParams(TargetActorsSource.SourceActor, TargetActorsSource.SourceMechanismName, TargetActorsSource.SourceParamName);    
        GetTargetActors(vs);
    } 
} 

function SetParamBool(name param, bool value, optional int priority=0)
{
    if (param=='PerformInteraction')
        PerformInteraction(value);   
}  
    
function SetParamInt(name param, int value, optional int priority=0)
{
    if (param=='ActivateInteraction')
        ActivateInteraction(value); 
    if (param=='DeactivateInteraction')
        DeactivateInteraction(value);     
} 
    
defaultproperties
{
    bNotifyTarget=false
    
    MechanismParams.Empty
    
    MechanismParams(0)=(ParamName="PerformInteraction", ParamInfo="Boolean. Write. When set to true executes @CurInteraction interaction on @TargetActors. When set to false defaults @CurInteraction interaction on @TargetActors.")
    MechanismParams(1)=(ParamName="ActivateInteraction", ParamInfo="Integer. Write. Set @value to perform @value interaction, until @DeactivateInteraction is called.")
    MechanismParams(2)=(ParamName="DeactivateInteraction", ParamInfo="Integer. Write. Set @value to restrict @value interaction.")
}
