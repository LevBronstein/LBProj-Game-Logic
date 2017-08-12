/**
 *  LBMultiTraceCheckingMechanism
 *
 *  Creation date: 27.07.2017 23:13
 *  Copyright 2017, Win10
 */
class LBMultiTraceCheckingMechanism extends LBTraceCheckingMechanism;

struct AuxiliaryTrace
{
    var() TraceOriginModes TraceOriginMode;
    var() name RayTraceOriginSocket; //A socket in skeletal mesh of the owner, which should be used as a start of ray traces
    var() float TraceStartOffset;
    var() float MaxTraceLength; 
    var() vector PredefLoc;
    var() rotator PredefRot;
    var() CoordinateTypes PredefLocCoords;   
};

var(AuxiliaryTraces) array<AuxiliaryTrace> AuxiliaryTraceList;

function array<actor> GetActorsMatchingTrue()
{
    local array<actor> maintrace;
    local array<TraceInfo> auxtrace;
    
    local TraceOrigin origin;
    local TraceInfo hit;
     
    local int i;
    
    local vector dist;
    local float mindist;
    
    maintrace=super.GetActorsMatchingTrue();
    
    if (maintrace.Length!=0)
    {
        return maintrace; 
    }
    
    for (i=0;i<AuxiliaryTraceList.Length;i++)
    {
        origin=GetTraceOrigin(AuxiliaryTraceList[i].TraceOriginMode,AuxiliaryTraceList[i].PredefLoc,AuxiliaryTraceList[i].PredefRot,AuxiliaryTraceList[i].PredefLocCoords);  
        
        hit=TraceRay(origin.origloc+origin.origdir*AuxiliaryTraceList[i].TraceStartOffset, origin.origloc+origin.origdir*AuxiliaryTraceList[i].MaxTraceLength);    
      
        if (hit.hitactor!=none)
            auxtrace.AddItem(hit);  
    } 
    
    if (auxtrace.Length==0)
        return maintrace;
        
    origin=GetTraceOrigin(TraceOriginMode,PredefLoc,PredefRot,PredefLocCoords);  
   
    mindist=VSize(auxtrace[0].hitloc-origin.origloc);  
    
    for (i=0;i<auxtrace.Length;i++)
    {  
        dist=auxtrace[i].hitloc-origin.origloc;
        
        if (VSize(dist)<=mindist)
        {
            mindist=VSize(dist);  
            hit=auxtrace[i];  
        }      
    } 
    
    maintrace.AddItem(hit.hitactor);
    
    return maintrace;
}

defaultproperties
{
}
