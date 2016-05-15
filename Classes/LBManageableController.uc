/**
 *  LBManageableController
 *
 *  Creation date: 15.05.2016 21:53
 *  Copyright 2016, Windows7
 */
class LBManageableController extends LBActorController;

var(ManageableController) bool bManageableBySolver; //Set to true if the Solver can interact with this instance
var(ManageableController) bool bTargeted;
var(ManageableController) bool bInteracting; //Set to true eveytime the Solver manages this instance
var(MechanismDebug) bool bShowDebugLines; //Display debug in game

function FirstTickInit()
{
    if (bfirsttick==false)
        return;
    
    if (bfirsttick==true)
        bfirsttick=false;      
}

event OwnerTick(float deltatime)
{
    super.OwnerTick(deltatime);
    
    if (benabled==false)
        return;
        
    PerformTick();
}   

function PerformTick()
{
    local Box b;
    local vector v;
    
    if (bTargeted)
    {
        if (bShowDebugLines==true)
        {
            parent.GetComponentsBoundingBox(b);
            v=b.max-b.min;
            parent.DrawDebugSphere(parent.location, vsize(v)/3, 16, 255, 0, 0);
        }
    }
}
    
function bool GetParamBool(name param)
{
    if (param=='bManageableBySolver')
        return bManageableBySolver;
    else if(param=='bInteracting')
        return  bInteracting;
    else if(param=='bTargeted')
        return  bTargeted;
    else
        return false;
}
    
function SetParamBool(name param, bool value)
{
    //`log(param @ value);
    if (param=='bManageableBySolver')
        bManageableBySolver=value;
    if (param=='bTargeted')
        bTargeted=value;
    else if(param=='bInteracting')
        bInteracting=value;    
}       
    
function float GetParamFloat(name param)
{
    if (bInteracting==false)
        return 0;

    return super.GetParamFloat(param);     
} 

function SetParamFloat(name param, float value)
{
    if (bInteracting==false)
        return;
        
    super.SetParamFloat(param, value);    
}   
    

defaultproperties
{
    mechname="Managed_Controller"
    
    bShowDebugLines=false
    
    bManageableBySolver=true
    bTargeted=false;
    bInteracting=false
}
