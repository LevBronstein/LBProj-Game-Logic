/**
 *  LBXenoCrystMasterController
 *
 *  Creation date: 01.05.2016 21:59
 *  Copyright 2016, Windows7
 */
class LBXenoCrystMasterController extends LBMechanism;

var(ParamSource) name ParameterSource; //A mechanism, from which we'll get all params via GetParamFloat
var(ParamSource) bool bUseParamSource; //Defines whether we should get params (from ParameterSource)

var(XenoCrystMaster) name LEyeSocket;
var(XenoCrystMaster) name REyeSocket;
var(XenoCrystMaster) name TrueRayOriginSocket;
var(XenoCrystMaster) float MaxRayLength; //The length of the ray. Warning! Can slow down the game!
 
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
    
    if (bUseParamSource)
        GetParameters();
        
    DrawBeams(); 
}   
   
function GetParameters()
{
    if (LBPawn(parent)!=none)
    {
        
    }
    else
    {
        LogError("proc: GetParameters(), parent is not an LBPawn or none:" @parent);
    }
}
 
function DrawBeams()
{
    local LBPawn p;
    local vector l, d; 
    local rotator r;
    local vector h, n;
    local vector oh, on;
    local int i;

    p=LBPawn(parent);
    if (parent==none)
    {
        LogError("proc: DrawBeams(), parent is not an LBPawn or none:" @parent);   
        return;    
    }
    
    //ray direction
    if (p.Mesh.GetSocketWorldLocationAndRotation(TrueRayOriginSocket, l, r, 0)==false)
        LogError("proc: DrawBeams(), the mesh doesn't have a ray origin socket!");    
    d=vect(0,0,1)>>r;
    d=Normal(d);
    
    if (p.Trace(oh, on, l+d*(MaxRayLength+MaxRayLength*0.134), l)==none)
    {
        //if hits nothing - return right here
        p.Mesh.GetSocketWorldLocationAndRotation(LEyeSocket, l, r, 0);
        d=vect(0,0,1)>>r;
        p.DrawDebugLine(l, l+d*MaxRayLength, 0, 255, 128);
        p.Mesh.GetSocketWorldLocationAndRotation(REyeSocket, l, r, 0);
        d=vect(0,0,1)>>r;
        p.DrawDebugLine(l, l+d*MaxRayLength, 0, 255, 128);
        return;
    }
    
    p.Mesh.GetSocketWorldLocationAndRotation(LEyeSocket, l, r, 0);
    p.DrawDebugLine(l, oh, 0, 255, 128);
    p.Mesh.GetSocketWorldLocationAndRotation(REyeSocket, l, r, 0);
    p.DrawDebugLine(l, oh, 0, 255, 128);
    
    for (i=0;i<4; i++)
    {
        if (p.Trace(h, n, oh+on*MaxRayLength, oh)!=none)
        {
            p.DrawDebugLine(oh, h, 0, 255, 128);  
            oh=h;
            on=n;
        }
        else
        {
            p.DrawDebugLine(oh, oh+on*MaxRayLength, 0, 255, 128); 
            break;
        }
    }
}
   
    
defaultproperties
{
    LEyeSocket="LeftEye"
    REyeSocket="RightEye"
    TrueRayOriginSocket="RayOrigin"
    
    MaxRayLength=10240
}
