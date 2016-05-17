/**
 *  LBBoneRotationMechanism
 *
 *  Creation date: 05.04.2016 22:37
 *  Copyright 2016, Windows7
 */
class LBBoneRotationMechanism extends LBMechanism;

var(ParamSource) name ParameterSource; //A mechanism, from which we get all params via GetParamFloat
var(ParamSource) bool bApplyYaw;
var(ParamSource) name YawRotationParam; //A name for a float param, that sets the yawrot
var(ParamSource) bool bApplyPitch;
var(ParamSource) name PitchRotationParam; //A name for a float param, that sets the pitchrot
var(ParamSource) bool bApplyRoll;
var(ParamSource) name RollRotationParam; //A name for a float param, that sets the rollrot
var(ParamSource) bool bUseParamSource; //Defines whether we should get params (from ParameterSource)
var(Animation) Name BoneRotationController; //Which controller to use for the rotation

var(BoneRotation) float yawrot;
var(BoneRotation) float pitchrot;
var(BoneRotation) float rollrot;

var SkelControlSingleBone bonecontroller;

function FirstTickInit()
{
    if (bfirsttick==false)
        return;
    
    if (bfirsttick==true)
        bfirsttick=false;
        
    bonecontroller=SkelControlSingleBone(LBPawn(parent).Mesh.FindSkelControl(BoneRotationController));
    if (bonecontroller==none)
    {
        LogError("bonecontroller <"@BoneRotationController@"> not found!");
    }
}

event OwnerTick(float deltatime)
{
    super.OwnerTick(deltatime);
    
    if(benabled==false)
        return;
    
    if (bUseParamSource)
        GetParameters();
        
    PerformRotation();  
}

function PerformRotation()
{
    if (bonecontroller!=None)
    {
        if (bApplyYaw)
        bonecontroller.BoneRotation.Yaw=yawrot*DegToUnrRot;
        if (bApplyPitch)
        bonecontroller.BoneRotation.Pitch=pitchrot*DegToUnrRot;
        if (bApplyRoll)
        bonecontroller.BoneRotation.Roll=rollrot*DegToUnrRot; 
    }
}

function GetParameters()
{
    if (LBPawn(parent)!=none)
    {
        if (bApplyYaw)
        yawrot=LBPawn(parent).GetParamFloat(ParameterSource,YawRotationParam);
        if (bApplyPitch)
        pitchrot=LBPawn(parent).GetParamFloat(ParameterSource,PitchRotationParam);
        if (bApplyRoll)
        rollrot=LBPawn(parent).GetParamFloat(ParameterSource,RollRotationParam);
        return;
    }
}


defaultproperties
{
    bApplyYaw=true
    bApplyPitch=true
    bApplyRoll=true
}
