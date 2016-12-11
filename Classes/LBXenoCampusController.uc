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

var(Animation) name BlendByActionNode; //A node in animtree, which blends through all head actions
var(Animation) array<name> ActionSequences; //An array of all sequences, which represent certain actions

var AnimNodeBlendList blendbyaction; 
var array<AnimNodeSequence> actionseqs;

var int curinteraction;

var int curaction; //действие пауна

var actor otheractor; //актор, с которым предполаагется взаимодействие

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
    
    //Head animations init
    blendbyaction=AnimNodeBlendList(LBPawn(parent).Mesh.FindAnimNode(BlendByActionNode));  

    if (blendbyaction == none)
    {
        LogError("BlendByActionNode" @ BlendByActionNode @ "not found in" @ LBPawn(parent) @ " in " @ LBPawn(parent).Mesh);
        return;
    }
    
    LogInfo("Action animations blender found:" @ BlendByActionNode @ blendbyaction);
    
    blendbyaction.SetActiveChild(0, 0.5); //сброс на исходное состояние
    
    for (i=0; i<ActionSequences.Length; i++)
    {
        anim=AnimNodeSequence(LBPawn(parent).Mesh.FindAnimNode(ActionSequences[i]));
        
        if (anim != none)
        {
            actionseqs.AddItem(anim);
            LogInfo("Action animation found:" @ ActionSequences[i] @ anim);
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
    if (value == 1)
    {
        //activate interaction: Call
        
        if (curaction != 0)
            return; //если выполняется другое действие - выход
        
        //set speed (get default positive speed)
        //set action
        
        //play call animation (from animtree)
        blendbyaction.SetActiveChild(1, 0.5);
        actionseqs[0].SetPosition(0.0, false);
        actionseqs[0].PlayAnim(false, 0.5, 0.0);
        
        //play sound (plays in animtree)    
    }
    else if (value == 2)
    {
        //activate interaction: Emote yes
        //doesn't activate PerformInteraction()
        
        if (curaction != 0)
            return; //если выполняется другое действие - выход
        
        blendbyaction.SetActiveChild(2, 0.5);
        actionseqs[1].SetPosition(0.0, false);
        actionseqs[1].PlayAnim(false, 0.8, 0.0);
    }
    else if (value == 3)
    {
        //activate interaction: Emote no
        //doesn't activate PerformInteraction()
        
        if (curaction != 0)
            return; //если выполняется другое действие - выход
        
        blendbyaction.SetActiveChild(3, 0.5);
        actionseqs[2].SetPosition(0.0, false);
        actionseqs[2].PlayAnim(false, 0.8, 0.0);
    }
    else if (value == 4)
    {
        //activate interaction: Emote don't know
        //doesn't activate PerformInteraction()
        
        if (curaction != 0)
            return; //если выполняется другое действие - выход
        
        blendbyaction.SetActiveChild(4, 0.5);
        actionseqs[3].SetPosition(0.0, false);
        actionseqs[3].PlayAnim(false, 0.8, 0.0);
    }
    else if (value == 5)
    {
        //activate interaction: Pick up
        
        if (curaction != 0)
            return; //если выполняется другое действие - выход
        
        //get the targeted actor whcih we will use later or exit    
        if (!SetOtherActorFromTarget())
        {
            LogError("proc: ActivateInteraction() return: OtherActor is not actor or none:"@otheractor); 
            return;
        }
        
        if (!CheckInteractioConditions(2))
        {
            LogError("proc: ActivateInteraction() return: [CheckInteractioConditions(2)] returned false!"); 
            return; 
        }
            
        blendbyaction.SetActiveChild(5, 0.5);
        actionseqs[4].SetPosition(0.0, false);
        actionseqs[4].PlayAnim(false, 0.8, 0.0);    
    }
    else if (value == 6)
    {
        //activate interaction: Drop down
        
        if (curaction != 0)
            return; //если выполняется другое действие - выход
        
        if (!CheckInteractioConditions(3))
        {
            //надо чтобы было что-то в инвентаре
            LogError("proc: ActivateInteraction() return: [CheckInteractioConditions(3)] returned false!"); 
            return; 
        }
            
        blendbyaction.SetActiveChild(6, 0.5);
        actionseqs[5].SetPosition(0.0, false);
        actionseqs[5].PlayAnim(false, 0.8, 0.0);    
    }
}

function bool SetOtherActorFromTarget()
{
    //Set otheractor = targeted object from targeting mechanism
    //If set - true, otherwise - false
    
    local object o;
    
    o=GetTargetParam(parent, TargetingMechanism, 'TargetedObject');
    otheractor=actor(o);
    
    if (otheractor!=none) 
        return true; 
    else 
        return false;
}

function bool CheckInteractioConditions(int value)
{
    local vector v;
    local object o;
    local bool b;
    
    if (value == 1)
    {
    }
    else if (value == 2)
    {
        //проверка возможности взять предмет
        o=GetTargetParam(parent, TargetingMechanism, 'TargetedObject');
        SetTargetParam(parent, InventoryMechanism, 'CheckingObject', o);
        b=GetTargetParamBool(parent, InventoryMechanism, 'CanAddToIvnentory');
        return b;
    }
    else if (value == 3)
    {
        //проверка возможности положить предмет
        b=GetTargetParamBool(parent, InventoryMechanism, 'CanRemoveFromIvnentory');
        return b;
    }
    
    return false;
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
    else if (value == 2)
    {
        //взять предмет
        //v=GetTargetParamVector(parent, InfoMechanism, 'Location');
        //o=GetTargetParam(parent, TargetingMechanism, 'TargetedObject');
        
        if (otheractor==none)
        {
            LogError("proc: PickUp interaction failed, targeted object is not an actor or none:"@o); 
            return;
        }
        
        SetTargetParam(parent, InventoryMechanism, 'AddObject', otheractor);
        
        otheractor=none;
        
        //схватить - т.е. Attach
    }
    else if (value == 3)
    {
        //положить предмет
        //v=GetTargetParamVector(parent, InfoMechanism, 'Location');
        //o=GetTargetParam(parent, TargetingMechanism, 'TargetedObject');
       
        SetTargetParamBool(parent, InventoryMechanism, 'RemoveAllObjects', true);
    }
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
    
    for (i=0; i<actionseqs.Length; i++)
    {
        if (notifynode == actionseqs[i])
        {
            //Performing call animation
            if (notifynode.NodeName == 'Sound_Call') //захардкодено!!!
            {
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
                    blendbyaction.SetActiveChild(0, 0.5); //возвращаем переключатель на исходное состояние
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
                    blendbyaction.SetActiveChild(0, 0.5); //возвращаем переключатель на исходное состояние
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
                    blendbyaction.SetActiveChild(0, 0.5); //возвращаем переключатель на исходное состояние
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
                    blendbyaction.SetActiveChild(0, 0.5); //возвращаем переключатель на исходное состояние
                    curaction=0; //сообщаем, что действие было завершено
                }
            } 
            else if (notifynode.NodeName == 'Interaction_PickUp') //захардкодено!!!
            {
                if (notifytype == AnimNotifyTypes_ActionStart)
                {
                    curaction=5; //закрепляем действие, чтобы не было прервано
                }
                else if (notifytype == AnimNotifyTypes_PerformAction)
                {
                    PerformInteraction(2); //выполняем действие
                }
                else if (notifytype == AnimNotifyTypes_ActionEnd)
                {
                    //AnimNodeSequence(LBPawn(parent).Mesh.FindAnimNode('blendperbone')).SetActiveChild(0, 0.5);
                    blendbyaction.SetActiveChild(0, 0.5); //возвращаем переключатель на исходное состояние
                    curaction=0; //сообщаем, что действие было завершено
                }
            } 
            else if (notifynode.NodeName == 'Interaction_DropDown') //захардкодено!!!
            {
                if (notifytype == AnimNotifyTypes_ActionStart)
                {
                    curaction=6; //закрепляем действие, чтобы не было прервано
                }
                else if (notifytype == AnimNotifyTypes_PerformAction)
                {
                    PerformInteraction(3); //выполняем действие
                }
                else if (notifytype == AnimNotifyTypes_ActionEnd)
                {
                    LogInfo("!!!");
                    //AnimNodeSequence(LBPawn(parent).Mesh.FindAnimNode('blendperbone')).SetActiveChild(0, 0.5);
                    blendbyaction.SetActiveChild(0, 0.5); //возвращаем переключатель на исходное состояние
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
    InteractionInfo(2)="Pick up"
    InteractionInfo(3)="Drop down"
    
    BlendByActionNode="BlendByAction"
    
    curinteraction=0
}
