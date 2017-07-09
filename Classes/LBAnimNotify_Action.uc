/**
 *  LBAnimNotify_Action
 *
 *  Creation date: 10.07.2017 00:35
 *  Copyright 2017, Win10
 */
class LBAnimNotify_Action extends LBAnimNotify
dependson (LBBasicCharacaterController);

var() int ActionCode;
var() int ActionData;
var() ActionNotifyTypes ActionNotifyType;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    NotifyActor(Owner,AnimSeqInstigator,self);
}


defaultproperties
{
}