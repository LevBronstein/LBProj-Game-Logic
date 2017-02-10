/**
 *  LBLocationTriggerMechanism
 *
 *  Creation date: 13.12.2016 19:58
 *  Copyright 2016, Windows7
 */
class LBLocationTriggerMechanism extends LBActorTriggerMechanism;

/*A center of a trigger area (a sphere). Objects, that intersect
with this sphere pass the condition test*/
var(LocationTrigger) vector TriggerAreaCenter;
/*If the center pont shoul be used as an offset from 
parent's coordinates. Use with caution, when @bIncludeParent is TRUE!*/
var(LocationTrigger) bool bLocalCoords;
/*A radius of the trigger area (a radius of the shpere)*/
var(LocationTrigger) float TriggerAreaRadius;

/*Display debug info in game*/
var(MechanismDebug) bool bShowDebugLines;

//event OwnerTick(float deltatime)
//{
//    if(benabled==false)
//        return;
//
//    PerformTick(deltatime);           
//}

//event OwnerTick(float deltatime)
//{
//    if(benabled==false)
//        return;
//
//    PerformTick(deltatime);
//    
//    if (bShowDebugLines)
//        DrawDebugLines();  
//
//    `log(mechname@"Checking actors:"@CheckingActors.Length);    
//}

function PerformTick(float dt)
{
    super.PerformTick(dt);
    
    if (bShowDebugLines)
        DrawDebugLines(); 
}

function bool CheckActor(actor a)
{
    local float l;
    local vector loc;
    
    if (a==none)
        return false;
    
    if (bLocalCoords)
        loc=parent.Location+TriggerAreaCenter;
    else
        loc=TriggerAreaCenter;    
        
    l=VSize(a.Location-loc);  
    
    if (l <= TriggerAreaRadius)
        return true;
    else 
        return false;     
}
  
//function bool CheckConditions()
//{
//    local bool b;
//    
//    if (bCheckParent)
//    {
//        b=CheckActor(parent);
//    }
//    else
//    {
//        b=CheckActor(CheckingObject);   
//    }
//      
//    return b;  
//}  

//function OnChangedTriggerState(bool bnewstate)
//{
//    if (bnewstate)
//    {
//        LogInfo("The checking actor is INSIDE the area ("$TriggerAreaCenter$") with radius "@TriggerAreaRadius);
//        //ActivateKismetEvent(OnTriggerEventName,parent,parent.WorldInfo);    
//    } 
//    else
//    {
//        LogInfo("The checking actor is OUTSIDE the area ("$TriggerAreaCenter$") with radius "@TriggerAreaRadius);
//        //ActivateKismetEvent(OnUnTriggerEventName,parent,parent.WorldInfo);    
//    }  
//   
//   super.OnChangedTriggerState(bnewstate); 
//}    

function DrawDebugLines()
{
    local vector v;
    //local vector X, Y, Z;
    
    if (bLocalCoords)
        v=parent.Location+TriggerAreaCenter;
    else
        v=TriggerAreaCenter;
    
    if (bShowDebugLines)
    {
        parent.DrawDebugSphere(v,TriggerAreaRadius,16,0,128,128);          
    }
}

    
function bool GetParamBool(name param)
{
    super.GetParamBool(param);
    
    if (param=='bHasActorInTriggerArea' || param=='HasActorInTriggerArea' ||
    param=='bHasTriggeredActor' || param=='HasTriggeredActor')
    {
        return TriggerState;
    } 
}

defaultproperties
{
    mechname="Location_Trigger_Mechanism"
    
    bCheckParent=true
}
