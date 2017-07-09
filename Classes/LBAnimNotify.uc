/**
 *  LBAnimNotify
 *
 *  Creation date: 10.07.2017 00:32
 *  Copyright 2017, Win10
 */
class LBAnimNotify extends AnimNotify_Scripted
dependson(LBMechanism);

function NotifyActor(Actor target, AnimNodeSequence seq, AnimNotify notify)
{
    local LBActor a;
    local LBPawn p;
    local LBSkeletalMeshActor s;
    local LBDynamicActor d;
    local LBSKMPhysicsActor skmph;
    local LBSMPhysicsActor smph;
    
    a=LBActor(target);
    
    if (a!=none)
    {   
        a.AnimNotifyAllMechanisms(seq,notify);
        return;
    }
    
    p=LBPawn(target);
    
    if (p!=none)
    {
        p.AnimNotifyAllMechanisms(seq,notify);
        return;
    }
    
    d=LBDynamicActor(target);
    
    if (d!=none)
    {
        d.AnimNotifyAllMechanisms(seq,notify);
        return;
    }
    
    s=LBSkeletalMeshActor(target);
    
    if (s!=none)
    {   
        s.AnimNotifyAllMechanisms(seq,notify);
        return;
    }
    
    skmph=LBSKMPhysicsActor(target);
    
    if (skmph!=none)
    {   
        skmph.AnimNotifyAllMechanisms(seq,notify);
        return;
    }
    
    smph=LBSMPhysicsActor(target);
    
    if (smph!=none)
    {   
        smph.AnimNotifyAllMechanisms(seq,notify);
        return;
    }

}


defaultproperties
{
}
