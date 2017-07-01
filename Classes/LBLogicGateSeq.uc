/**
 *  LBLogicAndGateSeq
 *
 *  Creation date: 21.06.2017 21:56
 *  Copyright 2017, Win10
 */
class LBLogicGateSeq extends SequenceAction;

enum LogigGateTypes
{
    LogigGateTypes_And,
    LogigGateTypes_Or,
};

var() LogigGateTypes LogicGateType;

var bool b1,b2,b3,b4;

event Activated()
{
    local int i;
    local bool b;
    
    if (InputLinks[0].bHasImpulse)
    {
        b1=true;
    }
    if (InputLinks[1].bHasImpulse)
    {
        b1=false;
    }
    if (InputLinks[2].bHasImpulse)
    {
        b2=true;
    }
    if (InputLinks[3].bHasImpulse)
    {
        b2=false;
    }
    if (InputLinks[4].bHasImpulse)
    {
        b3=true;
    }
    if (InputLinks[5].bHasImpulse)
    {
        b3=false;
    }
    if (InputLinks[6].bHasImpulse)
    {
        b4=true;
    }
    if (InputLinks[7].bHasImpulse)
    {
        b4=false;
    }
    
    if (LogicGateType == LogigGateTypes_And)
    {
        b=b1 && b2 && b3 && b4;     
    }
    else
    {
        b=b1 || b2 || b3 || b4;     
    }
    
    if (b == true)
    {
        OutputLinks[0].bHasImpulse=true;   
        OutputLinks[1].bHasImpulse=false; 
    }
    else
    {
        OutputLinks[0].bHasImpulse=false;   
        OutputLinks[1].bHasImpulse=true; 
    }
}

defaultproperties
{
    bCallHandler=false
    bAutoActivateOutputLinks=false
    
    ObjName="Logic Gate"
    ObjCategory="LevBronstein Utils"
    
    InputLinks[0]=(LinkDesc="Set Input 1")
    InputLinks[1]=(LinkDesc="Reset Input 1")
    InputLinks[2]=(LinkDesc="Set Input 2")
    InputLinks[3]=(LinkDesc="Reset Input 2")
    InputLinks[4]=(LinkDesc="Set Input 3")
    InputLinks[5]=(LinkDesc="Reset Input 3")
    InputLinks[6]=(LinkDesc="Set Input 4")
    InputLinks[7]=(LinkDesc="Reset Input 4")
    
    OutputLinks[0]=(LinkDesc="Conditions met")
    OutputLinks[1]=(LinkDesc="Conditions not met")
}
