/**
 *  LBTraceCheckingMechanism
 *
 *  Creation date: 18.07.2017 01:08
 *  Copyright 2017, Win10
 */
class LBTraceCheckingMechanism extends LBGeomActorCheckingMechanism;

struct TraceInfo
{
    var Actor hitactor;
    var ActorComponent hitcomponent;
    var Vector hitloc;
    var Vector hitnormal;
};

enum TraceOriginModes
{
    TraceOriginModes_Default,
    TraceOriginModes_PawnSocket,
    TraceOriginModes_LocationRotation,
    TraceOriginModes_PredefinedOrigin, //Use @PredefLoc and @PredefRot
};


var(TraceCheckingMechanismSystem) TraceOriginModes TraceOriginMode;
var(TraceCheckingMechanismSystem) name RayTraceOriginSocket; //A socket in skeletal mesh of the owner, which should be used as a start of ray traces
var(TraceCheckingMechanismSystem) float MaxTraceLength;
var(TraceCheckingMechanismSystem) bool bTraceExtent;
var(TraceCheckingMechanismSystem) vector RayTraceExtent;

var(PredefinedOrigin) vector PredefLoc;
var(PredefinedOrigin) rotator PredefRot;
var(PredefinedOrigin) CoordinateTypes PredefLocCoords;

function bool CheckActor(actor a)
{
    return true;
}

function TraceInfo TraceRay(vector origin, vector target)
{
    local TraceInfo hit;
    
    hit.hitactor=parent.Trace(hit.hitloc, hit.hitnormal, target, origin);

    if (bShowDebugGraphics)
    {
        if (TargetIsLBObject(hit.hitactor))
            parent.DrawDebugLine(origin, hit.hitloc, 255, 0, 0);
        else if (hit.hitactor!=none)
            parent.DrawDebugLine(origin, hit.hitloc, 0, 255, 0);   
        else 
            parent.DrawDebugLine(origin, target, 0, 0, 255);     
    }

    return hit;
}

function TraceInfo TraceRayExtent(vector origin, vector target, vector extent)
{
    local TraceInfo hit;
    
    hit.hitactor=parent.Trace(hit.hitloc, hit.hitnormal, target, origin, ,extent);

    if (bShowDebugGraphics)
    {
        if (TargetIsLBObject(hit.hitactor))
        {
            parent.DrawDebugLine(origin, hit.hitloc, 255, 0, 0);
            parent.DrawDebugLine(origin+extent, hit.hitloc+extent, 255, 0, 0);
            parent.DrawDebugLine(origin-extent, hit.hitloc-extent, 255, 0, 0);
        }
        else if (hit.hitactor!=none)
        {
            parent.DrawDebugLine(origin, hit.hitloc, 0, 255, 0);  
            parent.DrawDebugLine(origin+extent, hit.hitloc+extent, 0, 255, 0);  
            parent.DrawDebugLine(origin-extent, hit.hitloc-extent, 0, 255, 0);
        }
        else 
        {
            parent.DrawDebugLine(origin, target, 0, 0, 255);  
            parent.DrawDebugLine(origin+extent, target+extent, 0, 0, 255);
            parent.DrawDebugLine(origin-extent, target-extent, 0, 0, 255);
        }
    }
    
    return hit;
}

function array<actor> GetActorsMatchingTrue()
{
    local array<actor> arr;
    
    local LBPawn p;
    local vector l, d; 
    local rotator r;
    local TraceInfo hit;

    p=LBPawn(parent);
    
    if (p!=none && TraceOriginMode==TraceOriginModes_PawnSocket)
    {
        if (p.Mesh.GetSocketWorldLocationAndRotation(RayTraceOriginSocket, l, r, 0)!=false)
        {
            d=vect(0,0,1)>>r;
            d=Normal(d);    
        }    
    }
    else if (TraceOriginMode==TraceOriginModes_PredefinedOrigin)
    {
        l=TransformCoords(PredefLoc,PredefLocCoords);
        r=PredefRot;
        d=vect(0,0,1)>>r;
        d=Normal(d);     
    }
    else
    {
        l=parent.Location;
        d=vect(0,0,1)>>parent.Rotation;
        d=Normal(d);      
    }

    if (bTraceExtent)
        hit=TraceRayExtent(l, l+d*MaxTraceLength,RayTraceExtent);
    else    
        hit=TraceRay(l, l+d*MaxTraceLength);
    
    if (hit.hitactor!=none)
        arr.AddItem(hit.hitactor);
        
    //А если в себя попадёт?
    return arr;
}

function object GetFirstTracedObject()
{
    local array<actor> arr;
    local actor a;

    arr=GetActorsMatchingTrue();  
    
    if (arr.Length>0)
        a=arr[0];
        
    return a;  
}

function array<actor> GetActorsMatchingFalse()
{
    local array<actor> arr;
    
    return arr;
}

function object GetParam(name param)
{
    if (param=='FirstTracedObject' || param=='FirstTracedObj' || param=='GetFirstTracedObject')
    {
        return GetFirstTracedObject();
    }  
    else
    return super.GetParam(param); 
}

defaultproperties
{
    mechname="Trace_Checking_Mechanism"
    
    RayTraceOriginSocket="TraceOriginSocket"
    MaxTraceLength=1024
    
    MechanismParams.Add((ParamName="FirstTracedObject", ParamType=ParamType_Object, ParamInfo="Object (Actor). Read. Gets the first object hit by the tracing ray."))
}
