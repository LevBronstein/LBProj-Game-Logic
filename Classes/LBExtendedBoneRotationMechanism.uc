/**
 *  LBCharacterHeadTargetingMechanism
 *
 *  Creation date: 15.10.2017 23:02
 *  Copyright 2017, Win10
 */
class LBExtendedBoneRotationMechanism extends LBBoneRotationMechanism;

enum BoneBehaviorModes
{
    BoneBehaviorModes_Free, //Behaves just like the LBRestrainedBoneRotationMechanism mechanism
    BoneBehaviorModes_LookAtPoint, //Calculates @TargetRotation based on location of @LookAtPoint
    BoneBehaviorModes_LookAtActor, //Calculates @TargetRotation based on location of @LookAtActor
};

var(ExtendedBoneRotationMechanism) BoneBehaviorModes BehaviorMode;
var(ExtendedBoneRotationMechanism) vector LookAtPoint;
var(ExtendedBoneRotationMechanism) actor LookAtActor;
//Set to TRUE when BoneBehaviorModes_Free should be used when @TargetRotation is out of restraints bounds
var(BoneRotationRestraint) bool bDefaultTRWhenOutOfRestraints;
//An offset (aproximate) of the target bone
var(BoneRotationCoords) vector BaseOffset;

function ChangeBehaviorMode(int newmode)
{
    if (newmode==2)
    {
        BehaviorMode=BoneBehaviorModes_LookAtPoint;    
    }
    else if (newmode==3)
    {
        BehaviorMode=BoneBehaviorModes_LookAtActor;    
    }    
    else
    {
        BehaviorMode=BoneBehaviorModes_Free;    
    }
}

function Rotator GetTargetRotation()
{
    local vector v, X,Y,Z;
    local rotator r,res;
    local float f1,f2;
    local bool bOutOfBounds;
    
    if (BehaviorMode==BoneBehaviorModes_LookAtPoint)
    {
        v=LookAtPoint-(parent.location+BaseOffset);
        r=rotator(v);
        
        if (YawRestraint.bUseRestraint)
        {
            res.Yaw=ClampRotatorAxis(r.Yaw,NormalizeRotAxis(parent.rotation.Yaw+YawRestraint.MinValueDeg*degtounrrot),NormalizeRotAxis(parent.rotation.Yaw+YawRestraint.MaxValueDeg*degtounrrot));
            
            if (bDefaultTRWhenOutOfRestraints && NormalizeRotAxis(res.Yaw)!=NormalizeRotAxis(r.Yaw) || bOutOfBounds)
            {
                res.Yaw=super.GetTargetRotation().Yaw;
                bOutOfBounds=true;
            }
            else
                res.Yaw=res.Yaw-parent.Rotation.Yaw;
        }
        else
            res.Yaw=r.Yaw-parent.Rotation.Yaw;
            
        if (PitchRestraint.bUseRestraint)
        {
            res.Pitch=ClampRotatorAxis(r.Pitch,NormalizeRotAxis(parent.rotation.Pitch+PitchRestraint.MinValueDeg*degtounrrot),NormalizeRotAxis(parent.rotation.Pitch+PitchRestraint.MaxValueDeg*degtounrrot));
            
            if (bDefaultTRWhenOutOfRestraints && NormalizeRotAxis(res.Pitch)!=NormalizeRotAxis(r.Pitch) || bOutOfBounds)
            {
                res.Pitch=super.GetTargetRotation().Pitch;
                bOutOfBounds=true;
            }
            else
                res.Pitch=res.Pitch-parent.Rotation.Pitch;
        }
        else
            res.Pitch=r.Pitch-parent.Rotation.Pitch;
        
        if (RollRestraint.bUseRestraint)
        {
            res.Roll=ClampRotatorAxis(r.Roll,NormalizeRotAxis(parent.rotation.Roll+RollRestraint.MinValueDeg*degtounrrot),NormalizeRotAxis(parent.rotation.Roll+RollRestraint.MaxValueDeg*degtounrrot))-parent.Rotation.Roll;
            
            if (bDefaultTRWhenOutOfRestraints && NormalizeRotAxis(res.Roll)!=NormalizeRotAxis(r.Roll) || bOutOfBounds)
            {
                res.Roll=super.GetTargetRotation().Roll;
                bOutOfBounds=true;
            }
            else
                res.Roll=res.Roll-parent.Rotation.Roll;
        }
        else
            res.Roll=r.Roll-parent.Rotation.Roll;            
            
        return res;     
    }    
    else if (BehaviorMode==BoneBehaviorModes_LookAtActor)
    {
        v=LookAtActor.Location-(parent.location+BaseOffset);
        r=rotator(v);
       
        if (YawRestraint.bUseRestraint)
        {
            res.Yaw=ClampRotatorAxis(r.Yaw,NormalizeRotAxis(parent.rotation.Yaw+YawRestraint.MinValueDeg*degtounrrot),NormalizeRotAxis(parent.rotation.Yaw+YawRestraint.MaxValueDeg*degtounrrot));
            
            if (bDefaultTRWhenOutOfRestraints && NormalizeRotAxis(res.Yaw)!=NormalizeRotAxis(r.Yaw) || bOutOfBounds)
            {
                res.Yaw=super.GetTargetRotation().Yaw;
                bOutOfBounds=true;
            }
            else
                res.Yaw=res.Yaw-parent.Rotation.Yaw;
        }
        else
            res.Yaw=r.Yaw-parent.Rotation.Yaw;
            
        if (PitchRestraint.bUseRestraint)
        {
            res.Pitch=ClampRotatorAxis(r.Pitch,NormalizeRotAxis(parent.rotation.Pitch+PitchRestraint.MinValueDeg*degtounrrot),NormalizeRotAxis(parent.rotation.Pitch+PitchRestraint.MaxValueDeg*degtounrrot));
            
            if (bDefaultTRWhenOutOfRestraints && NormalizeRotAxis(res.Pitch)!=NormalizeRotAxis(r.Pitch) || bOutOfBounds)
            {
                res.Pitch=super.GetTargetRotation().Pitch;
                bOutOfBounds=true;
            }
            else
                res.Pitch=res.Pitch-parent.Rotation.Pitch;
        }
        else
            res.Pitch=r.Pitch-parent.Rotation.Pitch;
        
        if (RollRestraint.bUseRestraint)
        {
            res.Roll=ClampRotatorAxis(r.Roll,NormalizeRotAxis(parent.rotation.Roll+RollRestraint.MinValueDeg*degtounrrot),NormalizeRotAxis(parent.rotation.Roll+RollRestraint.MaxValueDeg*degtounrrot))-parent.Rotation.Roll;
            
            if (bDefaultTRWhenOutOfRestraints && NormalizeRotAxis(res.Roll)!=NormalizeRotAxis(r.Roll) || bOutOfBounds)
            {
                res.Roll=super.GetTargetRotation().Roll;
                bOutOfBounds=true;
            }
            else
                res.Roll=res.Roll-parent.Rotation.Roll;
        }
        else
            res.Roll=r.Roll-parent.Rotation.Roll;            
            
        return res;  
    }
    else
    {
        return super.GetTargetRotation();  
    }
}

function DGDisplayBoneRotation()
{
    local rotator r;
    local vector v,X,Y,Z;
    
    //parent.DrawDebugLine(parent.Location+vect(0,0,96),parent.Location+LocalCoords.X*64+vect(0,0,96),128,0,0);  
    //parent.DrawDebugLine(parent.Location+vect(0,0,96),parent.Location+LocalCoords.Y*64+vect(0,0,96),0,128,0);   
    //parent.DrawDebugLine(parent.Location+vect(0,0,96),parent.Location+LocalCoords.Z*64+vect(0,0,96),0,0,128); 
    
    GetAxes(currot,X,Y,Z);
    //`log(currot*unrrottodeg);
    
    //v=(LookAtActor.Location-parent.Location).X*X+(LookAtActor.Location-parent.Location).Y*Y+(LookAtActor.Location-parent.Location).Z*Z;
    //
    //parent.DrawDebugLine(parent.Location+vect(0,0,96),parent.Location+X*64+vect(0,0,96),128,0,0);  
    //parent.DrawDebugLine(parent.Location+vect(0,0,96),parent.Location+Y*64+vect(0,0,96),0,128,0);   
    //parent.DrawDebugLine(parent.Location+vect(0,0,96),parent.Location+Z*64+vect(0,0,96),0,0,128); 
    //
    //parent.DrawDebugLine(parent.Location+vect(0,0,96),parent.Location+v*128+vect(0,0,96),128,128,128);
}

//function rotator GetExtendedTargetRotation(float dt)
//{
//    local vector v, X,Y,Z;
//    local rotator r;
//    
//    if (BehaviorMode==BoneBehaviorModes_LookAtPoint)
//    {
//        v=parent.Location-LookAtPoint;
//        r=rotator(v)-parent.Rotation;
//        `log("r.Yaw"@r.Yaw*unrrottodeg@"r.Pitch"@r.Pitch*unrrottodeg@"r.Roll"@r.Roll*unrrottodeg);
//        //TargetRotation=r+currot;  
//        TargetRotation.Pitch=r.Yaw;       
//                //`log("currot="@currot*UnrRotToDeg);
//         
//    }    
//    else if (BehaviorMode==BoneBehaviorModes_LookAtActor)
//    {
//        v=LookAtActor.location-parent.location;
//        r=rotator(v)-parent.Rotation;
//        TargetRotation.Pitch=r.Yaw;
//        //TargetRotation=r;    
//    }     
//    
//    //if (bTranslateFromDegToUnrrot)
//    //TargetRotation=TargetRotation*UnrRotToDeg; 
//         
//}
    
//function PerfromTick(float dt)
//{
//    UpdateTargetRotation(dt);
//    //bonecontroller.BoneRotation=TargetRotation;
//    super.PerfromTick(dt);
//}
//
//function PerformRotation(float dt)
//{
//    //UpdateTargetRotation(dt);
//
//    super.PerformRotation(dt);   
//
//    //`log(bonecontroller.BoneRotation);
//
//}

function SetParamInt(name param, int value, optional int priority=0)
{
    if (param=='BehaviorMode' || param=='ChangeBehaviorMode')
        ChangeBehaviorMode(value);    
    else 
        super.SetParamInt(param, value, priority);
}
    
function SetParamFloat(name param, float value, optional int priority=0)
{    
    if (param=='BoneRotationYaw' || param=='BoneRotation-Yaw')
    {
        if (BehaviorMode==BoneBehaviorModes_Free)
            super.SetParamFloat(param, value, priority);
    }
    else if (param=='BoneRotationPitch' || param=='BoneRotation-Pitch')
    {
        if (BehaviorMode==BoneBehaviorModes_Free)
            super.SetParamFloat(param, value, priority);
    }
    else if (param=='BoneRotationRoll' || param=='BoneRotation-Roll')
    {
        if (BehaviorMode==BoneBehaviorModes_Free)
            super.SetParamFloat(param, value, priority);
    } 
    else
        super.SetParamFloat(param, value, priority);   
} 
 
function SetParamRotator(name param, rotator value, optional int priority=0)
{
    if (param=='BoneRotation' || param=='TargetRotation')
    {
        if (BehaviorMode==BoneBehaviorModes_Free)
            super.SetParamRotator(param, value, priority);
    }
    else
        super.SetParamRotator(param, value, priority);
}

function SetParamVector(name param, vector value, optional int priority=0)
{
    if (param=='LookAtPoint')
        LookAtPoint=value;   
    else
        super.SetParamVector(param, value, priority);   
}
    
function SetParam(name param, object value, optional int priority=0)
{
    if (param=='LookAtActor')
    LookAtActor=Actor(value);   
    else
        super.SetParam(param, value, priority);   
}
    
function int GetParamInt(name param)
{
    if (param=='BehaviorMode')
        return BehaviorMode;   
    else 
        return super.GetParamInt(param);
}

defaultproperties
{
    mechname="Extended_Bone_Rotation_Mechanism"
}
