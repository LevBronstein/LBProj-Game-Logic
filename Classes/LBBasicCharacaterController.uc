/**
 *  LBBasicCharacaterController
 *
 *  Creation date: 04.07.2017 22:55
 *  Copyright 2017, Win10
 */
class LBBasicCharacaterController extends LBInteractableMechanism;

enum ActionTypes
{
    ActionTypes_SartStopWithAnim, //Action starts when animation starts, ends when animation ends, returns to default action
    ActionTypes_LoopWithAnim, //Action starts when animation starts, stops when interrupted or deactivated (for looped or continious)
    ActionTypes_SartStopByNotify,  //Action starts when animnotify_start is reached, stops, when animnotify_stop is reached
    ActionTypes_ContiniousOrNoAnim, //Action is performed after activation undefined time or has no or default animation
};

enum InterruptTypes
{
    InterruptTypes_Interruptable, //Action can be interrupted abytime anyway
    InterruptTypes_Uninterruptible, //Action cannot be interrupted
    InterruptTypes_ConditionalInterrupt, //Action can be interrupted when @bcaninterrupt is true
    //InterruptTypes_SwitchInterrupt, //Action can be interrupted or switched to an action from list @AllowedToSwitchActions
};

struct LBCharActionInfo
{
    var() int ActionCode; //The code of this action, used in script
    var() name ActionName; //The name of this action, should be the same as the corresponding link in LBBlendByAction
    var() ActionTypes ActionType;
    var() InterruptTypes InterruptType;
    var(Action) bool bActivatesFromDefault; //This action can be activated from Default (-1) action
    var(Action) bool bAllowMovement; //This action can only be performed while idle, no movement can be performed during this action
    var(ActionInterrupt) array<int> AllowedInterruptActions; //Array of action codes, which overrides <all actions> by default with few from this list which are allowed to interrupt this action
    var(ActionSwitch) int SwitchToAction; //Code of an action, to which this action should switch after it finishes, -1 is for Default
    var(Animation) bool bLoopActionAnim;
    var(Animation) float ActionAnimPlayRate;
    var(Animation) float ActionAnimPlayPos;
    var(Animation) float ActionAnimBlendTime;
        
    structdefaultproperties
    {
        SwitchToAction=-1
        bActivatesFromDefault=true
        
        bLoopActionAnim=false
        ActionAnimPlayRate=1.0f
        ActionAnimPlayPos=0.0f
        ActionAnimBlendTime=0.15f
    }
};

var(ActionAnimations) array<LBCharActionInfo> CharacterActionList;

var array<LBBlendByAction> blendbyactionnodes; 
var array<AnimNodeSequence> actionseqs;

var LBCharActionInfo defaultaction;

var int curaction; //текущее действие (индекс в массиве CharacterActionList)
var bool bcaninterrupt; //можно ли прервать в данный момент текущее действие
var AnimNode curanim; //текущая анимация

function InitMechanism()
{    
    curaction=-1;
    
    defaultaction.ActionCode=-1;
    defaultaction.ActionName='Default';    
    
    InitAnimation();    
}

function InitAnimation()
{
    local LBBlendByAction blendbyaction;
    local AnimNodeSequence anim;

    local int i;
    
    LogInfo("Blend by action nodes:");

    i=0;
    
    foreach LBPawn(parent).Mesh.AllAnimNodes(class'LBBlendByAction', blendbyaction)
    {
        if (blendbyaction!=none)
        {
            i++;
            blendbyaction.SetActiveChild(0, 0.5); //сброс на исходное состояние
            LogInfo(i@":"@blendbyaction);
            blendbyactionnodes.AddItem(blendbyaction);
        }
               
    }
    
    if (i==0)
        LogInfo("None found...");
}
    
function PerfromTick(float dt)
{
    if (curaction<0) //если нету действия -- не наше дело
        return;
    
    
    if (AnimNodeSequence(curanim)!=none)
    {
       //`log(curanim@"is playing:"@AnimNodeSequence(curanim).bPlaying);
        
        if (!AnimNodeSequence(curanim).bPlaying) //Если вдруг прекратилось проигрывание
        {
            if (CharacterActionList[curaction].ActionType == ActionTypes_SartStopWithAnim)
            {
                OnActionStop(curaction);        
            }        
        }
    }    
}    

function LBCharActionInfo CharActionInfoByIndex(int index)
{
    if (index>-1 && index<CharacterActionList.Length)
        return CharacterActionList[index];
    else
        return defaultaction;    
}

function LBCharActionInfo FindCharActionInfoByCode(int actioncode)
{
    local int i;
    local LBCharActionInfo info;
    
    if (actioncode == -1)
    {
        return defaultaction;
    }
    
    for (i=0;i<CharacterActionList.Length;i++)
    {
        if (CharacterActionList[i].ActionCode==actioncode)
        {
            return CharacterActionList[i];    
        }
    }
        
    info.ActionCode=-1;
    info.Actionname='';
    
    return info;    
}

function int FindCharActionInfoIndexByCode(int actioncode)
{
    local int i; 
 
    for (i=0;i<CharacterActionList.Length;i++)
    {
        if (CharacterActionList[i].ActionCode==actioncode)
        {
            return i;    
        }
    }   
    
    return -1;
}

function bool IsAllowedInterruptor(LBCharActionInfo curaction, LBCharActionInfo newaction)
{
    local int i;
    
    if (curaction.AllowedInterruptActions.Length>0)
    {
        for (i=0;i<curaction.AllowedInterruptActions.Length;i++)
        {
            if (newaction.ActionCode == curaction.AllowedInterruptActions[i])
                return true;    
        }    
    }   
    else
        return true; 
        
    return false;
}

function UpdateAnimationNodes(LBCharActionInfo actioninfo)
{
    local int i,j;
    local AnimNode anim;
     
    for (i=0;i<blendbyactionnodes.Length;i++)
    {
        for (j=0;j<blendbyactionnodes[i].Children.Length;j++)
        {
            if (blendbyactionnodes[i].Children[j].Name == actioninfo.ActionName)
            {
                blendbyactionnodes[i].SetActiveChild(j,actioninfo.ActionAnimBlendTime);
                anim=blendbyactionnodes[i].Children[j].Anim;
                //AnimNodeSequence(anim).SetPosition(0.0f,false);
                //AnimNodeSequence(anim).PlayAnim(actioninfo.bLoopActionAnim,actioninfo.ActionAnimPlayRate,actioninfo.ActionAnimPlayPos); 
                curanim=anim;
                //по умолчанию не трогаем -- там всё само регулируеются   
                if (actioninfo.ActionName != 'Default')
                {
                    anim.PlayAnim(actioninfo.bLoopActionAnim,actioninfo.ActionAnimPlayRate,actioninfo.ActionAnimPlayPos); //не нужно сразу проигрывать! просто перемотать время на 0.0, установить скорость а может и нет  
                }
                //anim.PlayAnim();
            }
        }  
    }    
}

/*An entry point to the Action System
Called to start corresponding animation from @CharacterActionList 
*/
function BeginAction(int actionid)
{
    local LBCharActionInfo actioninfo;
    local LBCharActionInfo curactioninfo;
    local int i;
    
    actioninfo=CharActionInfoByIndex(actionid);
    curactioninfo=CharActionInfoByIndex(curaction);
        
    if(actioninfo.ActionName == '')
    {
        LogError("proc:: BeginAction(); action "$actionid$" is not avaliable.");
        return;
    }   
    
    //если текущее действие не является действием по умолчанию, которое может быть прервано запросто   
    if(curaction>-1)
    {
        //если текущее действие не может быть прервано
        if (curactioninfo.InterruptType == InterruptTypes_Uninterruptible)
        {
            LogError("proc:: BeginAction(); cannot start action "$actioninfo.ActionName$", an uninterruptible action "$curactioninfo.ActionName$" is already being performed.");
            return;  
        }  
        //если текущее действие может быть прервано с опредлённым условием, но условие не выполнено
        else if (curactioninfo.InterruptType == InterruptTypes_ConditionalInterrupt && bcaninterrupt == false)
        {
            LogError("proc:: BeginAction(); cannot start action "$actioninfo.ActionName$", bcaninterrupt is FALSE.");
            return;
        }
    }
    else
    {
        //если текущее действие не может быть вызвано из изначального действия (действием по умолчанию)
        if (actioninfo.bActivatesFromDefault == false)
        {
            LogError("proc:: BeginAction(); cannot start action "$actioninfo.ActionName$", it cannot be activated from within the default action.");
            return;     
        }
    }
    
    //пробиваем по списку доступных прерывателей
    if (IsAllowedInterruptor(curactioninfo,actioninfo))
    {
        if (curaction>-1)
            OnActionInterrupt(actionid, curaction);
        
        LogInfo("proc:: BeginAction(), current action is "$actioninfo.ActionName$".");
            
        curaction=actionid;
        UpdateAnimationNodes(actioninfo);
        OnActionStart(actionid);    
    }
    else
    {
        LogError("proc:: BeginAction(); cannot start action "$actioninfo.ActionName$", because it is not a valid interruptor for action "$curactioninfo.ActionName$".");    
    }
}

function SwitchAction(int actionid)
{
    local LBCharActionInfo actioninfo;
    
    if (CharacterActionList.Length>0 && actionid>0 && actionid<CharacterActionList.Length)
        curaction=actionid; 
    else
        curaction=-1;   
        
    actioninfo=CharActionInfoByIndex(curaction);
    UpdateAnimationNodes(actioninfo);
}

function ResetToDefaultAction()
{
    curaction=-1; 
    UpdateAnimationNodes(defaultaction);   
}

function StopAction(int action)
{
               
}

function HandleActionStart()
{
}

//Called when an action was started 
event OnActionStart(int startedaction)
{
    local LBCharActionInfo actioninfo;
    
    actioninfo=CharActionInfoByIndex(startedaction);
    
    HandleActionStart();    
    
    LogInfo("event:: OnActionStart(); action "@actioninfo.ActionName$" has started.");
}

function HandleAnimNotify()
{
}
    
event OwnerAnimNotify(AnimNodeSequence notifynode, AnimNotifyTypes notifytype)
{
    HandleAnimNotify();
}

function HandleActionStop()
{
}

//Called when an action was successfully completed    
event OnActionStop(int stoppedaction)
{
    local LBCharActionInfo actioninfo;
    local LBCharActionInfo curactioninfo;
    local int newactionid;
    
    actioninfo=CharActionInfoByIndex(stoppedaction);
    
    HandleActionStop();

    if (actioninfo.SwitchToAction<0)
    {
        ResetToDefaultAction(); 
        curactioninfo=CharActionInfoByIndex(curaction);
        LogInfo("event:: OnActionStop(); action "@actioninfo.ActionName$" has stopped, current action is "$curactioninfo.ActionName$".");      
    }
    else 
    {
        newactionid=FindCharActionInfoIndexByCode(actioninfo.SwitchToAction);
        
        SwitchAction(newactionid); 
            
        curactioninfo=CharActionInfoByIndex(curaction);
        LogInfo("event:: OnActionStop(); action "@actioninfo.ActionName$" has stopped, current action is "$curactioninfo.ActionName$"."); 
    }
    
    
    
}

//Called when an action was interrupted
event OnActionInterrupt(int interrupted, int interrupter)
{
    local LBCharActionInfo actioninfo;
    local LBCharActionInfo curactioninfo;
    
    actioninfo=CharActionInfoByIndex(interrupted);
    curactioninfo=CharActionInfoByIndex(interrupter);
    
    LogInfo("event:: OnActionInterrupt(); action "@actioninfo.ActionName$" has interrupted action "$curactioninfo.ActionName$".");    
}

function SetParamInt(name param, int value, optional int priority=0)
{
    super.SetParamInt(param, value);
    
    if (param=='BeginAction')
    {
        BeginAction(FindCharActionInfoIndexByCode(value));
    }
} 
    
defaultproperties
{
    mechname="Basic_Character_Controller"    
}