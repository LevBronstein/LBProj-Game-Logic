/**
 *  LBRestrainedBoneRotationMechanism
 *
 *  Creation date: 17.05.2016 22:33
 *  Copyright 2016, Windows7
 */
class LBRestrainedBoneRotationMechanism extends LBBoneRotationMechanism;

struct LBRotationRestraint
{
    var() bool bUseRestraint;
    var() float MinValue <editcondition=bUseRestraint | ClampMin=-180 | ClampMax=180>;
    var() float MaxValue <editcondition=bUseRestraint | ClampMin=-180 | ClampMax=180>;
};

var(RestrainedBoneRotation) LBRotationRestraint YawRotationRestraint;
var(RestrainedBoneRotation) LBRotationRestraint PitchRotationRestraint;
var(RestrainedBoneRotation) LBRotationRestraint RollRotationRestraint;

function float ClampYaw(float ang)
{
    local float r;
    
    if (bTranslateFromDegToUnrrot)
        r=ang;
    else
        r=ang * UnrRotToDeg;
    
    r=fclamp(r,min(YawRotationRestraint.MinValue,YawRotationRestraint.MaxValue),max(YawRotationRestraint.MinValue,YawRotationRestraint.MaxValue));
    
    if (bTranslateFromDegToUnrrot)
        return r;
    else
        return r * DegToUnrRot;
    
    return r;    
}
    
function float ClampPitch(float ang)
{
    local float r;
    
    if (bTranslateFromDegToUnrrot)
        r=ang;
    else
        r=ang * UnrRotToDeg;
    
    r=fclamp(r,min(PitchRotationRestraint.MinValue,PitchRotationRestraint.MaxValue),max(PitchRotationRestraint.MinValue,PitchRotationRestraint.MaxValue));
    
    if (bTranslateFromDegToUnrrot)
        return r;
    else
        return r * DegToUnrRot;
    
    return r;    
}

function float ClampRoll(float ang)
{
    local float r;
    
    if (bTranslateFromDegToUnrrot)
        r=ang;
    else
        r=ang * UnrRotToDeg;
    
    r=fclamp(r,min(RollRotationRestraint.MinValue,RollRotationRestraint.MaxValue),max(RollRotationRestraint.MinValue,RollRotationRestraint.MaxValue));
    
    if (bTranslateFromDegToUnrrot)
        return r;
    else
        return r * DegToUnrRot;
    
    return r;    
}
   
function SetParamFloat(name param, float value, optional int priority=0)
{    
    if (param=='BoneRotationYaw' || param=='BoneRotation-Yaw')
        TargetRotation.Yaw=ClampYaw(value);
    else if (param=='BoneRotationPitch' || param=='BoneRotation-Pitch')
        TargetRotation.Pitch=ClampPitch(value);
    else if (param=='BoneRotationRoll' || param=='BoneRotation-Roll')
        TargetRotation.Roll=ClampRoll(value); 
    else
        super.SetParamFloat(param, value, priority);   
} 
 
defaultproperties
{
    mechname="Restrtained_Bone_Rotation_Mechanism"
    
    YawRotationRestraint=(bUseRestraint=true, MinValue=-45, MaxValue=45, ValueOffset=0)
    PitchRotationRestraint=(bUseRestraint=true, MinValue=-45, MaxValue=45, ValueOffset=0)
    RollRotationRestraint=(bUseRestraint=true, MinValue=-45, MaxValue=45, ValueOffset=0)
}

