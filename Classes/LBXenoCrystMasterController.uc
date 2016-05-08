/**
 *  LBXenoCrystMasterController
 *
 *  Creation date: 01.05.2016 21:59
 *  Copyright 2016, Windows7
 */
class LBXenoCrystMasterController extends LBMechanism;

var(ParamSource) name ParameterSource; //A mechanism, from which we'll get all params via GetParamFloat
var(ParamSource) bool bUseParamSource; //Defines whether we should get params (from ParameterSource)

var(XenoCrystMasterSystem) name LEyeSocket;
var(XenoCrystMasterSystem) name REyeSocket;
var(XenoCrystMasterSystem) name TrueRayOriginSocket;
var(XenoCrystMasterSystem) float MaxRayLength; //The length of the ray. Warning! Can slow down the game!
var(XenoCrystMasterSystem) float MaxRayCount; //Max recursive depth. Warning! Can slow down the game!
var(XenoCrystMasterSystem) name CrystControllerMechName; //The name of the LBCrystController mechanism, which is attached to LBActors, which are used to reflect our beams
var(XenoCrystMasterSystem) bool bDisplayTraces; //When true - the debug lines are drawn
var(XenoCrystMasterGameplay) bool bActiveBeams; //When true - shooting the beams

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
 
function actor DrawBeam(vector origin, vector target, out vector hitloc, out vector hitnormal, optional bool bDrawTrace=false)
{
    local LBPawn p;
    local Actor hit;
    
    p=LBPawn(parent);
    if (parent==none)
    {
        LogError("proc: DrawBeam(), parent is not an LBPawn or none:" @parent);   
        return none;    
    }
    
    hit=p.Trace(hitloc, hitnormal, target, origin);
    
    if (bDrawTrace==false)
        return hit;
    
    if (hit!=none)
        p.DrawDebugLine(origin, hitloc, 0, 255, 128);
    else
        p.DrawDebugLine(origin, target, 0, 255, 128);
        
    return hit;
}

function DrawBeams()
{
    local LBPawn p;
    local Actor hit;
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
    
    hit=DrawBeam(l, l+d*(MaxRayLength+MaxRayLength*0.134), oh, on, false);
    
    if (p.Mesh.GetSocketWorldLocationAndRotation(LEyeSocket, l, r, 0)==false)
        LogError("proc: DrawBeams(), the mesh doesn't have a left eye socket!");  
    DrawBeam(l, oh, h, n, bDisplayTraces);
    if (p.Mesh.GetSocketWorldLocationAndRotation(REyeSocket, l, r, 0)==false)
        LogError("proc: DrawBeams(), the mesh doesn't have a right eye socket!");
    DrawBeam(l, oh, h, n, bDisplayTraces);
    
    for (i=0;i<MaxRayCount;i++)
    {
        //proceed only if we hit an LBActor with bReflectsBeams property set to ture (has a LBCrystController mechanism)
        if (LBActor(hit)!=none)
        {
            if (LBActor(hit).GetParamBool(CrystControllerMechName, 'bReflectsBeams')==true)
            {
                //if beams are active - fill the charge of the cryst
                if (bActiveBeams)
                    LBActor(hit).SetParamFloat(CrystControllerMechName, 'CrystCharge', 1);
                hit=DrawBeam(oh, oh+on*MaxRayLength, h, n, bDisplayTraces);
                oh=h;
                on=n;
            }
            else
                return;
        }
        else
            return;
    }
}
   
    
defaultproperties
{
    LEyeSocket="LeftEye"
    REyeSocket="RightEye"
    TrueRayOriginSocket="RayOrigin"
    CrystControllerMechName="CRYST_CONTROL"
    
    MaxRayLength=10240
    MaxRayCount=32
    
    bActiveBeams=false
    bDisplayTraces=false
}
