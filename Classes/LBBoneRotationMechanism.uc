/**
 *  LBBoneRotationMechanism
 *
 *  Creation date: 05.04.2016 22:37
 *  Copyright 2016, Windows7
 */
class LBBoneRotationMechanism extends LBSkeletalMeshControlMechanism;

struct LBCoordBasis
{
    var() vector X;
    var() vector Y;
    var() vector Z;    
};

var(BoneRotation) bool bApplyYaw;
var(BoneRotation) bool bApplyPitch;
var(BoneRotation) bool bApplyRoll;

var(BoneRotationMechanismSystem) Name BoneRotationController; //Which controller to use for the rotation
var(BoneRotationMechanismSystem) bool bTranslateFromDegToUnrrot; //Set to true when all input data is given in degrees

var(BoneRotationCoords) LBCoordBasis LocalCoords;

var(MovementSynchronization) bool bTickIndependent;
var(MovementSynchronization) float MovementTimeScale; //A value, x, which affects 1/x (unit / second) ratio
var(MovementSynchronization) float RotationTimeScale;

var(BoneRotationSpeed) bool bSmoothRotation;
var(BoneRotationSpeed) float AngularSpeed;

var(BoneRotation) rotator TargetRotation;

var SkelControlSingleBone bonecontroller;

var rotator currot;

function InitMechanism()
{
    bonecontroller=SkelControlSingleBone(LBPawn(parent).Mesh.FindSkelControl(BoneRotationController));
    
    if (bonecontroller==none)
    {
        LogError("bonecontroller <"@BoneRotationController@"> not found!");    
    }   
    else
    {
         currot=bonecontroller.BoneRotation;
    }
}

function PerfromTick(float dt)
{
    super.PerfromTick(dt);

    PerformRotation(dt); 
    DGDisplayBoneRotation();
}

function rotator GetTargetRotation()
{
    //`log(TargetRotation*unrrottodeg);
    return TargetRotation;
}

function float RotateYaw(float dt)
{
    local float crot,trot,rrot;
    
    trot=GetTargetRotation().Yaw;

    crot=currot.Yaw;    

    if (bSmoothRotation)
        rrot=LinearInterpAngle(crot,trot,TickIndependentFloat(AngularSpeed,dt,RotationTimeScale),dt);
    else
        rrot=trot;
        
    return rrot;   
}

function float RotatePitch(float dt)
{
    local float crot,trot,rrot;
    
    trot=GetTargetRotation().Pitch;

    crot=currot.Pitch;    

    if (bSmoothRotation)
        rrot=LinearInterpAngle(crot,trot,TickIndependentFloat(AngularSpeed,dt,RotationTimeScale),dt);
    else
        rrot=trot;
    
    return rrot;   
}

function float RotateRoll(float dt)
{
    local float crot,trot,rrot;
                        
    trot=GetTargetRotation().Roll;

    crot=currot.Roll;    

    if (bSmoothRotation)
        rrot=LinearInterpAngle(crot,trot,TickIndependentFloat(AngularSpeed,dt,RotationTimeScale),dt);
    else 
        rrot=trot;
    
    return rrot;   
}

function PerformRotation(float dt)
{
    if (bonecontroller!=None)
    {
        if (bApplyYaw)
        {
            currot.Yaw=RotateYaw(dt);
        }
        if (bApplyPitch)
        {
            currot.Pitch=RotatePitch(dt);
        }    
        if (bApplyRoll)
        {
            currot.Roll=RotateRoll(dt);
        }   
         
        bonecontroller.BoneRotation=currot;    
    }
}

function DGDisplayBoneRotation()
{

    
    //r=OrthoRotation(X,Y,Z);
    
    //parent.DrawDebugLine(parent.Location+vect(0,0,96),parent.Location+vector(r)*128+vect(0,0,96),128,128,128); 
}

function SetParamFloat(name param, float value, optional int priority=0)
{    
    if (param=='BoneRotationYaw' || param=='BoneRotation-Yaw')
        TargetRotation.Yaw=value;
    else if (param=='BoneRotationPitch' || param=='BoneRotation-Pitch')
        TargetRotation.Pitch=value;
    else if (param=='BoneRotationRoll' || param=='BoneRotation-Roll')
        TargetRotation.Roll=value;    
} 

function float GetParamFloat(name param)
{
    if (param=='BoneRotationYaw' || param=='BoneRotation-Yaw')
        return TargetRotation.Yaw;
    else if (param=='BoneRotationPitch' || param=='BoneRotation-Pitch')
        return TargetRotation.Pitch;
    else if (param=='BoneRotationRoll' || param=='BoneRotation-Roll')
        return TargetRotation.Roll;   
} 
   
//simulated event Destroyed()
//{
//  Super.Destroyed();
//
//  bonecontroller=None;
//}

function rotator TickIndependentRotator(rotator r, float deltatime, float seconds)
{
    return (deltatime/seconds) * r;
}

function float TickIndependentFloat(float f, float deltatime, float seconds)
{
    return (deltatime/seconds) * f;
}

function float NormalizeDegAngle(float ang)
{
    local float v;

    v=ang % 360;
    
    if (v<0)
        v=v+360;    
        
    return v;
}

function float NormalizeDegAngleByValue(int degangle, int value)
{ 
    return ((degangle * unrrottodeg) % value + value)*degtounrrot;
}

function float UnfoldDegAngle(float ang)
{
    local float a;

    a=ang;
    
    //if (a<-180)
    //a=NormalizeRotAxis(ang)*unrrottodeg; //[-180,180]    
}

function float LinearInterpAngle(float current, float target, float step, float dt)
{
    local float value;
    local float sign;
    
    if (current < target)
    {
        if (abs(target-current) < 180)
        {
            if (abs(current - target) > abs(step))
                value=current+step;
            else
                value=current+abs(current - target);
        }
        else
        {
            if (abs(current - target) > abs(step))
                value=current-step;
            else
                value=current-abs(current - target);
            
            if (value < 0)
                value=value+360;
        }    
    }
    else
    {
        if (abs(target-current) < 180)
        {
            if (abs(current - target) > abs(step))
                value=current-step;
            else
                value=current-abs(current - target);
        }
        else
        {
            if (abs(current - target) > abs(step))
                value=current+step;
            else
                value=current+abs(current - target);
            
            if (value > 360)
                value=value-360;
        }        
    }
    
    return value;
}


defaultproperties
{
    mechname="Bone_Rotation_Mechanism"
    
    AngularSpeed=32.0
    
    bTickIndependent=true
 
    MovementTimeScale=0.01
    RotationTimeScale=0.01
    
    bApplyYaw=true
    bApplyPitch=true
    bApplyRoll=true
    
    LocalCoords=(X=(X=1,Y=0,Z=0),Y=(X=0,Y=1,Z=0),Z=(X=0,Y=0,Z=1))
    
    bTranslateFromDegToUnrrot=true
    
    MechanismParams.Add((ParamName="bApplyYaw", ParamType=ParamType_Boolean, ParamInfo="Boolean. Read, write. Enables or disables yaw rotation."))
    MechanismParams.Add((ParamName="bApplyPitch", ParamType=ParamType_Boolean, ParamInfo="Boolean. Read, write. Enables or disables pitch rotation."))
    MechanismParams.Add((ParamName="bApplyRoll", ParamType=ParamType_Boolean, ParamInfo="Boolean. Read, write. Enables or disables roll rotation."))
    MechanismParams.Add((ParamName="BoneRotationYaw", ParamType=ParamType_Float, ParamInfo="Float. Read, write. Gets or sets the value of yaw rotation."))
    MechanismParams.Add((ParamName="BoneRotationPitch", ParamType=ParamType_Float, ParamInfo="Float. Read, write. Gets or sets the value of pitch rotation."))
    MechanismParams.Add((ParamName="BoneRotationRoll", ParamType=ParamType_Float, ParamInfo="Float. Read, write. Gets or sets the value of roll rotation."))
    
    ParamSource.Add((ParamName="bApplyYaw"))
    ParamSource.Add((ParamName="bApplyPitch"))
    ParamSource.Add((ParamName="bApplyRoll"))
    ParamSource.Add((ParamName="BoneRotationYaw"))
    ParamSource.Add((ParamName="BoneRotationPitch"))
    ParamSource.Add((ParamName="BoneRotationRoll"))
}
