/**
 *  LBRestrainedBoneRotationMechanism
 *
 *  Creation date: 17.05.2016 22:33
 *  Copyright 2016, Windows7
 */
class LBRestrainedBoneRotationMechanism extends LBBoneRotationMechanism;





//function Rotator GetTargetRotation()
//{
//    if (bTranslateFromDegToUnrrot)
//        return ClampRotator(TargetRotation); //already in UnrRots
//    else
//        return ClampRotator(TargetRotation) * UnrRotToDeg;
//}
//    
//function rotator ClampRotator(rotator r)
//{
//    local rotator res;
//
//    res.Yaw=ClampYaw(r.Yaw);
//    res.Pitch=ClampPitch(r.Pitch);
//    res.Roll=ClampRoll(r.Roll);
//    
//    return res;
//}
//
//function float ClampYaw(float ang)
//{
//    local float r;
//    
//    if (bTranslateFromDegToUnrrot)
//        r=ang;
//    else
//        r=ang * UnrRotToDeg;
//    
//    if (YawRotationRestraint.bUseRestraint)
//        r=fclamp(r,min(YawRotationRestraint.MinValue,YawRotationRestraint.MaxValue),max(YawRotationRestraint.MinValue,YawRotationRestraint.MaxValue));
//    
//    if (bTranslateFromDegToUnrrot)
//        return r;
//    else
//        return r * DegToUnrRot;
//    
//    return r;    
//}
//    
//function float ClampPitch(float ang)
//{
//    local float r;
//    
//    if (bTranslateFromDegToUnrrot)
//        r=ang;
//    else
//        r=ang * UnrRotToDeg;
//        
//    if (PitchRotationRestraint.bUseRestraint)    
//        r=fclamp(r,min(PitchRotationRestraint.MinValue,PitchRotationRestraint.MaxValue),max(PitchRotationRestraint.MinValue,PitchRotationRestraint.MaxValue));
//    
//    if (bTranslateFromDegToUnrrot)
//        return r;
//    else
//        return r * DegToUnrRot;
//    
//    return r;    
//}
//
//function float ClampRoll(float ang)
//{
//    local float r;
//    
//    if (bTranslateFromDegToUnrrot)
//        r=ang;
//    else
//        r=ang * UnrRotToDeg;
//        
//    if (RollRotationRestraint.bUseRestraint)
//        r=fclamp(r,min(RollRotationRestraint.MinValue,RollRotationRestraint.MaxValue),max(RollRotationRestraint.MinValue,RollRotationRestraint.MaxValue));
//    
//    if (bTranslateFromDegToUnrrot)
//        return r;
//    else
//        return r * DegToUnrRot;
//    
//    return r;    
//}
//
//function DGDisplayBoneRotation()
//{
//    local rotator r;
//    
//    super.DGDisplayBoneRotation();
//    
//    //r=ResolveRotator(currot,RotatorResolver(RotationAxes_Pitch,RotationAxes_Roll,RotationAxes_Yaw,,,true));
//    if (YawRotationRestraint.bUseRestraint)
//    {
//        r=rot(0,0,0);
//        r.Yaw=YawRotationRestraint.MinValue*DegToUnrRot; 
//        r=ResolveRotator(r,RotatorResolver(RotationAxes_Pitch,RotationAxes_Roll,RotationAxes_Yaw,,,true));
//        parent.DrawDebugLine(parent.Location+vect(0,0,96),parent.Location+vector(r)*64+vect(0,0,96),64,0,0);
//        r=rot(0,0,0);
//        r.Yaw=YawRotationRestraint.MaxValue*DegToUnrRot; 
//        r=ResolveRotator(r,RotatorResolver(RotationAxes_Pitch,RotationAxes_Roll,RotationAxes_Yaw,,,true));
//        parent.DrawDebugLine(parent.Location+vect(0,0,96),parent.Location+vector(r)*64+vect(0,0,96),64,0,0);  
//    }
//    if (PitchRotationRestraint.bUseRestraint)
//    {
//        r=rot(0,0,0);
//        r.Pitch=PitchRotationRestraint.MinValue*DegToUnrRot;
//        r=ResolveRotator(r,RotatorResolver(RotationAxes_Pitch,RotationAxes_Roll,RotationAxes_Yaw,,,true)); 
//        parent.DrawDebugLine(parent.Location+vect(0,0,96),parent.Location+vector(r)*64+vect(0,0,96),64,0,0);
//        r=rot(0,0,0);
//        r.Pitch=PitchRotationRestraint.MaxValue*DegToUnrRot; 
//        r=ResolveRotator(r,RotatorResolver(RotationAxes_Pitch,RotationAxes_Roll,RotationAxes_Yaw,,,true));
//        parent.DrawDebugLine(parent.Location+vect(0,0,96),parent.Location+vector(r)*64+vect(0,0,96),64,0,0);  
//    }
//    if (RollRotationRestraint.bUseRestraint)
//    {
//        r=rot(0,0,0);
//        r.Roll=RollRotationRestraint.MinValue*DegToUnrRot; 
//        r=ResolveRotator(r,RotatorResolver(RotationAxes_Pitch,RotationAxes_Roll,RotationAxes_Yaw,,,true));
//        parent.DrawDebugLine(parent.Location+vect(0,0,96),parent.Location+vector(r)*64+vect(0,0,96),64,0,0);
//        r=rot(0,0,0);
//        r.Roll=RollRotationRestraint.MaxValue*DegToUnrRot; 
//        r=ResolveRotator(r,RotatorResolver(RotationAxes_Pitch,RotationAxes_Roll,RotationAxes_Yaw,,,true));
//        parent.DrawDebugLine(parent.Location+vect(0,0,96),parent.Location+vector(r)*64+vect(0,0,96),64,0,0);   
//    }  
//}


//function float RotateYaw(float dt)
//{
//    local float crot,trot,rrot;
//    
//    if (bTranslateFromDegToUnrrot)
//        trot=TargetRotation.Yaw;
//    else
//        trot=TargetRotation.Yaw * UnrRotToDeg;
//     
//    //trot=NormalizeDegAngle(trot);
//    
//    trot=ClampYaw(trot);
//
//    crot=currot.Yaw*unrrottodeg;    
//
//    rrot=LinearInterpAngle(crot,trot,TickIndependentFloat(AngularSpeed,dt,RotationTimeScale),dt);
//    return rrot;   
//}
//
//function float RotatePitch(float dt)
//{
//    local float crot,trot,rrot;
//    
//    if (bTranslateFromDegToUnrrot)
//        trot=TargetRotation.Pitch;
//    else
//        trot=TargetRotation.Pitch * UnrRotToDeg;
//        
//    trot=ClampPitch(trot);  
//    
//    //trot=NormalizeDegAngle(trot);
//    
//    crot=currot.Pitch*unrrottodeg;    
//
//    rrot=LinearInterpAngle(crot,trot,TickIndependentFloat(AngularSpeed,dt,RotationTimeScale),dt);
//    return rrot;   
//}
//
//function float RotateRoll(float dt)
//{
//    local float crot,trot,rrot;
//    
//    if (bTranslateFromDegToUnrrot)
//        trot=TargetRotation.Roll;
//     else
//        trot=TargetRotation.Roll * UnrRotToDeg;
//                        
//    //trot=NormalizeDegAngle(trot);
//    
//    trot=ClampRoll(trot);
//
//    crot=currot.Roll*unrrottodeg;    
//
//    rrot=LinearInterpAngle(crot,trot,TickIndependentFloat(AngularSpeed,dt,RotationTimeScale),dt);
//    return rrot;   
//}

//function PerformRotation(float dt)
//{
//    //TargetRotation.Yaw=ClampYaw(TargetRotation.Yaw);
//    //TargetRotation.Pitch=ClampPitch(TargetRotation.Pitch);
//    //TargetRotation.Roll=ClampRoll(TargetRotation.Roll);
//    
//    super.PerformRotation(dt);
//}
   
//function SetParamFloat(name param, float value, optional int priority=0)
//{    
//    if (param=='BoneRotationYaw' || param=='BoneRotation-Yaw')
//        TargetRotation.Yaw=ClampYaw(value);
//    else if (param=='BoneRotationPitch' || param=='BoneRotation-Pitch')
//        TargetRotation.Pitch=ClampPitch(value);
//    else if (param=='BoneRotationRoll' || param=='BoneRotation-Roll')
//        TargetRotation.Roll=ClampRoll(value); 
//    else
//        super.SetParamFloat(param, value, priority);   
//} 
// 
//function SetParamRotator(name param, rotator value, optional int priority=0)
//{
//    if (param=='BoneRotation' || param=='TargetRotation')
//    {
//        TargetRotation.Yaw=ClampYaw(value.Yaw); 
//        TargetRotation.Pitch=ClampPitch(value.Pitch); 
//        TargetRotation.Roll=ClampRoll(value.Roll);
//    }
//    else
//        super.SetParamRotator(param, value, priority);
//}
    
defaultproperties
{
    mechname="Restrtained_Bone_Rotation_Mechanism"
    
    YawRotationRestraint=(bUseRestraint=true, MinValue=-45, MaxValue=45, ValueOffset=0)
    PitchRotationRestraint=(bUseRestraint=true, MinValue=-45, MaxValue=45, ValueOffset=0)
    RollRotationRestraint=(bUseRestraint=true, MinValue=-45, MaxValue=45, ValueOffset=0)
}

