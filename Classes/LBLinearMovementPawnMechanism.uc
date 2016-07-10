/**
 *  LBLinearMovementPawnMechanism
 *
 *  Creation date: 05.04.2016 21:08
 *  Copyright 2016, Windows7
 */
class LBLinearMovementPawnMechanism extends LBLinearMovementMechanism;

var(Animation) bool bAnimateMovement; //Should we animate movement via animtree
//var(Animation) array<name> BlendByMoveSpdNodes; //Which node to use for animating movement
var(Animation) float AnimMinSpeed; 
var(Animation) float AnimMaxSpeed;   
var(Animation) bool bAnimateRotation; //Should we animate rotation via animtree
//var(Animation) array<name> BlendByAngSpdNodes; //Which node to use for animating rotation 
var(Animation) float AnimBlendTime;

var array<AnimNodeBlend> blendbymovespd; //Animnode blending by move in the animtree
var array<LBBlendByAngSpeed> blendbyangspd; //Animnode blending by angspeed in the animtree

event OwnerTick(float deltatime)
{
    super.OwnerTick(deltatime);
    
    if(benabled==false)
        return;
    
    UpdateAnimNodes();
}

function FirstTickInit()
{
    local int i;
    local LBBlendByMovSpeed spd;
    local LBBlendByAngSpeed ang;
    
    if (bfirsttick==false)
        return;
    
    if (bfirsttick==true)
        bfirsttick=false;
        
    currot=parent.rotation.Yaw*UnrRotToDeg;    
     
    foreach LBPawn(parent).Mesh.AllAnimNodes(class'LBBlendByMovSpeed', spd)
    {
        if (spd!=none)
            blendbymovespd.AddItem(spd);
    }
    
    foreach LBPawn(parent).Mesh.AllAnimNodes(class'LBBlendByAngSpeed', ang)
    {
        if (ang!=none)
            blendbyangspd.AddItem(ang);
    }
    
    for (i=0;i<blendbymovespd.Length;i++)
    {
        LogInfo("BlendByMoveSpdNodes:");
        LogInfo(i@blendbymovespd[i]);
    }
    
    for (i=0;i<blendbyangspd.Length;i++)
    {
        LogInfo("BlendByAngSpdNodes:");
        LogInfo(i@blendbyangspd[i]);
    }
}

function PerformMovement(float dt)
{
    local vector v;
    local rotator r;
  
    r=rot(0,0,0);
    currot=currot+AngSpeed;
    
    r.yaw=currot*DegToUnrRot;
    parent.SetRotation(r);
    
    v=vect(0,0,0);
    
    if(bUSeLinearAcceleration)
    {
        curspeed=FInterpConstantTo(curspeed, FwdSpeed, dt, LinearAcceleration);
        v.x=curspeed;
    }
    else
    {
        curspeed=FwdSpeed;
        v.x=FwdSpeed;
    }
    
    v=v>>parent.rotation;
    
    v=v*kFwdSpeed;
    parent.Velocity=v;
    
    if (bShowDebugLines)
    parent.DrawDebugLine(parent.location+vect(0,0,25), parent.location+parent.Velocity*5+vect(0,0,25), 0, 255, 0);
    
        //LogError(v@r*unrrottodeg@"|"@FwdSpeed@AngSpeed);
    
}

function UpdateAnimNodes()
{
    local int i;
    
    for (i=0;i<blendbymovespd.Length;i++)
    {
        blendbymovespd[i].SetBlendTarget(FPctByRange(curspeed*kFwdSpeed, AnimMinSpeed, AnimMaxSpeed), AnimBlendTime);
    }
    
    for (i=0;i<blendbyangspd.Length;i++)
    {
        blendbyangspd[i].UpdateAngSpeed(AngSpeed);
    }
}

defaultproperties
{
    //BlendByAngSpdNodes(0)="BlendByAngularSpeed"
    //BlendByMoveSpdNodes(0)="BlendByMoveSpeed"
    
    AnimMinSpeed=0
    AnimMaxSpeed=250
    AnimBlendTime=0.1
}
