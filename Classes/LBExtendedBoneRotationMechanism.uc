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
    local rotator r,rp,rd;
    local float f1,f2;
    
    //GetAxes(ResolveRotator(currot,RotatorResolver(RotationAxes_Pitch,RotationAxes_Roll,RotationAxes_Yaw,,,true))+parent.Rotation,X,Y,Z);
    //    parent.drawDebugLine(parent.Location+vect(0,0,128),parent.Location+vect(0,0,128)+X*64,255,0,0);
    //    parent.drawDebugLine(parent.Location+vect(0,0,128),parent.Location+vect(0,0,128)+Y*64,0,255,0);
    //    parent.drawDebugLine(parent.Location+vect(0,0,128),parent.Location+vect(0,0,128)+Z*64,0,0,255);
    //    v=LookAtActor.Location.X*X+LookAtActor.Location.Y*Y+LookAtActor.Location.Z*Z;
    //    parent.DrawDebugSphere(v,8,8,0,128,128);
    
    if (BehaviorMode==BoneBehaviorModes_LookAtPoint)
    {
        //v=parent.Location-LookAtPoint;
        //r=rotator(v)-parent.Rotation;
        ////`log("r.Yaw"@r.Yaw*unrrottodeg@"r.Pitch"@r.Pitch*unrrottodeg@"r.Roll"@r.Roll*unrrottodeg);
        ////TargetRotation=r+currot;  
        //TargetRotation.Pitch=r.Yaw;       
        //        //`log("currot="@currot*UnrRotToDeg);
        // 
    }    
    else if (BehaviorMode==BoneBehaviorModes_LookAtActor)
    {
        v=LookAtActor.Location-parent.location;
        r=rotator(v);
        r.Yaw=NormalizeRotAxis(r.Yaw);
        //`log(NormalizeRotAxis(r.Yaw)*unrrottodeg@"|"@NormalizeRotAxis(parent.rotation.Yaw)*unrrottodeg);
        f1=NormalizeRotAxis(parent.rotation.Yaw-75*degtounrrot);
        f2=NormalizeRotAxis(parent.rotation.Yaw+75*degtounrrot);
        //`log(NormalizeRotAxis(parent.rotation.Yaw)*unrrottodeg@"|"@f1*unrrottodeg@"<"@r.Yaw*unrrottodeg@"<"@f2*unrrottodeg@"="@fclamp(r.Yaw,min(f1,f2),max(f1,f2))*unrrottodeg);
        
        if (0<=f1*unrrottodeg && f1*unrrottodeg<=180)
        {
            if (0<=f2*unrrottodeg && f2*unrrottodeg<=180)
            {
                //`log("r="@r.Yaw*unrrottodeg@"f1="@f1*unrrottodeg@"f2="@f2*unrrottodeg@"res="@fclamp(r.Yaw,min(f1,f2),max(f1,f2))*unrrottodeg);
                `log("case 1");
                r.Yaw=fclamp(r.Yaw,min(f1,f2),max(f1,f2));    
            }
            else
            {
               // `log("case 2");
                 //`log("r="@r.Yaw*unrrottodeg@"f1="@f1*unrrottodeg@"f2="@f2*unrrottodeg);
                if (!((f1<=r.Yaw && r.Yaw<=180*degtounrrot) || (-180*degtounrrot<=r.Yaw && r.Yaw<=f2)))
                {
                    if (abs(r.Yaw-f1) < abs(r.Yaw-f2))
                        r.Yaw=f1;
                    else
                        r.Yaw=f2;
                }        
                //`log("res="@r.Yaw*unrrottodeg);    
                //r.Yaw=fclamp(r.Yaw,f1,f2+360*degtounrrot);       
            }
        }
        else
        {
            //`log("case 3");
            //`log("r="@r.Yaw*unrrottodeg@"f1="@f1*unrrottodeg@"f2="@f2*unrrottodeg);
            if (0<=f2*unrrottodeg && f2*unrrottodeg<=180) 
            {
                if (f2<r.Yaw && r.Yaw<=180*degtounrrot)
                {
                    if ((180*degtounrrot-r.Yaw)+(f1-(-180)*degtounrrot) < r.Yaw-f2)    
                        r.Yaw=f1; 
                    else 
                        r.Yaw=f2;       
                }
                    
                if (-180*degtounrrot<=r.Yaw && r.Yaw<f1)
                {
                    if (r.Yaw-f1 < (r.Yaw-(-180)*degtounrrot)+(180*degtounrrot-f2))    
                        r.Yaw=f1; 
                    else 
                        r.Yaw=f2;    
                }
                    `log("res="@r.Yaw*unrrottodeg);
            }
            else
            {
                `log("case 4");
                r.Yaw=fclamp(r.Yaw,min(f1,f2),max(f1,f2));
            }
            //r.Yaw=parent.rotation.Yaw;     
        }
        
        //r.Yaw=fclamp(r.Yaw,min(f1,f2),max(f1,f2));
        //r.Yaw=ClampRotAxisFromRange(NormalizeRotAxis(r.Yaw),int(f1),int(f2));
        rd=rot(0,0,0); rd.Yaw=f1;
        parent.DrawDebugLine(parent.Location+vect(0,0,96),parent.Location+vect(0,0,96)+vector(rd)*64,128,128,128);
        rd=rot(0,0,0); rd.Yaw=f2;

        //parent.DrawDebugLine(parent.Location+vect(0,0,96),parent.Location+vect(0,0,96)+vector(parent.Rotation-rot(0,45,0)*degtounrrot)*64,128,128,128);
        //r.Yaw=fclamp(r.Yaw,parent.Rotation.Yaw-45*degtounrrot,parent.Rotation.Yaw+45*degtounrrot);
        ////r=ResolveRotator(currot,RotatorResolver(RotationAxes_Pitch,RotationAxes_Roll,RotationAxes_Yaw,,,true))+parent.Rotation-rotator(v);
        //
        //r=ResolveRotator(currot,RotatorResolver(RotationAxes_Pitch,RotationAxes_Roll,RotationAxes_Yaw,,,true));
        //
        //GetAxes(r+parent.Rotation,X,Y,Z);
        //parent.drawDebugLine(parent.Location+vect(0,0,128),parent.Location+vect(0,0,128)+X*64,128,0,0);
        //parent.drawDebugLine(parent.Location+vect(0,0,128),parent.Location+vect(0,0,128)+Y*64,0,128,0);
        //parent.drawDebugLine(parent.Location+vect(0,0,128),parent.Location+vect(0,0,128)+Z*64,0,0,128);
        //
        /////parent.drawDebugLine(parent.Location+vect(0,0,128),parent.Location+vect(0,0,128)+vector(parent.Rotation+(parent.Rotation-rotator(v)))*64,255,255,255);
        //r=rotator(v);
        
        //v=LookAtActor.Location-parent.Location;
        //r=parent.rotation-rotator(v);
        //r=rotator(v)-parent.Rotation;
        //r=ResolveRotator(r,RotatorResolver(RotationAxes_Pitch,RotationAxes_Roll,RotationAxes_Yaw,,,true));
        //TargetRotation=r;  
        
    //if (bTranslateFromDegToUnrrot)
    //    TargetRotation=TargetRotation*UnrRotToDeg; 
        
        //`log("r.Yaw"@r.Yaw*unrrottodeg@"r.Pitch"@r.Pitch*unrrottodeg@"r.Roll"@r.Roll*unrrottodeg);
        //`log("bonerotation"@bonecontroller.BoneRotation);
        
        //`log(r*unrrottodeg);

        //return ClampRotator(r*unrrottodeg);
        //r=ResolveRotator(r,RotatorResolver(RotationAxes_Roll,RotationAxes_Yaw,RotationAxes_Pitch,,,true));
        // r.Pitch=r.Yaw; r.Roll=0; r.Yaw=0;
        
        //r=NormalizeDegRot(r*unrrottodeg);
        //r.Yaw=r.Yaw % 360;
        //r.Pitch=r.Pitch % 360;
        //r.Roll=r.Roll % 360;
        //r.Pitch=NormalizeDegAngle(r.Yaw-(parent.Rotation*unrrottodeg).Yaw) -- РАБОТАЕТ
        
        r.Pitch=r.Yaw-parent.Rotation.Yaw; r.Roll=0; r.Yaw=0;
        //`log(r.Pitch*unrrottodeg@"Min:"@((NormalizeRotAxis(parent.Rotation.Yaw)-NormalizeRotAxis(rot(0,45,0)*degtounrrot).Yaw))*unrrottodeg@"Max:"@((NormalizeRotAxis(parent.Rotation.Yaw)+NormalizeRotAxis(rot(0,45,0)*degtounrrot).Yaw))*unrrottodeg);
        //`log(NormalizeRotAxis(r.Pitch)*unrrottodeg@"|"@NormalizeRotAxis(parent.Rotation.Yaw)*unrrottodeg);
        //r.Pitch=fclamp(r.Pitch,parent.Rotation.Pitch-45*degtounrrot,parent.Rotation.Pitch+45*degtounrrot);
        //parent.DrawDebugLine(parent.Location+vect(0,0,96),parent.Location+vect(0,0,96)+vector(parent.Rotation-rot(0,45,0)*degtounrrot)*64,128,128,128);
        //parent.DrawDebugLine(parent.Location+vect(0,0,96),parent.Location+vect(0,0,96)+vector(parent.Rotation+rot(0,45,0)*degtounrrot)*64,128,128,128);
        //parent.DrawDebugLine(parent.Location+vect(0,0,96),parent.Location+vect(0,0,96)+vector(r+parent.Rotation)*64,255,0,0);
        //`log(r@" | "@parent.Rotation*unrrottodeg);
        return r;  
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
