/**
 *  LBSkeletalMeshControlMechanism
 *
 *  Creation date: 11.03.2017 18:03
 *  Copyright 2017, Windows7
 */
class LBSkeletalMeshControlMechanism extends LBUnCoreHandleMechanism;

enum RotatorAxis
{
    RotatorAxis_Yaw,
    RotatorAxis_Pitch,
    RotatorAxis_Roll,
};

struct RotatorResolver
{
    var() RotatorAxis GetYawFrom;
    var() bool bInvertYaw;
    var() RotatorAxis GetPitchFrom;
    var() bool bInvertPitch;
    var() RotatorAxis GetRollFrom;
    var() bool bInvertRoll;
};

function PerfromTick(float dt)
{
    super.PerfromTick(dt);
}

function RotatorResolver RotResolver(RotatorAxis Yaw, RotatorAxis Pitch, RotatorAxis Roll, optional bool bInvYaw=false, optional bool bInvPitch=false, optional bool bInvRoll=false)
{
    local RotatorResolver r;
    
    r.GetYawFrom=Yaw;
    r.GetPitchFrom=Pitch;
    r.GetRollFrom=Roll;
    r.bInvertYaw=bInvYaw;
    r.bInvertPitch=bInvPitch;
    r.bInvertRoll=bInvRoll;
    
    return r;
}

function RotatorResolver RevertResolver(RotatorResolver resolver)
{
    local RotatorResolver r;
    
    if (resolver.GetYawFrom == RotatorAxis_Yaw)
        r.GetYawFrom=RotatorAxis_Yaw;
    else if (resolver.GetYawFrom == RotatorAxis_Pitch)
        r.GetPitchFrom=RotatorAxis_Yaw;
    else if (resolver.GetYawFrom == RotatorAxis_Roll)
        r.GetRollFrom=RotatorAxis_Yaw;
        
    if (resolver.GetPitchFrom == RotatorAxis_Yaw)
        r.GetYawFrom=RotatorAxis_Pitch;
    else if (resolver.GetPitchFrom == RotatorAxis_Pitch)
        r.GetPitchFrom=RotatorAxis_Pitch;
    else if (resolver.GetPitchFrom == RotatorAxis_Roll)
        r.GetRollFrom=RotatorAxis_Pitch;    
        
    if (resolver.GetRollFrom == RotatorAxis_Yaw)
        r.GetYawFrom=RotatorAxis_Roll;
    else if (resolver.GetRollFrom == RotatorAxis_Pitch)
        r.GetPitchFrom=RotatorAxis_Roll;
    else if (resolver.GetRollFrom == RotatorAxis_Roll)
        r.GetRollFrom=RotatorAxis_Roll;    
   
   return r;     
}

function rotator ResolveRotator(rotator r, RotatorResolver resolver)
{
    local rotator res;
    
    res.Yaw=ResolveRotatorAxis(r,resolver.GetYawFrom,resolver.bInvertYaw);
    res.Pitch=ResolveRotatorAxis(r,resolver.GetPitchFrom,resolver.bInvertPitch);
    res.Roll=ResolveRotatorAxis(r,resolver.GetRollFrom,resolver.bInvertRoll);
        
    return res;
}

//Get an axis from @r, depending on value of rotator axis @axis
function int ResolveRotatorAxis(rotator r, RotatorAxis axis, optional bool binvert = false)
{
    if (axis==RotatorAxis_Yaw)   
    {
        if (!binvert) 
            return r.Yaw;
        else
            return -r.Yaw;
    }
    else if (axis==RotatorAxis_Pitch)
    {
        if (!binvert) 
            return r.Pitch;
        else
            return -r.Pitch;
    }
    else if (axis==RotatorAxis_Roll)
    {
        if (!binvert) 
            return r.Roll;
        else
            return -r.Roll;
    }
}
    
function SetSkelcontrolRotation()
{
    
}

defaultproperties
{
}
