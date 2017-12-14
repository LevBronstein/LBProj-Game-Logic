/**
 *  LBTraceCheckingMechanism
 *
 *  Creation date: 18.07.2017 01:08
 *  Copyright 2017, Win10
 */
class LBTraceCheckingMechanism extends LBGeomActorCheckingMechanism;

struct TraceOrigin
{
    var vector origloc;
    var vector origdir;
};

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
    TraceOriginModes_MeshSocket,
    TraceOriginModes_LocationRotation,
    TraceOriginModes_PredefinedOrigin, //Use @PredefLoc and @PredefRot
};


var(TraceCheckingMechanismSystem) TraceOriginModes TraceOriginMode;
var(TraceCheckingMechanismSystem) name RayTraceOriginSocket; //A socket in skeletal mesh of the owner, which should be used as a start of ray traces
var(TraceCheckingMechanismSystem) float TraceStartOffset;
var(TraceCheckingMechanismSystem) float MaxTraceLength;

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
    local actor a;
    local vector hitloc;
    local vector hitnormal;
    local vector dist;
    
    local float mindist;
    
    mindist=MaxTraceLength;
    hit.hitloc=target;

    foreach parent.TraceActors(class'Actor',a,hitloc,hitnormal,target,origin)
    {
        dist=hitloc-origin;
        
        if (CheckActorValidity(a))
        {
            if (VSize(dist)<=mindist)
            {
                if (a!=parent || (a==parent && bIncludeParent))
                {
                    mindist=VSize(dist);
                    hit.hitactor=a;
                    hit.hitloc=hitloc;
                    hit.hitnormal=hitnormal;
                }
            }
        }
    }
    
    a=parent.Trace(hitloc, hitnormal, target, origin);
    
    if (bShowDebugGraphics)
    {
        parent.DrawDebugSphere(origin,1,8,128,0,0);
        
        if (TargetIsLBObject(hit.hitactor))
            parent.DrawDebugLine(origin, hit.hitloc, 255, 0, 0);
        else if (hit.hitactor!=none || a!=none)
            parent.DrawDebugLine(origin, hitloc, 0, 255, 0);   
        else 
            parent.DrawDebugLine(origin, target, 0, 0, 255);     
    } 

    return hit;
}

//function TraceInfo TraceRaySimple(vector origin, vector target)
//{
//    local TraceInfo hit;
//    
//    hit.hitactor=parent.Trace(hit.hitloc, hit.hitnormal, target, origin);   
//    
//    if (!CheckActorValidity(hit.hitactor) || (hit.hitactor==parent && !bIncludeParent))
//    {
//        hit.hitactor=none;
//        hit.hitloc=target;       
//    }
//    
//    if (bShowDebugGraphics)
//    {
//        if (TargetIsLBObject(hit.hitactor))
//            parent.DrawDebugLine(origin, hit.hitloc, 255, 0, 0);
//        else if (hit.hitactor!=none)
//            parent.DrawDebugLine(origin, hit.hitloc, 0, 255, 0);   
//        else 
//            parent.DrawDebugLine(origin, target, 0, 0, 255);     
//    } 
//
//    return hit;
//}

function TraceOrigin GetTraceOrigin(TraceOriginModes originmode, optional vector pLoc, optional rotator pRot, optional CoordinateTypes pCoord)
{
    local TraceOrigin origin;
    local LBPawn p;
    local vector l, d; 
    local rotator r;
    
    //p=LBPawn(parent);
    
    if (originmode==TraceOriginModes_MeshSocket)
    {
        if (GetParentSocket(RayTraceOriginSocket, l, r, 0)!=false)
        {
            //origin.origdir=vect(0,0,1)>>r;
            origin.origloc=l;
            origin.origdir=vector(r);
            //d=Normal(d);    
        }    
    }
    else if (originmode==TraceOriginModes_PredefinedOrigin)
    {
        origin.origloc=TransformCoords(pLoc,pCoord);
        origin.origdir=vector(GetParentRotation()+pRot);
        //d=Normal(d);     
    }
    else
    {
        origin.origloc=GetParentLocation();
        origin.origdir=vector(GetParentRotation());   
        // `log(parent@GetParentLocation()@GetParentRotation()*unrrottodeg);
    }
    
    return origin;
}

function array<actor> GetActorsMatchingTrue()
{
    local array<actor> arr;
    
    local TraceOrigin origin;
    
    local LBPawn p;
    local vector l, d; 
    local rotator r;
    local TraceInfo hit;

    //p=LBPawn(parent);
    //
    //if (p!=none && TraceOriginMode==TraceOriginModes_PawnSocket)
    //{
    //    if (p.Mesh.GetSocketWorldLocationAndRotation(RayTraceOriginSocket, l, r, 0)!=false)
    //    {
    //        d=vect(0,0,1)>>r;
    //        d=Normal(d);    
    //    }    
    //}
    //else if (TraceOriginMode==TraceOriginModes_PredefinedOrigin)
    //{
    //    l=TransformCoords(PredefLoc,PredefLocCoords);
    //    r=PredefRot;
    //    d=vect(1,0,0)>>parent.rotation+r;
    //    d=Normal(d);     
    //}
    //else
    //{
    //    l=parent.Location;
    //    d=vect(1,0,0)>>parent.Rotation;
    //    d=Normal(d);      
    //}

    origin=GetTraceOrigin(TraceOriginMode,PredefLoc,PredefRot,PredefLocCoords);
    
    hit=TraceRay(origin.origloc+origin.origdir*TraceStartOffset, origin.origloc+origin.origdir*MaxTraceLength);
    
    if (hit.hitactor!=none)
        arr.AddItem(hit.hitactor);

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
