/**
 *  LBLocationTriggerMechanism
 *
 *  Creation date: 13.12.2016 19:58
 *  Copyright 2016, Windows7
 */
class LBLocationTriggerMechanism extends LBTriggerMechanism;

var(LocationTrigger) vector TriggerAreaCenter; //A center of a trigger area (a sphere) 
var(LocationTrigger) float TriggerAreaRadius; //A radius of the trigger area

var(LocationTrigger) bool bCheckParent;
var(LocationTrigger) actor CheckingObject;

var(MechanismDebug) bool bShowDebugLines;

event OwnerTick(float deltatime)
{
    //super.OwnerTick(deltatime);
    
    PerformTick();
    
    if (bShowDebugLines)
        DrawDebugLines();  
} 

function PerformTick()
{
    if (CheckConditions())
        SetTrigger();
    else 
        SetUnTrigger();
}  
   
function bool CheckActor(actor a)
{
    local float l;
    
    if (a==none)
        return false;
        
    l=VSize(a.Location-TriggerAreaCenter);  
    
    if (l <= TriggerAreaRadius)
        return true;
    else 
        return false;     
}
  
function bool CheckConditions()
{
    local bool b;
    
    if (bCheckParent)
    {
        b=CheckActor(parent);
    }
    else
    {
        b=CheckActor(CheckingObject);   
    }
      
    return b;  
}  

function OnChangedTriggerState(bool bnewstate)
{
    if (bnewstate)
    {
        LogInfo("The checking actor is INSIDE the area ("$TriggerAreaCenter$") with radius "@TriggerAreaRadius);
        ActivateKismetEvent(OnTriggerEventName,parent,parent.WorldInfo);    
    } 
    else
    {
        LogInfo("The checking actor is OUTSIDE the area ("$TriggerAreaCenter$") with radius "@TriggerAreaRadius);
        ActivateKismetEvent(OnUnTriggerEventName,parent,parent.WorldInfo);    
    }   
}    

function DrawDebugLines()
{
    local vector v;
    local vector X, Y, Z;
    
    if (bShowDebugLines)
    {
        parent.DrawDebugSphere(TriggerAreaCenter,TriggerAreaRadius,16,0,128,128);          
    }
}

function SetParam(name param, object value, optional int priority=0)
{
    if (param=='CheckingObject')
        CheckingObject=actor(value);  
} 
    
function bool GetParamBool(name param)
{
    if (param=='IsCheckingObjectInArea')
    {
        return CheckActor(CheckingObject);
    } 
}

defaultproperties
{
    mechname="Location_Trigger_Mechanism"
    
    bCheckParent=true
}
