/**
 *  LBVisibilityModifier
 *
 *  Creation date: 02.07.2016 23:52
 *  Copyright 2016, Windows7
 */
class LBVisibilityModifier extends LBMechanism;

var(VisibilityModifier) bool bVisible;

function FirstTickInit()
{
    if (bfirsttick==false)
        return;
    
    if (bfirsttick==true)
        bfirsttick=false;   
     
    parent.SetHidden(!bVisible);
}

function SetParamBool(name param, bool value, optional int priority=0)
{
    if (param=='bVisible')
    {
        bVisible=value;
        parent.SetHidden(!bVisible);
    }
} 

defaultproperties
{
}
