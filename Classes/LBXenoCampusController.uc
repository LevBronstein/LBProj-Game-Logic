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

var int curaction; //действие пауна

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
    //if (curinteraction != 0)
    //{
    //    //выход, если на данный момент выполняется какое-либо взаимодействие
    //    return;
    //}
        
    if (value == 1)
    {
        //activate interaction: Call
        
        if (curaction != 0)
            return; //если выполняется другое действие - выход
        
        //set speed (get default positive speed)
        //set action
        
        //play call animation (from animtree)
        blendbyheadaction.SetActiveChild(1, 0.5);
        headactionseqs[0].SetPosition(0.0, false);
        headactionseqs[0].PlayAnim(false, 0.5, 0.0);
        
        //play sound (plays in animtree)    
    }
    else if (value == 2)
    {
        //activate interaction: Emote yes
        //doesn't activate PerformInteraction()
        
        if (curaction != 0)
            return; //если выполняется другое действие - выход
        
        blendbyheadaction.SetActiveChild(2, 0.5);
        headactionseqs[1].SetPosition(0.0, false);
        headactionseqs[1].PlayAnim(false, 0.8, 0.0);
    }
    else if (value == 3)
    {
        //activate interaction: Emote no
        //doesn't activate PerformInteraction()
        
        if (curaction != 0)
            return; //если выполняется другое действие - выход
        
        blendbyheadaction.SetActiveChild(3, 0.5);
        headactionseqs[2].SetPosition(0.0, false);
        headactionseqs[2].PlayAnim(false, 0.8, 0.0);
    }
    else if (value == 4)
    {
        //activate interaction: Emote don't know
        //doesn't activate PerformInteraction()
        
        if (curaction != 0)
            return; //если выполняется другое действие - выход
        
        blendbyheadaction.SetActiveChild(4, 0.5);
        headactionseqs[3].SetPosition(0.0, false);
        headactionseqs[3].PlayAnim(false, 0.8, 0.0);
    }
}

function PerformInteraction(int value)
{
    local vector v;
    local object o;
    
    if (value == 1)
    {
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
    }
    //else if (value == 3)
    //{
    //    o=GetTargetParam(parent, TargetingMechanism, 'TargetedObject');
    //    
    //    if (actor(o)==none)
    //    {
    //        LogError("proc: ActivateInteraction(), targeted object is not an actor or none:"@o); 
    //        return;
    //    }
    //    
    //    SetTargetParamInt(actor(o), OtherActorsMechanism, 'ActorState', 3);
    //    curinteraction=3;
    //}
    
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
    
//событие для вызова из дерева анимаций
event OwnerAnimNotify(AnimNodeSequence notifynode, AnimNotifyTypes notifytype)
{
    local int i;
    
    for (i=0; i<headactionseqs.Length; i++)
    {
        if (notifynode == headactionseqs[i])
        {
            //Performing call animation
            if (notifynode.NodeName == 'Sound_Call') //захардкодено!!!
            {
                //здесь баг: почему-то можно зажать сначала зов, а потом другое действие
                //и будет проиграна анимация другого действия, но звук будет зова
                if (notifytype == AnimNotifyTypes_ActionStart)
                {
                     curaction=1; //закрепляем действие, чтобы не было прервано
                }
                else if (notifytype == AnimNotifyTypes_PerformAction)
                {
                    PerformInteraction(1); //выполняем действие
                }
                else if (notifytype == AnimNotifyTypes_ActionEnd)
                {
                    curaction=0; //сообщаем, что действие было завершено
                }
            }
            else if (notifynode.NodeName == 'Emote_Yes')
            {
                if (notifytype == AnimNotifyTypes_ActionStart)
                {
                    curaction=2; //закрепляем действие, чтобы не было прервано
                }
                else if (notifytype == AnimNotifyTypes_ActionEnd)
                {
                    curaction=0; //сообщаем, что действие было завершено
                }
            }  
            else if (notifynode.NodeName == 'Emote_No')
            {
                if (notifytype == AnimNotifyTypes_ActionStart)
                {
                    curaction=3; //закрепляем действие, чтобы не было прервано
                }
                else if (notifytype == AnimNotifyTypes_ActionEnd)
                {
                    curaction=0; //сообщаем, что действие было завершено
                }
            }  
            else if (notifynode.NodeName == 'Emote_Dontknow')
            {
                if (notifytype == AnimNotifyTypes_ActionStart)
                {
                    curaction=4; //закрепляем действие, чтобы не было прервано
                }
                else if (notifytype == AnimNotifyTypes_ActionEnd)
                {
                    curaction=0; //сообщаем, что действие было завершено
                }
            }  
        }
    }
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
