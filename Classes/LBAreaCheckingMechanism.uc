/**
 *  LBAreaCheckingMechanism
 *
 *  Creation date: 13.12.2016 21:16
 *  Copyright 2016, Windows7
 */
class LBAreaCheckingMechanism extends LBMechanism;

var(LocationTriggerMechanismSystem) vector CheckingAreaCenter; //A center of a trigger area (a sphere)
var(LocationTriggerMechanismSystem) bool bUseLocalCoords; 
var(LocationTriggerMechanismSystem) float CheckingAreaRadius; //A radius of the trigger area

var(MechanismDebug) bool bShowDebugLines;

event OwnerTick(float deltatime)
{
    super.OwnerTick(deltatime);
        
    if (bShowDebugLines)
        DrawDebugLines();  
} 
    
function bool AreaHasObjects()
{
    local lbactor a;
    local bool b;
    
    b=false;
    
    foreach parent.DynamicActors(class 'LBActor', a)
    {
        if (CheckActor(a))
            return true;  
    } 
     
    return b;   
}

function actor GetNearestObject()
{
    local lbactor a;
    local float d;
    local array<actor> actors;
    local array<float> dists;
    
    local int i;
    local int minid;
    
    foreach parent.DynamicActors(class 'LBActor', a)
    {
        if (CheckActor(a))
        {
            actors.AddItem(a);
            d=GetObjectDistance(a);
            dists.AddItem(d);
        }  
    } 
    
    if (actors.Length != 0)
    {
        minid=0;
        
        for (i=0;i<actors.Length;i++)
        {
            if (dists[i] < dists[minid])
                minid=i;    
        } 
            
        return actors[minid];   
    }
    else
        return none;       
}

function float GetObjectDistance(actor a)
{
    local vector v;
    local vector X, Y, Z;
    local float l;

    if (bUseLocalCoords)
    {
        GetAxes(parent.Rotation,X,Y,Z);
        v=parent.Location+X*CheckingAreaCenter.X+Y*CheckingAreaCenter.Y+Z*CheckingAreaCenter.Z;
    }
    else
    {
        v=parent.Location+CheckingAreaCenter;   
    }    
    
    l=VSize(a.Location-v);

    return l;    
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
        v=parent.Location+X*CheckingAreaCenter.X+Y*CheckingAreaCenter.Y+Z*CheckingAreaCenter.Z;
    }
    else
    {
        v=parent.Location+CheckingAreaCenter;   
    }    
    
    l=VSize(a.Location-v);  
    
    if (l <= CheckingAreaRadius)
        return true;
    else 
        return false;     
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
            v=parent.Location+X*CheckingAreaCenter.X+Y*CheckingAreaCenter.Y+Z*CheckingAreaCenter.Z;
            parent.DrawDebugSphere(v,CheckingAreaRadius,16,0,128,128);     
        }
        else
        {
            v=parent.Location+CheckingAreaCenter;
            parent.DrawDebugSphere(v,CheckingAreaRadius,16,0,128,128);         
        }  
    }
}

function object GetParam(name param)
{
    if (param=='NearestObject')
    {
        return GetNearestObject();
    }   
}

function bool GetParamBool(name param)
{
    if (param=='AreaHasObjects')
    {
        return AreaHasObjects();
    } 
}

defaultproperties
{
    mechname="Area_Checking_Mechanism"
    
    MechanismParams(0)=(ParamName="AreaHasObjects", ParamInfo="Boolean. Read. Checks whether defined area has any objects, returns true if there are any.")
    MechanismParams(1)=(ParamName="NearestObject", ParamInfo="Object (Actor). Read. Gets the nearest to the center of the area object, returns none if there aren't any.") 
}
