/**
 *  LBCharacterWalkMovementMechanism
 *
 *  Creation date: 24.05.2017 20:49
 *  Copyright 2017, Windows7
 */
class LBCharacterWalkMovementMechanism extends LBCharacterMovementMechanism;

var(CharacterWalkMovement) float ForwardSpeed;
var(CharacterWalkMovement) float kForwardSpeed;
var(CharacterWalkMovement) float StrafeSpeed;
var(CharacterWalkMovement) float kStrafeSpeed;
var(CharacterWalkMovement) float AccelRate;
var(CharacterWalkMovement) float AngularSpeed;
var(CharacterWalkMovement) float kAngularSpeed;
var(CharacterWalkMovement) float JumpSpeed;
var(CharacterWalkMovement) float kJumpSpeed;

var(CharacterWalkMovementInfo) float MaxFwdSpeed;
var(CharacterWalkMovementInfo) float MaxStrSpeed;
//var(CharacterWalkMovementInfo) float MaxJmpVelocity;

var(CharacterWalkMovement) rotator MoveDirection; //only Yaw component is used

var(Animation) float AnimBlendTime;
var(Animation) float RotationAnimThreshold;

var array<LBBlendByFwdSpeed> blendbyfwdspd;
var array<LBBlendByStrSpeed> blendbystrspd;
var array<LBBlendByAngSpeed> blendbyangspd; 

var float curfwdspeed, curstrspeed, curangspeed;

var float currot;

function InitMechanism()
{
    if (LBPawn(parent)!=none)
        InitAnims();  
         
    EnableMechanism();    
}

function EnableMechanism()
{  
    LogInfo("Mechanism enabled..");
    
    currot=NormalizeRotAxis(parent.Rotation.Yaw)*unrrottodeg;
        
    if (currot<0)
        currot=currot+360;
    
    if (currot>0)
        currot=currot-360;    
}    
    
function InitAnims()
{
    local LBBlendByFwdSpeed fwdspd;
    local LBBlendByStrSpeed strspd;
    local LBBlendByAngSpeed angspd;
    
    local int i;
    
    LogInfo("Blend by forward speed nodes:");

    i=0;
    
    foreach LBPawn(parent).Mesh.AllAnimNodes(class'LBBlendByFwdSpeed', fwdspd)
    {
        if (fwdspd!=none)
        {
            i++;
            LogInfo(i@":"@fwdspd);
            blendbyfwdspd.AddItem(fwdspd);
        }
               
    }
    
    if (i==0)
        LogInfo("None found...");
    
    LogInfo("Blend by strafe speed nodes:");

    i=0;
    
    foreach LBPawn(parent).Mesh.AllAnimNodes(class'LBBlendByStrSpeed', strspd)
    {
        if (strspd!=none)
        {
            i++;
            LogInfo(i@":"@strspd);
            blendbystrspd.AddItem(strspd);
        }
               
    }
    
    if (i==0)
        LogInfo("None found...");
    
    LogInfo("Blend by angular speed nodes:");
    
    i=0;
    
    foreach LBPawn(parent).Mesh.AllAnimNodes(class'LBBlendByAngSpeed', angspd)
    {
        if (angspd!=none)
        {
            i++;
            LogInfo(i@":"@angspd);
            blendbyangspd.AddItem(angspd);
        }
    }  
  
    if (i==0)
        LogInfo("None found...");  
}

function PerformTick(float dt)
{
    super.PerformTick(dt);
    
    UpdateAnimNodes();
}

function float LinearInerpFloatValue(float current, float target, float step, float dt)
{
    local float value;
    
    if (abs(current - target) > abs(step))
    {
        if (current < target)
            value=current+abs(step); 
        else
            value=current-abs(step);   
    }
    else
    {
        if (current < target)
            value=current+abs(current - target); 
        else
            value=current-abs(current - target);      
    }
        
     return value;
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

function vector PerformPawnHorizontalMove(float dt)
{
    local vector v;
    local rotator r;
    local vector X, Y, Z;
    
    v=pawn(parent).Velocity;
    v.Z=0;

    r=parent.Rotation;
    r.Pitch=0;
    r.Roll=0;

    GetAxes(r,X,Y,Z);

    if (bShowDebugGraphics)
        DGDisplayCoordinateSystem(X, Y, Z);

    //curfwdspeed=FInterpTo(curfwdspeed,ForwardSpeed*kForwardSpeed,dt,AccelRate);
    //curstrspeed=FInterpTo(curstrspeed,StrafeSpeed*kStrafeSpeed,dt,AccelRate);

    curfwdspeed=LinearInerpFloatValue(curfwdspeed,ForwardSpeed*kForwardSpeed,AccelRate,dt);
    curstrspeed=LinearInerpFloatValue(curstrspeed,StrafeSpeed*kStrafeSpeed,AccelRate,dt);

    v=curfwdspeed*X+curstrspeed*Y;

    if (bShowDebugGraphics)
        DGDisplaySpeedVectors(curfwdspeed*X,curstrspeed*Y,vect(0,0,0));
       
    return v; 
}

function vector PerformPawnVerticalMove(float dt)
{
    local vector v;
    local rotator r;
    local vector X, Y, Z;

    v.X=0; 
    v.Y=0;   
    v.Z=JumpSpeed*kJumpSpeed; 
    
    return v;  
}
    
function PerformMovement(float dt) 
{
    local vector vhor,vvert;
    
    if (LBActor(parent)!=none)
    {

    }
    else if (LBPawn(parent)!=none)
    {
        if (parent.base!=none)
        {
            vhor=PerformPawnHorizontalMove(dt);
            
            vvert=PerformPawnVerticalMove(dt); 
            
            if (vsize(vvert)!=0)
                parent.SetPhysics(PHYS_Falling);
            
            `log(vvert); 
        }
        parent.Velocity=vhor+vvert;       
    }
    else if (LBSMPhysicsActor(parent)!=none)
    {
        
    }
}

function PerformRotation(float dt)
{ 
    local rotator dr;
    local float cyaw,tyaw,yaw;
    
    if (LBActor(parent)!=none)
    {
        
    }
    else if (LBPawn(parent)!=none)
    {
        tyaw=NormalizeRotAxis(MoveDirection.Yaw)*unrrottodeg;
        
        if (tyaw<0)
            tyaw=tyaw+360;
        
        cyaw=currot;
        
        if (cyaw<0)
            cyaw=cyaw+360;
        
        yaw=LinearInterpAngle(cyaw,tyaw,AngularSpeed*kAngularSpeed,dt);
       
        currot=yaw;
        curangspeed=cyaw-yaw;
        
        //if (abs(curangspeed)<abs(RotationAnimThreshold))
        //    curangspeed=0;
        LogInfo("cyaw:"@cyaw@"tyaw:"@tyaw@"curangspeed:"@curangspeed);

        dr=parent.Rotation;
        dr.Yaw=yaw*degtounrrot;
        
        if (bShowDebugGraphics)
            DGDisplayOrientation(MoveDirection);
        
        parent.SetRotation(dr);
    }
    else if (LBSMPhysicsActor(parent)!=none)
    {
            
    }    
}

function UpdateAnimNodes()
{
    local int i;
    
    for (i=0;i<blendbyfwdspd.Length;i++)
    {
        blendbyfwdspd[i].SetBlendTarget(FPctByRange(abs(curfwdspeed), 0, MaxFwdSpeed), AnimBlendTime);
    }
    
    for (i=0;i<blendbystrspd.Length;i++)
    {
        blendbystrspd[i].SetBlendTarget(FPctByRange(abs(curstrspeed), 0, MaxStrSpeed), AnimBlendTime);
    }
    
    for (i=0;i<blendbyangspd.Length;i++)
    {
        blendbyangspd[i].UpdateAngSpeed(curangspeed);
    }
}

function SetParamBool(name param, bool value, optional int priority=0) 
{
    super.SetParamBool(param,value,priority);
    
    if (param=='bEnableMovement')
        bEnableMovement=value;
    else if (param=='bEnableRotation')
        bEnableRotation=value;
}

function float GetParamFloat(name param)
{
    if (param=='ForwardSpeed' || param=='FwdSpeed')
        return ForwardSpeed;
    else if (param=='kForwardSpeed' || param=='kFwdSpeed')
        return kForwardSpeed; 
    else if (param=='kAngularSpeed' || param=='kAngSpeed')
        return kAngularSpeed; 
    else if (param=='kStrafeSpeed' || param=='kStrSpeed')
        return kStrafeSpeed;    
    else if (param=='MoveDirectionYaw' || param=='MoveDirection-Yaw' || param=='MoveDir-Yaw')
        return MoveDirection.Yaw;  
    else if (param=='MoveDirectionPitch' || param=='MoveDirection-Pitch' || param=='MoveDir-Pitch')
        return MoveDirection.Pitch;
    else if (param=='MoveDirectionRoll' || param=='MoveDirection-Roll' || param=='MoveDir-Roll')
        return MoveDirection.Roll;  
}    
    
function SetParamFloat(name param, float value, optional int priority=0)
{
    //`log(param@"->"@value);
    
    if (param=='ForwardSpeed' || param=='FwdSpeed')
        ForwardSpeed=value;
    else if (param=='kForwardSpeed' || param=='kFwdSpeed')
        kForwardSpeed=value;
    else if (param=='AngularSpeed' || param=='AngSpeed')
        AngularSpeed=value;    
    else if (param=='kAngularSpeed' || param=='kAngSpeed')
        kAngularSpeed=value;  
    else if (param=='kStrafeSpeed' || param=='kStrSpeed')
        kStrafeSpeed=value; 
    else if (param=='JumpSpeed' || param=='JmpSpeed')
        JumpSpeed=value;
    else if (param=='kJumpSpeed' || param=='kJmpSpeed')
        kJumpSpeed=value;   
    else if (param=='MoveDirectionYaw' || param=='MoveDirection-Yaw' || param=='MoveDir-Yaw')
        MoveDirection.Yaw=value; 
    else if (param=='MoveDirectionPitch' || param=='MoveDirection-Pitch' || param=='MoveDir-Pitch')
        MoveDirection.Pitch=value; 
    else if (param=='MoveDirectionRoll' || param=='MoveDirection-Roll' || param=='MoveDir-Roll')
        MoveDirection.Roll=value;
} 
 
function SetParamRotator(name param, rotator value, optional int priority=0)
{
    if (param=='MoveDirection' || param=='MoveDir')
        MoveDirection=value;    
}    
  
function DGDisplayCoordinateSystem(vector X, vector Y, vector Z)
{
    parent.DrawDebugLine(parent.Location+vect(0,0,32),parent.Location+(X*100)+vect(0,0,32),100,0,0);
    parent.DrawDebugLine(parent.Location+vect(0,0,32),parent.Location+(Y*100)+vect(0,0,32),0,100,0);
    parent.DrawDebugLine(parent.Location+vect(0,0,32),parent.Location+(Z*100)+vect(0,0,32),0,0,100); 
} 

function DGDisplaySpeedVectors(vector X, vector Y, vector Z)
{
    parent.DrawDebugLine(parent.Location+vect(0,0,64),parent.Location+vect(0,0,64)+X,255,0,0);
    parent.DrawDebugLine(parent.Location+vect(0,0,64),parent.Location+vect(0,0,64)+Y,0,255,0);    
}

function DGDisplayOrientation(rotator r)
{
    parent.DrawDebugLine(parent.Location+vect(0,0,48),parent.Location+vect(0,0,48)+vector(r)*64,0,128,128); 
}  
    
defaultproperties
{
    mechname="Char_Walk_Mechanism"
    
    bRotateFirst=true 
   
    MaxFwdSpeed=250.0
    MaxStrSpeed=250.0
    JumpSpeed=250.0
    
    kForwardSpeed=0.0
    kAngularSpeed=1.0
    kJumpSpeed=0.0
  
    AnimBlendTime=0.8
    RotationAnimThreshold=2.3
    
    MechanismParams.Empty    

    MechanismParams(0)=(ParamName="ForwardSpeed", ParamType=ParamType_Float, ParamInfo="Float. Read, write. Sets the forward speed.")
    MechanismParams(1)=(ParamName="kForwardSpeed", ParamType=ParamType_Float, ParamInfo="Float. Read, write. Sets the @kforward speed.") 
    MechanismParams(2)=(ParamName="StrafeSpeed", ParamType=ParamType_Float, ParamInfo="Float. Read, write. Sets the @StrafeSpeed speed.")
    MechanismParams(3)=(ParamName="kStrafeSpeed", ParamType=ParamType_Float, ParamInfo="Float. Read, write. Sets the @kStrafeSpeed speed.") 
    MechanismParams(4)=(ParamName="JumpSpeed", ParamType=ParamType_Float, ParamInfo="Float. Read, write. Sets the @JumpSpeed speed.")
    MechanismParams(5)=(ParamName="kJumpSpeed", ParamType=ParamType_Float, ParamInfo="Float. Read, write. Sets the @kSJumpSpeed speed.")
    MechanismParams(6)=(ParamName="MoveDirection", ParamType=ParamType_Rotator, ParamInfo="Rotator. Read, write. Sets the @MoveDirection value.")
    MechanismParams(7)=(ParamName="MoveDirectionYaw", ParamType=ParamType_Float, ParamInfo="Float. Read, write. Sets the @MoveDirection Yaw component.")
    MechanismParams(8)=(ParamName="MoveDirectionPitch", ParamType=ParamType_Float, ParamInfo="Float. Read, write. Sets the @MoveDirection Pitch component.") 
    MechanismParams(9)=(ParamName="MoveDirectionRoll", ParamType=ParamType_Float, ParamInfo="Float. Read, write. Sets the @MoveDirection Roll component.") 
    
    ParamSource(0)=(ParamName="ForwardSpeed")
    ParamSource(1)=(ParamName="kForwardSpeed")
    ParamSource(2)=(ParamName="StrafeSpeed")
    ParamSource(3)=(ParamName="kStrafeSpeed")
    ParamSource(4)=(ParamName="JumpSpeed")
    ParamSource(5)=(ParamName="kJumpSpeed")
    ParamSource(6)=(ParamName="MoveDirection")
    ParamSource(7)=(ParamName="MoveDirectionYaw")
    ParamSource(8)=(ParamName="MoveDirectionPitch")
    ParamSource(9)=(ParamName="MoveDirectionRoll")
}
