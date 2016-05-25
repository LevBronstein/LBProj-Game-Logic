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
    
    var() array<LBInteractionValue> Values;
    
    var bool bIsActive;
};

var(InteractionMechanism) array<Actor> TargetActors;
var(InteractionMechanism) array<LBInteraction> Interactions;
var(InteractionMechanism) int CurInteraction; //An interaction to apply to selected actors
var(InteractionMechanism) bool bNotifyTarget; //Set to true if bInteracting should be sent to the target

var(ParamSource) LBMechanismParam TargetActorsSource;

function FirstTickInit()
{
    if (bfirsttick==false)
        return;
    
    if (bfirsttick==true)
        bfirsttick=false;   
}

event OwnerTick(float deltatime)
{
    super.OwnerTick(deltatime);
    
    if (benabled==false)
        return;
    
    PerformActiveInteractions();
}   

//ЗАЧЕМ КАЖДЫЙ ТИК ПРОИЗВОДИТЬ, ЕСЛИ МОЖНО ПОСТАВИТЬ И СНЯТЬ ТОЛЬКО ПО DEACTIVATE?
function PerformActiveInteractions()
{
    local int i,j,k;
    
    for (i=0; i<TargetActors.Length; i++)
    {
        //if (bNotifyTarget)
        //     SetTargetParamBool(TargetActors[i], ); 
        for (k=0; k<Interactions.Length; k++)
        {
            for (j=0; j<Interactions[k].Values.Length; j++)
            { 
                LogInfo("applying"@Interactions[k].InteractionName@"to"@TargetActors[i]);
                SetTargetParamContainer(TargetActors[i], Interactions[k].Values[j].TargetMechanism, Interactions[k].Values[j].TargetParamName, Interactions[k].Values[j].Value);  
            }
        }
    }
}

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
    if (id<0 || id>=Interactions.Length)
        return;
        
    LogInfo("activating interaction"@id@Interactions[id].InteractionName);    
    Interactions[id].bIsActive=true;
}

function DeactivateInteraction(int id)
{
    if (id<0 || id>=Interactions.Length)
        return;
        
    LogInfo("deactivating interaction"@id@Interactions[id].InteractionName);    
    Interactions[id].bIsActive=false;
}

function GetParameters(); 

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
    
    //MechanismParams.Clear()
    MechanismParams(0)=(ParamName="PerformInteraction", ParamInfo="Boolean. Write. When set to true executes @CurInteraction interaction on @TargetActors. When set to false defaults @CurInteraction interaction on @TargetActors.")
    MechanismParams(1)=(ParamName="ActivateInteraction", ParamInfo="Integer. Write. Set @value to perform @value interaction, until @DeactivateInteraction is called.")
    MechanismParams(2)=(ParamName="DeactivateInteraction", ParamInfo="Integer. Write. Set @value to restrict @value interaction.")
}
