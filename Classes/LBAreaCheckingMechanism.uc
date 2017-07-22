/**
 *  LBAreaCheckingMechanism
 *
 *  Creation date: 13.12.2016 21:16
 *  Copyright 2016, Windows7
 */
class LBAreaCheckingMechanism extends LBVolumeCheckingMechanism;


var(VolumeCheckingMechanism) AreaTypes AreaType;

/*A radius of the trigger area, so it is a sphere*/
var(SphereArea) float CheckingSphereRadius;

/*An Extent for the trigger area, so it is a box*/
var(BoxArea) vector CheckingBoxExtent;

//event OwnerTick(float deltatime)
//{
//    super.OwnerTick(deltatime);
//        
//    if (bShowDebugLines)
//        DrawDebugLines();  
//} 
    
function bool CheckSphereArea(actor a)
{
    if (VSize(a.Location-TransformCoords(CheckingAreaCenter,CheckingAreaCoords)) <= CheckingSphereRadius)
        return true;
    else
        return false;    
}

function bool CheckBoxArea(actor a)
{
    if (a.Location.X >= TransformCoords(CheckingAreaCenter,CheckingAreaCoords).X-CheckingBoxExtent.X && a.Location.X <= TransformCoords(CheckingAreaCenter,CheckingAreaCoords).X+CheckingBoxExtent.X && 
        a.Location.Y >= TransformCoords(CheckingAreaCenter,CheckingAreaCoords).Y-CheckingBoxExtent.Y && a.Location.Y <= TransformCoords(CheckingAreaCenter,CheckingAreaCoords).Y+CheckingBoxExtent.Y && 
        a.Location.Z >= TransformCoords(CheckingAreaCenter,CheckingAreaCoords).Z-CheckingBoxExtent.Z && a.Location.Z <= TransformCoords(CheckingAreaCenter,CheckingAreaCoords).Z+CheckingBoxExtent.Z)
    {
        return true;
    }
    else
    {
        return false;
    }
}

function bool CustomActorCheck(actor a)
{
    if (AreaType == AreaTypes_Sphere) 
        return CheckSphereArea(a);
    else if (AreaType == AreaTypes_Box)
        return CheckBoxArea(a);
    else 
        return false;
}  
  
function vector GetObjectOffset(actor a)
{
    local vector v;

    v=TransformCoords(CheckingAreaCenter,CheckingAreaCoords);
    v=v-a.Location;
    v.X=v.X/(CheckingBoxExtent.X);
    v.Y=v.Y/(CheckingBoxExtent.Y);
    v.Z=v.Z/(CheckingBoxExtent.Z);
    //v=Normal(v);

    return v;    
} 
 
function DGHighlightArea()
{
    local vector v;
    
    if (bShowDebugGraphics)
    {
        if (AreaType == AreaTypes_Sphere) 
        {
            v=TransformCoords(CheckingAreaCenter,CheckingAreaCoords);
            parent.DrawDebugSphere(v,CheckingSphereRadius,12,AreaHighlightColor.R,AreaHighlightColor.G,AreaHighlightColor.B);  
        }
        else if (AreaType == AreaTypes_Box)
        {
            v=TransformCoords(CheckingAreaCenter,CheckingAreaCoords);
            parent.DrawDebugBox(v,CheckingBoxExtent,AreaHighlightColor.R,AreaHighlightColor.G,AreaHighlightColor.B);  
        }
    }
}

function vector GetParamVector(name param)
{
    if (param=='OffsetOfNearestObject' || param=='OffsetOfNearest' || param=='OffsOfNearest')
    {
        return GetObjectOffset(GetNearestObject());
    } 
    else
    {
        return super.GetParamVector(param);
    }  
}
    
defaultproperties
{
    mechname="Area_Checking_Mechanism" 
}
