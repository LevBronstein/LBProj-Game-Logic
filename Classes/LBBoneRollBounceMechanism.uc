/**
 *  LBBoneRollBounceMechanism
 *
 *  Creation date: 11.03.2017 19:46
 *  Copyright 2017, Windows7
 */
class LBBoneRollBounceMechanism extends LBBoneRollMechanism;

struct BounceMoment
{
    var() float Angle;
    var() float Area;  
    var() vector Offset;  
};

var(BoneRollBounceMechanism) array<BounceMoment> BounceMoments;
var(BoneRollBounceMechanism) vector BaseOffset;

function PerfromTick(float dt)
{   
    super.PerfromTick(dt);
    
    PerformMovement(dt);     
}

function PerformMovement(float dt)
{
    local int i;
    local float drot;
    local bool b;
    
    if (bonecontroller!=None)
    {
        if (RollAxis==RollAxis_Yaw)
            drot=bonecontroller.BoneRotation.Yaw*UnrRotToDeg;
        if (RollAxis==RollAxis_Pitch)
            drot=bonecontroller.BoneRotation.Pitch*UnrRotToDeg;
        if (RollAxis==RollAxis_Roll)
            drot=bonecontroller.BoneRotation.Roll*UnrRotToDeg;
    } 

    if (drot>360)
        drot=drot%360;
        
    b=false;
    
    `log(drot);
    
    for (i=0; i<BounceMoments.Length; i++)
    {
        if (abs(drot-BounceMoments[i].Angle) < BounceMoments[i].Area) 
        {
            //`log("!!!");
            bonecontroller.BoneTranslation=BounceMoments[i].Offset;      
            b=true;
        }   
    } 
 
    if (b==false)
    {
        bonecontroller.BoneTranslation=BaseOffset;        
    }   
}

defaultproperties
{
    mechname="Bone_Roll_Bounce_Mechanism"    
}

