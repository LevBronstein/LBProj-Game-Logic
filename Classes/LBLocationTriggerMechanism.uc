/**
 *  LBLocationTriggerMechanism
 *
 *  Creation date: 13.12.2016 19:58
 *  Copyright 2016, Windows7
 */
class LBLocationTriggerMechanism extends LBKismetEventActivator;

var(LocationTriggerMechanismSystem) vector TriggerAreaCenter; //A center of a trigger area (a sphere)
var(LocationTriggerMechanismSystem) bool bUseLocalCoords; 
var(LocationTriggerMechanismSystem) float TriggerAreaRadius; //A radius of the trigger area

var(MechanismDebug) bool bShowDebugLines;

var(LocationTriggerMechanismGameplay) actor CheckingObject;

event OwnerTick(float deltatime)
{
    super.OwnerTick(deltatime);
        
    if (bShowDebugLines)
        DrawDebugLines();  
} 

function bool CheckActor(actor a)
{
    local vector v;
    local vector X, Y, Z;
    local float l;
    
    if (a==none)
        return false;
    
    if (bUseLocalCoords)
    {
        GetAxes(parent.Rotation,X,Y,Z);
        v=parent.Location+X*TriggerAreaCenter.X+Y*TriggerAreaCenter.Y+Z*TriggerAreaCenter.Z;
    }
    else
    {
        v=parent.Location+TriggerAreaCenter;   
    }    
    
    l=VSize(a.Location-v);  
    
    if (l <= TriggerAreaRadius)
        return true;
    else 
        return false;     
}
  
function bool CheckConditions()
{
    local bool b;
    
    b=CheckActor(CheckingObject);
    
    if (bLogFullInfo)
    {
        if (b)
            LogInfo("Object"@CheckingObject@"is INSIDE the area ("$TriggerAreaCenter$") with radius"$TriggerAreaRadius);
        else
            LogInfo("Object"@CheckingObject@"is OUTSIDE of the area ("$TriggerAreaCenter$") with radius"$TriggerAreaRadius);
    } 
      
    return b;  
}  
    

function DrawDebugLines()
{
    local vector v;
    local vector X, Y, Z;
    
    if (bShowDebugLines)
    {
        if (bUseLocalCoords)
        {
            GetAxes(parent.Rotation,X,Y,Z);
            v=parent.Location+X*TriggerAreaCenter.X+Y*TriggerAreaCenter.Y+Z*TriggerAreaCenter.Z;
            parent.DrawDebugSphere(v,TriggerAreaRadius,16,0,128,128);     
        }
        else
        {
            v=parent.Location+TriggerAreaCenter;
            parent.DrawDebugSphere(v,TriggerAreaRadius,16,0,128,128);         
        }  
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
    
    bUseLocalCoords=true
}
