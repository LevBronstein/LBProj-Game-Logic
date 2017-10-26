/**
 *  LBBoneRotationMechanism
 *
 *  Creation date: 05.04.2016 22:37
 *  Copyright 2016, Windows7
 */
class LBBoneRotationMechanism extends LBSkeletalMeshControlMechanism;

struct RotationRestraint
{
    var() bool bUseRestraint;
    var() float MinValueDeg <editcondition=bUseRestraint>;
    var() float MaxValueDeg <editcondition=bUseRestraint>;    
};

var(BoneRotation) bool bApplyYaw;
var(BoneRotation) bool bApplyPitch;
var(BoneRotation) bool bApplyRoll;

var(BoneRotationCoords) bool bResolveFromWorldSpace;
//All rotations are made in world space and the translated to local (bone, socket, etc) space
var(BoneRotationCoords) RotatorResolver BoneRotationResolver <editcondition=bResolveFromWorldSpace>; 

var(BoneRotationRestraint) RotationRestraint YawRestraint; 
var(BoneRotationRestraint) RotationRestraint PitchRestraint; 
var(BoneRotationRestraint) RotationRestraint RollRestraint; 

var(BoneRotationSpeed) bool bSmoothRotation;
var(BoneRotationSpeed) float AngularSpeed;

var(MovementSynchronization) bool bTickIndependent;
var(MovementSynchronization) float MovementTimeScale; //A value, x, which affects 1/x (unit / second) ratio
var(MovementSynchronization) float RotationTimeScale;

var(BoneRotationMechanismSystem) Name BoneRotationController; //Which controller to use for the rotation
var(BoneRotationMechanismSystem) bool bTranslateFromDegToUnrrot; //Set to true when all input data is given in degrees

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
    local rotator res;
    
    if (YawRestraint.bUseRestraint)
        res.Yaw=ClampRotatorAxis(TargetRotation.Yaw,YawRestraint.MinValueDeg*degtounrrot,YawRestraint.MaxValueDeg*degtounrrot);
    else
        res.Yaw=TargetRotation.Yaw;
        
    if (PitchRestraint.bUseRestraint)
        res.Pitch=ClampRotatorAxis(TargetRotation.Pitch,PitchRestraint.MinValueDeg*degtounrrot,PitchRestraint.MaxValueDeg*degtounrrot);
    else
        res.Pitch=TargetRotation.Pitch;

    if (RollRestraint.bUseRestraint)
        res.Roll=ClampRotatorAxis(TargetRotation.Roll,RollRestraint.MinValueDeg*degtounrrot,RollRestraint.MaxValueDeg*degtounrrot);
    else
        res.Roll=TargetRotation.Roll;

    return res;
}

function float RotateYaw(float dt)
{
    local float crot,trot,rrot;
    
    trot=GetTargetRotation().Yaw;

    crot=currot.Yaw;    

    if (bSmoothRotation)
        rrot=LinearInterpAngle(crot*unrrottodeg,trot*unrrottodeg,TickIndependentFloat(AngularSpeed,dt,RotationTimeScale),dt)*degtounrrot;
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
        rrot=LinearInterpAngle(crot*unrrottodeg,trot*unrrottodeg,TickIndependentFloat(AngularSpeed,dt,RotationTimeScale),dt)*degtounrrot;
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
        rrot=LinearInterpAngle(crot*unrrottodeg,trot*unrrottodeg,TickIndependentFloat(AngularSpeed,dt,RotationTimeScale),dt)*degtounrrot;
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
        
        if (bResolveFromWorldSpace)
            bonecontroller.BoneRotation=ResolveRotator(currot,BoneRotationResolver);
        else
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

function

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

function int ClampRotatorAxis(int axisvalue, int min, int max)
{
    local int r,f1,f2;
    
    f1=NormalizeRotAxis(min);
    f2=NormalizeRotAxis(max);
    
    r=NormalizeRotAxis(axisvalue);
    
    if (0<=f1*unrrottodeg && f1*unrrottodeg<=180)
    {
        if (0<=f2*unrrottodeg && f2*unrrottodeg<=180)
        {
            if (0<r && r<=f1)
            {
                r=f1;     
            }
                
            if (f2<=r && r<180*degtounrrot)
            {
                r=f2;    
            }  
           
            if (-180*degtounrrot<=r && r<=0)
            {
                if ((-r)+f1 <= (r-(-180)*degtounrrot)+(180*degtounrrot-f2))    
                    r=f1; 
                else 
                    r=f2;    
            }
        }
        else
        {
            if (f2<=r && r<0)
            {
                if ((-r)+f1 <= r-f2)    
                    r=f1; 
                else 
                    r=f2;       
            }
                
            if (0<=r && r<=f1)
            {
                if (f1-r < r+(-f2))    
                    r=f1; 
                else 
                    r=f2;    
            }  
        }
    }
    else
    {
        if (0<=f2*unrrottodeg && f2*unrrottodeg<=180) 
        {
            if (f2<=r && r<=180*degtounrrot)
            {
                if ((180*degtounrrot-r)+(f1-(-180)*degtounrrot) < r-f2)    
                    r=f1; 
                else 
                    r=f2;       
            }
                
            if (-180*degtounrrot<r && r<=f1)
            {
                if (r-f1 < (r-(-180)*degtounrrot)+(180*degtounrrot-f2))    
                    r=f1; 
                else 
                    r=f2;    
            }
        }
        else
        {
            if (f2<r && r<=0)
            {
                r=f2;     
            }
                
            if ((-180)*degtounrrot<=r && r<f1) 
            {
                r=f1;    
            }  
           
            if (0<r && r<=180*degtounrrot)
            {
                if ((f1-(-180)*degtounrrot)+(180*degtounrrot-r) < r+(-f2))    
                    r=f1; 
                else 
                    r=f2;    
            }
        }   
    }   
    
    return r;  
}

function rotator ClampRotator(rotator r, optional bool bClampYaw=false, optional int Yawf1=0, optional int Yawf2=0, optional bool bClampPitch=false, optional int Pitchf1=0, optional int Pitchf2=0,
optional bool bClampRoll=false, optional int Rollf1=0, optional int Rollf2=0)
{   
    local rotator res;
    
    if (bClampYaw)
        res.Yaw=ClampRotatorAxis(r.Yaw,Yawf1,Yawf2);
        
    if (bClampPitch)
        res.Pitch=ClampRotatorAxis(r.Pitch,Pitchf1,Pitchf2); 
     
    if (bClampRoll)
        res.Roll=ClampRotatorAxis(r.Roll,Rollf1,Rollf2);  

    return res;    
}
    

defaultproperties
{
    mechname="Bone_Rotation_Mechanism"
    
    AngularSpeed=32.0
    
    bTickIndependent=true
 
    MovementTimeScale=0.01
    RotationTimeScale=0.01
    
    BoneRotationResolver=(GetYawFrom=RotatorAxis_Yaw,GetPitchFrom=RotatorAxis_Pitch,GetRollFrom=RotatorAxis_Roll)
    
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
