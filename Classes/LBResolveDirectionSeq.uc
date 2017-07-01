/**
 *  LBResolveDirectionSeq
 *
 *  Creation date: 21.06.2017 20:19
 *  Copyright 2017, Win10
 */
class LBResolveDirectionSeq extends SequenceAction;

var bool forward, right, left, backward;
var vector dirvect;

var() bool bResetVectorToZero; //Do we need to reset the @dirvect to (0,0,0) when no direction is given

function _ActivateOutpitLink(int id)
{
    local int i;
 
    for (i=0;i<=7;i++)
        OutputLinks[i].bHasImpulse = false; 
        
    OutputLinks[id].bHasImpulse = true; 
}

event Activated()
{
    if (InputLinks[0].bHasImpulse)
    {
        forward=true;
    }
    if (InputLinks[1].bHasImpulse)
    {
        forward=false;
    }
    if (InputLinks[2].bHasImpulse)
    {
        right=true;
    }
    if (InputLinks[3].bHasImpulse)
    {
        right=false;
    }
    if (InputLinks[4].bHasImpulse)
    {
        backward=true;
    }
    if (InputLinks[5].bHasImpulse)
    {
        backward=false;
    }
    if (InputLinks[6].bHasImpulse)
    {
        left=true;
    }
    if (InputLinks[7].bHasImpulse)
    {
        left=false;
    }
    
    if (forward && !right && !backward && !left)
    {
        dirvect=vect(1,0,0);
        _ActivateOutpitLink(0);  
    }
    else if (forward && right && !backward && !left)
    {
        dirvect=vect(0.5,0.5,0);
        _ActivateOutpitLink(1);     
    }
    else if (!forward && right && !backward && !left)
    {
        dirvect=vect(0,1,0);
        _ActivateOutpitLink(2);     
    }
    else if (!forward && right && backward && !left)
    {
        dirvect=vect(-0.5,0.5,0);
        _ActivateOutpitLink(3);     
    }
    else if (!forward && !right && backward && !left)
    {
         dirvect=vect(-1,0,0);
        _ActivateOutpitLink(4);     
    }
    else if (!forward && !right && backward && left)
    {
         dirvect=vect(-0.5,-0.5,0);
        _ActivateOutpitLink(5);     
    }
    else if (!forward && !right && !backward && left)
    {
        dirvect=vect(0,-1,0);
        _ActivateOutpitLink(6);     
    }
    else if (forward  && !right && !backward && left)
    {
        dirvect=vect(0.5,-0.5,0);
        _ActivateOutpitLink(7);     
    }
    else 
    {
        if (bResetVectorToZero)
            dirvect=vect(0,0,0);
    }
    
     _ActivateOutpitLink(8); 
    
    super.Activated();
}

defaultproperties
{
    bCallHandler=false
    bAutoActivateOutputLinks=false
    
    ObjName="Resolve Direction"
    ObjCategory="LevBronstein Utils"
    
    InputLinks(0)=(LinkDesc="Add Forward")
    InputLinks(1)=(LinkDesc="Remove Forward")
    InputLinks(2)=(LinkDesc="Add Right")
    InputLinks(3)=(LinkDesc="Remove Right")
    InputLinks(4)=(LinkDesc="Add Backward")
    InputLinks(5)=(LinkDesc="Remove Backward")
    InputLinks(6)=(LinkDesc="Add Left")
    InputLinks(7)=(LinkDesc="Remove Left")
    
    OutputLinks(0)=(LinkDesc="Forward")
    OutputLinks(1)=(LinkDesc="Forward-Right")
    OutputLinks(2)=(LinkDesc="Right")
    OutputLinks(3)=(LinkDesc="Right-Backward")
    OutputLinks(4)=(LinkDesc="Backward")
    OutputLinks(5)=(LinkDesc="Backward-Left")
    OutputLinks(6)=(LinkDesc="Left")
    OutputLinks(7)=(LinkDesc="Left-Forward")
    OutputLinks(8)=(LinkDesc="Any")
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Direction Vector",bWriteable=true,PropertyName=dirvect)
}
