/**
 *  LBBoneRollMechanism
 *
 *  Creation date: 11.03.2017 18:14
 *  Copyright 2017, Windows7
 */
class LBBoneRollMechanism extends LBSkeletalMeshControlMechanism;

enum RollAxes
{
    RollAxis_Yaw,
    RollAxis_Pitch,
    RollAxis_Roll
};

var(Animation) Name BoneRotationController; //Which controller to use for the rotation
var(Animation) EditModes EditMode;

var(BoneRollMechanism) RollAxes RollAxis;
var(BoneRollMechanism) float kAngSpeed;
var(BoneRollMechanism) bool bReturnToDefaultAngle;
var(BoneRollMechanism) float DefaultAngle;
var(BoneRollMechanism) float ReturnSpeed;

var SkelControlSingleBone bonecontroller;
var vector lastloc;

function InitMechanism()
{
    bonecontroller=SkelControlSingleBone(LBPawn(parent).Mesh.FindSkelControl(BoneRotationController));
    
    if (bonecontroller==none)
    {
        LogError("bonecontroller <"@BoneRotationController@"> not found!");
    }  
    else
    {
        LogInfo("found bonecontroller <"@BoneRotationController@">");
    }
  
    lastloc=parent.Location;  
}

function PerfromTick(float dt)
{   
    PerformRotation(dt);     
}

function PerformRotation(float dt)
{
    local vector v;
    local float drot;
    local float currot;

    
    v=parent.Location-lastloc;
    
    if (Vsize(v) < 0.01 && bReturnToDefaultAngle)
    {
        
        if (bonecontroller!=None)
        {
            if (RollAxis==RollAxis_Yaw)
                currot=bonecontroller.BoneRotation.Yaw*UnrRotToDeg;
            if (RollAxis==RollAxis_Pitch)
                currot=bonecontroller.BoneRotation.Pitch*UnrRotToDeg;
            if (RollAxis==RollAxis_Roll)
                currot=bonecontroller.BoneRotation.Roll*UnrRotToDeg;
        } 
            
        if (currot>360)
            currot=currot%360;
        
        drot=FInterpTo(currot,DefaultAngle,dt,ReturnSpeed);   
    
        if (bonecontroller!=None)
        {
            if (RollAxis==RollAxis_Yaw)
                bonecontroller.BoneRotation.Yaw=drot*DegToUnrRot;
            if (RollAxis==RollAxis_Pitch)
                bonecontroller.BoneRotation.Pitch=drot*DegToUnrRot;
            if (RollAxis==RollAxis_Roll)
                bonecontroller.BoneRotation.Roll=drot*DegToUnrRot;
        }
    }
    else
    {
        drot=Vsize(v)*kAngSpeed*DegToUnrRot;
    
        if (bonecontroller!=None)
        {
            if (RollAxis==RollAxis_Yaw)
                bonecontroller.BoneRotation.Yaw=bonecontroller.BoneRotation.Yaw+drot;
            if (RollAxis==RollAxis_Pitch)
                bonecontroller.BoneRotation.Pitch=bonecontroller.BoneRotation.Pitch+drot;
            if (RollAxis==RollAxis_Roll)
                bonecontroller.BoneRotation.Roll=bonecontroller.BoneRotation.Roll+drot;
        }
    }   
    
    lastloc=parent.Location;        
}


defaultproperties
{
    mechname="Bone_Roll_Mechanism"
    
    EditModes=EditModes_Set;
    
    kAngSpeed=1.0f;
    
    ReturnSpeed=1.0f
}