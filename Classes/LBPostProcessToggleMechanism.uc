/**
 *  LBPostProcessToggleMechanism
 *
 *  Creation date: 24.06.2017 19:10
 *  Copyright 2017, Win10
 */
class LBPostProcessToggleMechanism extends LBMechanism;

var(PostProcessToggle) array<PostProcessChain> PostProcessChains; // A list of all avaliable post-process chains (pre-defined because of package linking)
var(PostProcessToggle) int ActivePostProcessChain; // Current active PostProcessChain
var(PostProcessToggle) bool bToggleOnInit; // Set to true if the @ActivePostProcessChain should be toggled immediately after start (in @InitMechanism)

function ActivatePostProcess(int id)
{
    local PlayerController pc;
    local Player p;
    
    if (id<0)
    {
        LogError("Incorrect @ActivePostProcessChain or @PostProcessChains is empty!");
        return;
    }
       
    foreach parent.LocalPlayerControllers(class'PlayerController', pc)
    {
        p=pc.Player;
        localplayer(p).RemoveAllPostProcessingChains();
        localplayer(p).InsertPostProcessingChain(PostProcessChains[id], -1 , false);
    }    
}

function ChangeActivePostProcessChain(int newid)
{    
    if (PostProcessChains.Length == 0)
    {
        ActivePostProcessChain=-1;    
    }
    else
    {
        ActivePostProcessChain=Clamp(newid,0,PostProcessChains.Length-1);
    }
}

function InitMechanism()
{
    ChangeActivePostProcessChain(ActivePostProcessChain);
    
    if (bToggleOnInit) 
        ActivatePostProcess(ActivePostProcessChain);    
}

defaultproperties
{
    mechname="Post_Process_Toggle_Mechanism"    
}
