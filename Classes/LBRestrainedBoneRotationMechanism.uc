/**
 *  LBRestrainedBoneRotationMechanism
 *
 *  Creation date: 17.05.2016 22:33
 *  Copyright 2016, Windows7
 */
class LBRestrainedBoneRotationMechanism extends LBBoneRotationMechanism;

var(RestrainedBoneRotation) bool bUseRestrains;
var(RestrainedBoneRotation) float yawrotRestraintA; //The angle should always be between A and B
var(RestrainedBoneRotation) float yawrotRestraintB;
var(RestrainedBoneRotation) float pitchrotRestraintA;
var(RestrainedBoneRotation) float pitchrotRestraintB;
var(RestrainedBoneRotation) float rollrotRestraintA;
var(RestrainedBoneRotation) float rollrotRestraintB;

function PerformRotation()
{
    if (bonecontroller!=None)
    {
        if (bApplyYaw)
        {
            if (bUseRestrains==true)
                yawrot=fclamp(yawrot, yawrotRestraintA, yawrotRestraintB);
            bonecontroller.BoneRotation.Yaw=yawrot*DegToUnrRot;
        }
        if (bApplyPitch)
        {
            if (bUseRestrains==true)
                pitchrot=fclamp(pitchrot, pitchrotRestraintA, pitchrotRestraintB);
            bonecontroller.BoneRotation.Pitch=pitchrot*DegToUnrRot;
        }
        if (bApplyRoll)
        {
            if (bUseRestrains==true)
                rollrot=fclamp(rollrot, rollrotRestraintA, rollrotRestraintB);
            bonecontroller.BoneRotation.Roll=rollrot*DegToUnrRot; 
        }
    }
}
       
defaultproperties
{
    bUseRestrains=true
    
    yawrotRestraintA=-45
    yawrotRestraintB=45
    pitchrotRestraintA=-45
    pitchrotRestraintB=45
    rollrotRestraintA=-45
    rollrotRestraintB=45
}

