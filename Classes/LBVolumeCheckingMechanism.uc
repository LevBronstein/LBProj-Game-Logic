/**
 *  LBVolumeCheckingMechanism
 *
 *  Creation date: 10.02.2017 19:41
 *  Copyright 2017, Windows7
 */
class LBVolumeCheckingMechanism extends LBGeomActorCheckingMechanism;

/*A center of the checking area*/
var(VolumeCheckingMechanism) vector CheckingAreaCenter;
/*Affects @CheckingArea and other coordinate-related properties of
the checking area*/
var(VolumeCheckingMechanism) CoordinateTypes CheckingAreaCoords;
/*The tolerable error in float value calculations. WARNING: Use with caution!*/
var(VolumeCheckingMechanism) float dError;

var(MechanismDebug) Color AreaHighlightColor;

//event OwnerTick(float deltatime)
//{
//    super.OwnerTick(deltatime);
//        
//    if (bShowDebugLines)
//        DrawDebugLines();  
//} 

function PerfromTick(float dt)
{   
    super.PerfromTick(dt);
    
    DGHighlightArea();
}

function GetCheckingActors()
{
    local Actor a;
    
    CheckingActors.Length=0;
    
    foreach parent.DynamicActors(class 'Actor', a)
    {
        if (a!=parent)
            CheckingActors.AddItem(a);
    } 
}
   
function bool CustomActorCheck(actor a)
{
    if (a!=none && VSize(a.Location-TransformCoords(CheckingAreaCenter,CheckingAreaCoords)) <= dError)
        return true;
    else
        return false;
}

function bool AreaHasObjects()
{
    local Actor a;
    
    foreach parent.DynamicActors(class 'Actor', a)
    {
        if (CheckActor(a))
            return true;  
    } 
     
    return false;   
}

function actor GetNearestObject()
{
    local Actor a;
    local array<actor> actors;
    local array<float> dists;
    
    local int i;
    local int minid;
    local float d;
    
    actors=GetActorsMatchingTrue();
    
    if (actors.Length != 0)
    {
        minid=0;
        d=GetObjectDistance(actors[0]);
        
        for (i=0;i<actors.Length;i++)
        {
            if (GetObjectDistance(actors[i]) < d)
            {
                d=GetObjectDistance(actors[i]);
                minid=i;    
            }
        } 
                    
        return actors[minid];   
    }
    else
    {
        return none;       
    }
}
    
//function array<actor> GetAllObjectsInArea()
//{
//    local Actor a;
//    local array<actor> actors;
//    
//    foreach parent.DynamicActors(class 'Actor', a)
//    {
//        if (CheckActor(a))
//        {
//            actors.AddItem(a);
//        }  
//    } 
//
//    return actors;     
//}

function float GetObjectDistance(actor a)
{
    local vector v;
    local vector X, Y, Z;
    local float l;

    v=TransformCoords(CheckingAreaCenter,CheckingAreaCoords);
    
    l=VSize(a.Location-v);

    return l;    
}

function DGHighlightArea()
{
    local vector v;
    
    if (bShowDebugGraphics)
    {
        v=TransformCoords(CheckingAreaCenter,CheckingAreaCoords);
        parent.DrawDebugBox(v,vect(32,32,32),AreaHighlightColor.R,AreaHighlightColor.G,AreaHighlightColor.B);  
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

function float GetParamFloat(name param)
{
    if (param=='DistanceToNearestObject' || param=='DistanceToNearest' || param=='DistToNearest')
    {
        return GetObjectDistance(GetNearestObject());
    }   
}

function array<object> GetParams(name param)
{
    if (param=='AllObjectsInArea')
    {
        return GetActorsMatchingTrue();
    } 
}


defaultproperties
{
    mechname="Volume_Checking_Mechanism"
    
    bCheckAllActors=true
    
    AreaHighlightColor=(B=32,G=64,R=64)
    
    MechanismParams.Add((ParamName="AreaHasObjects", ParamType=ParamType_Boolean, ParamInfo="Boolean. Read. Checks whether defined area has any objects, returns true if there are any."))
    MechanismParams.Add((ParamName="NearestObject", ParamType=ParamType_Object, ParamInfo="Object (Actor). Read. Gets the nearest to the center of the area object, returns none if there aren't any."))
    MechanismParams.Add((ParamName="AllObjectsInArea", ParamType=ParamType_ObjectArray, ParamInfo="Object Array. Read. Gets a list of objects within the area, returns empty list if there aren't any."))
    MechanismParams.Add((ParamName="DistanceToNearestObject",ParamType=ParamType_Float, ParamInfo="Float. Read. Gets distance to the object, which is the nearest to the center of the area."))
}