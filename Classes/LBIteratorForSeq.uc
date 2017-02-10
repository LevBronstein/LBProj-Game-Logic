/**
 *  LBIteratorForSeq
 *
 *  Creation date: 07.02.2017 19:28
 *  Copyright 2017, Windows7
 */
class LBIteratorForSeq extends SequenceAction;

var() int min, max;
var() bool bResetOnLoopEnd;
var int loopvar;

event Activated()
{
    if (loopvar<min)
        loopvar=min;
    
    if (loopvar<max) 
    {  
        loopvar++;
        OutputLinks[0].bHasImpulse = true;
        OutputLinks[1].bHasImpulse = false;
        //ActivateOutputLink(0);
    }
    else
    {
        OutputLinks[0].bHasImpulse = false; 
        OutputLinks[1].bHasImpulse = true;
        //ActivateOutputLink(1);
        if (bResetOnLoopEnd)
            loopvar=min;    
    }
    
    super.Activated();
}

defaultproperties
{
    bCallHandler=false
    bAutoActivateOutputLinks=false
    
    ObjName="Iterator For Loop"
    ObjCategory="LevBronstein Utils"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Int',LinkDesc="Loop Variable",bWriteable=true,PropertyName=loopvar)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Int',LinkDesc="Min Value",PropertyName=min)
    VariableLinks(2)=(ExpectedType=class'SeqVar_Int',LinkDesc="Max Value",PropertyName=max)
    
    OutputLinks(0)=(LinkDesc="In Loop")
    OutputLinks(1)=(LinkDesc="Out Loop")
}