/**
 *  AnimNotify_MechanismEvent
 *
 *  Creation date: 11.07.2016 20:32
 *  Copyright 2016, Windows7
 */
class AnimNotify_MechanismEvent extends AnimNotify_Scripted
dependson(LBMechanism);

var() name TargetMechanism;
var() AnimNotifyTypes NotifyType;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local LBPawn p;
    local LBMechanism m;
   
    p = LBPawn(Owner);
    
    if ( p != none )
    {
        m = p.GetMechanismByName(TargetMechanism);
        
        if ( m !=none )
        {
            m.OwnerAnimNotify(AnimSeqInstigator, NotifyType);
        }
    }
}


defaultproperties
{
}
