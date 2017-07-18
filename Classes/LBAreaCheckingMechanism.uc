/**
 *  LBAreaCheckingMechanism
 *
 *  Creation date: 13.12.2016 21:16
 *  Copyright 2016, Windows7
 */
class LBAreaCheckingMechanism extends LBVolumeCheckingMechanism;

/*A radius of the trigger area, so it is a sphere*/
var(VolumeCheckingMechanism) float CheckingAreaRadius;

//event OwnerTick(float deltatime)
//{
//    super.OwnerTick(deltatime);
//        
//    if (bShowDebugLines)
//        DrawDebugLines();  
//} 
    
function bool CustomActorCheck(actor a)
{
    if (VSize(a.Location-TransformCoords(CheckingAreaCenter,CheckingAreaCoords)) <= CheckingAreaRadius)
        return true;
    else
        return false;
}    
 
function DGHighlightArea()
{
    local vector v;
    
    if (bShowDebugGraphics)
    {
        v=TransformCoords(CheckingAreaCenter,CheckingAreaCoords);
        parent.DrawDebugSphere(v,CheckingAreaRadius,12,AreaHighlightColor.R,AreaHighlightColor.G,AreaHighlightColor.B);  
    }
}
    
defaultproperties
{
    mechname="Area_Checking_Mechanism" 
}
