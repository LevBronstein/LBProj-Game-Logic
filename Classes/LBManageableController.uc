/**
 *  LBManageableController
 *
 *  Creation date: 15.05.2016 21:53
 *  Copyright 2016, Windows7
 */
class LBManageableController extends LBActorController;

var(ManageableController) bool bManageableBySolver; //Set to true if the Solver can interact with this instance
var(ManageableController) bool bTargeted; //Only when the solver looks directtly at this object
var(ManageableController) bool bSelected;  //When the solver adds this object to his list
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
    
    if (bShowDebugLines==true)
    {
        parent.GetComponentsBoundingBox(b);
        v=b.max-b.min;
        if (bSelected)
        {
            parent.DrawDebugSphere(parent.location, vsize(v)/3, 16, 255, 0, 0);
        }
    }
}
    
//ПЕРЕКРЫВАЕТ ЭТУ ЖЕ ПРОЦЕДУРУ В БАЗВОМО КЛАССЕ
function bool GetParamBool(name param)
{
    if (param=='bManageableBySolver')
        return bManageableBySolver;
    else if(param=='bInteracting')
        return  bInteracting;
    else if(param=='bTargeted')
        return  bTargeted;
    else if (param=='bSelected')
        return bSelected;
    else
        return false;
}

//Приоритет не учитывается?    
function SetParamBool(name param, bool value, optional int priority=0)
{
    if (param=='bManageableBySolver')
        bManageableBySolver=value;
    if (param=='bTargeted')
        bTargeted=value;
    if (param=='bSelected')
        bSelected=value;
    else if(param=='bInteracting')
        bInteracting=value;    
}       
    
defaultproperties
{
    mechname="Managed_Object_Controller"
    
    bShowDebugLines=false
    
    bManageableBySolver=true
    bTargeted=false;
    bInteracting=false
}
