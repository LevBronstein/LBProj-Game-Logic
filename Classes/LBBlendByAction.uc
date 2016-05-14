/**
 *  LBBlendByAction
 *
 *  Creation date: 12.05.2016 23:03
 *  Copyright 2016, Windows7
 */
class LBBlendByAction extends UDKAnimBlendBase;

var LbPawn p;
var int curaction;

event OnBecomeRelevant()
{
    if (LbPawn(SkelComponent.Owner) != none)
        p=LbPawn(SkelComponent.Owner);
    else
        p=none;
}    

function UpdateCurrentAction(int act)
{
    if (act>=Children.Length || act<0)
        return;
        
    SetActiveChild(act, BlendTime);
}    
    
defaultproperties
{
    bCallScriptEventOnBecomeRelevant = true
    
    Children(0)=(Name="NoAction")
    Children(1)=(Name="Action1")
    
    BlendTime=0.5
    
    curaction=0
}
