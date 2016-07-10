/**
 *  LBXenoCampusController
 *
 *  Creation date: 27.06.2016 22:29
 *  Copyright 2016, Windows7
 */
class LBXenoCampusController extends LBPawnInteractableController;

var(MechanismInfo) editconst string InteractionInfo[3];

var(System) name InfoMechanism;
var(System) name OtherActorsMechanism;

var(Animation) name BlendByHeadActionNode; //A node in animtree, which blends through all head actions
var(Animation) array<name> HeadActionSequences; //An array of all sequences, which represent certain actions

var AnimNodeBlendList blendbyheadaction; 
var array<AnimNodeSequence> headactionseqs;

var int curinteraction;

function FirstTickInit()
{
    if (bfirsttick==false)
        return;
    
    if (bfirsttick==true)
        bfirsttick=false;   
     
    InitAnimation();
}


function InitAnimation()
{
    local int i;
    local AnimNodeSequence anim;
    
    blendbyheadaction=AnimNodeBlendList(LBPawn(parent).Mesh.FindAnimNode(BlendByHeadActionNode));  

    if (blendbyheadaction == none)
    {
        LogError("BlendByHeadActionNode" @ BlendByHeadActionNode @ "not found in" @ LBPawn(parent) @ " in " @ LBPawn(parent).Mesh);
        return;
    }
    
    LogInfo("Head animations blender found:" @ BlendByHeadActionNode @ blendbyheadaction);
    
    blendbyheadaction.SetActiveChild(0, 0.5); //сброс на исходное состояние
    
    for (i=0; i<HeadActionSequences.Length; i++)
    {
        anim=AnimNodeSequence(LBPawn(parent).Mesh.FindAnimNode(HeadActionSequences[i]));
        
        if (anim != none)
        {
            headactionseqs.AddItem(anim);
            LogInfo("Head animation found:" @ HeadActionSequences[i] @ anim);
        }
    }
}

event OwnerTick(float deltatime)
{
    super.OwnerTick(deltatime);
    
    if (benabled==false)
        return;
}   


function PerformTick()
{
    //super.PerformTick();
}

function ActivateInteraction(int value)
{
    local vector v;
    local object o;
       
    if (value==1)
    {
        //activate interaction: Call
        
        //set targetobject.LBFloatingCubeController.TargetLocation<-parent.location
        v=GetTargetParamVector(parent, InfoMechanism, 'Location');
        o=GetTargetParam(parent, TargetingMechanism, 'TargetedObject');
        
        if (actor(o)==none)
        {
            LogError("proc: ActivateInteraction(), targeted object is not an actor or none:"@o); 
            return;
        }
        //`log(o@"->"@v);
        SetTargetParamVector(actor(o), OtherActorsMechanism, 'TargetLocation', v);
        //SetTargetParam(actor(o), OtherActorsMechanism, 'OtherActor', parent);
        SetTargetParamInt(actor(o), OtherActorsMechanism, 'ActorState', 1);
        //SetTargetParamBool(actor(o), OtherActorsMechanism, 'bEnableMovement', true);
        
        //set speed (get default positive speed)
        //set action
        
        //play call animation
        blendbyheadaction.SetActiveChild(1, 0.5);
        headactionseqs[0].SetPosition(0.0, false);
        headactionseqs[0].PlayAnim(false, 0.8, 0.0);
        
        //play sound
        
        curinteraction=1;
    }
    else if (value==3)
    {
        o=GetTargetParam(parent, TargetingMechanism, 'TargetedObject');
        
        if (actor(o)==none)
        {
            LogError("proc: ActivateInteraction(), targeted object is not an actor or none:"@o); 
            return;
        }
        
        SetTargetParamInt(actor(o), OtherActorsMechanism, 'ActorState', 3);
        curinteraction=3;
    }
    
    //local actor a;
    //local object o;
    //
    //ActivateInteractionId=value;
    //DeactivateInteractionId=-1;
    //
    //o=GetTargetParam(parent, InteractingMechanism, 'TargetedObject');
    //
    //if (actor(o)==none)
    //{
    //    LogError("proc: ActivateInteraction(), targeted object is not an actor or none:"@o); 
    //    return;
    //}
    //
    //a=actor(o);
    //
    //if (bgroup)
    //    SetTargetParam(parent, GroupingMechanism, 'AddSelectedObject', a);
    //else
    //    SetTargetParam(parent, GroupingMechanism, 'RemoveSelectedObject', a);  
}

function DeactivateInteraction(int value)
{
    //DeactivateInteractionId=value;
    //ActivateInteractionId=-1;
}

function SetParamInt(name param, int value, optional int priority=0)
{
    super.SetParamInt(param, value);
    
    if (param=='ActivateInteraction')
        ActivateInteraction(value);
} 

defaultproperties
{
    InfoMechanism="Actor_Info"
    OtherActorsMechanism="Actor_Controller"
    
    InteractionInfo(0)="No interaction"
    InteractionInfo(1)="Call"
    
    BlendByHeadActionNode="BlendByHeadAction"
    
    curinteraction=0
}
