/**
 *  LBCharacterWalkMovementMechanism
 *
 *  Creation date: 24.05.2017 20:49
 *  Copyright 2017, Windows7
 */
class LBCharacterWalkMovementMechanism extends LBCharacterMovementMechanism;

var(CharacterWalkMovementControls) float ForwardSpeed;
var(CharacterWalkMovementControls) float kForwardSpeed;
var(CharacterWalkMovementControls) float StrafeSpeed;
var(CharacterWalkMovementControls) float kStrafeSpeed;
var(CharacterWalkMovementControls) float horAccelRate;
var(CharacterWalkMovementControls) float AngularSpeed;
var(CharacterWalkMovementControls) float kAngularSpeed;
var(CharacterWalkMovementControls) float JumpSpeed;
var(CharacterWalkMovementControls) float kJumpSpeed;
var(CharacterWalkMovementControls) float vertAccelRate;

var(CharacterWalkMovementSpecifications) float MaxFwdSpeed; //Maximum forward direct speed
var(CharacterWalkMovementSpecifications) float MaxStrSpeed; //Maximum strafe speed
var(CharacterWalkMovementSpecifications) float JumpHorizontalBoost; //A boost, which is given to pawns horizontal speed when it jumps (proportional to its current horizontal speed)
//var(CharacterWalkMovementInfo) float MaxJmpVelocity;

var(CharacterWalkMovementControls) rotator MoveDirection; //only Yaw component is used

var(Animation) float AnimBlendTime;
var(Animation) float RotationAnimThreshold;

var array<LBBlendByFwdSpeed> blendbyfwdspd;
var array<LBBlendByStrSpeed> blendbystrspd;
var array<LBBlendByAngSpeed> blendbyangspd; 

var SkelControlSingleBone bonerotcontroll;

var float curfwdspeed, curstrspeed, curangspeed, curjumpspeed;

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

function PerfromTick(float dt)
{
    super.PerfromTick(dt);
    
    UpdateAnimNodes();
}

function vector PerformPawnWalk(float dt)
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

    // Когда проседает фпс, приходится уменьшать горизонтальное ускорение
    if (bTickIndependent)
    {
        curfwdspeed=LinearInerpFloatValue(curfwdspeed,ForwardSpeed*kForwardSpeed,TickIndependentFloat(horAccelRate, dt, MovementTimeScale),dt);
        curstrspeed=LinearInerpFloatValue(curstrspeed,StrafeSpeed*kStrafeSpeed,TickIndependentFloat(horAccelRate, dt, MovementTimeScale),dt); 
    }
    else
    {
        curfwdspeed=LinearInerpFloatValue(curfwdspeed,ForwardSpeed*kForwardSpeed,horAccelRate,dt);
        curstrspeed=LinearInerpFloatValue(curstrspeed,StrafeSpeed*kStrafeSpeed,horAccelRate,dt);    
    }

    v=curfwdspeed*X+curstrspeed*Y;

    if (bShowDebugGraphics)
        DGDisplaySpeedVectors(curfwdspeed*X,curstrspeed*Y,vect(0,0,0));
       
    return v; 
}

function vector PerformPawnJump(float dt)
{
    local vector v;
    local rotator r;
    local vector X, Y, Z;

    v.X=0; 
    v.Y=0;   
    v.Z=JumpSpeed*kJumpSpeed; 
    
    return v;  
}
    
function vector PerformPawnFreeFall(float dt)
{
    local vector v;
    local rotator r;
    local vector X, Y, Z;
    
    v=pawn(parent).Velocity; //нахрена?
    v.Z=0;

    r=parent.Rotation;
    r.Pitch=0;
    r.Roll=0;

    GetAxes(r,X,Y,Z);

    if (bShowDebugGraphics)
        DGDisplayCoordinateSystem(X, Y, Z);

    if (bTickIndependent)
    {
        curfwdspeed=Clamp(LinearInerpFloatValue(curfwdspeed*JumpHorizontalBoost,0,TickIndependentFloat(horAccelRate, dt, MovementTimeScale),dt),0,ForwardSpeed*kForwardSpeed);
        curstrspeed=Clamp(LinearInerpFloatValue(curstrspeed*JumpHorizontalBoost,0,TickIndependentFloat(horAccelRate, dt, MovementTimeScale),dt),0,StrafeSpeed*kStrafeSpeed);
    }
    else
    {
        curfwdspeed=Clamp(LinearInerpFloatValue(curfwdspeed*JumpHorizontalBoost,0,horAccelRate,dt),0,ForwardSpeed*kForwardSpeed);
        curstrspeed=Clamp(LinearInerpFloatValue(curstrspeed*JumpHorizontalBoost,0,horAccelRate,dt),0,StrafeSpeed*kStrafeSpeed);    
    }

    curjumpspeed=LinearInerpFloatValue(curjumpspeed,0,TickIndependentFloat(vertAccelRate, dt, MovementTimeScale),dt); 
    
    v=curfwdspeed*X+curstrspeed*Y+curjumpspeed*Z; //может быть тут Z зависит от поверхности?
    
    if (bShowDebugGraphics)
        DGDisplaySpeedVectors(curfwdspeed*X,curstrspeed*Y,vect(0,0,0));
        DGDisplaySpeedVectors(vect(0,0,0),vect(0,0,0),curjumpspeed*Z);
       
    return v;     
}

function PerformMovement(float dt) 
{
    local vector vhor,vvert;
    local vector resvel;
    
    if (LBActor(parent)!=none)
    {

    }
    else if (LBPawn(parent)!=none)
    {
        if (parent.base!=none)
        {
            //handle pawn walk
            vhor=PerformPawnWalk(dt);
            //handle pawn jump
            vvert=PerformPawnJump(dt); 
            
            //if the pawn has jumped
            if (vsize(vvert)!=0)
            {
                parent.SetPhysics(PHYS_Falling); 
                curjumpspeed=JumpSpeed*kJumpSpeed;  //set jump meter to max
                //vhor=vhor*JumpHorizontalBoost;  
            }
            
            parent.Velocity=vhor+vvert;    
        }
        else
        {
            //handle pawn free fall
            vhor=PerformPawnFreeFall(dt); 
            parent.Velocity=vhor+vvert; 
        }     
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
        if (parent.base!=none)
        {
            tyaw=NormalizeRotAxis(MoveDirection.Yaw)*unrrottodeg;
            
            if (tyaw<0)
                tyaw=tyaw+360;
            
            cyaw=currot;
            
            if (cyaw<0)
                cyaw=cyaw+360;
            
            yaw=LinearInterpAngle(cyaw,tyaw,TickIndependentFloat(AngularSpeed*kAngularSpeed,dt,RotationTimeScale),dt);

            curangspeed=cyaw-yaw;
            
            currot=yaw;
            
            //if (abs(curangspeed)<abs(RotationAnimThreshold))
            //    curangspeed=0;
            //LogInfo("cyaw:"@cyaw@"tyaw:"@tyaw@"curangspeed:"@curangspeed);

            dr=parent.Rotation;
            
            dr.Yaw=yaw*degtounrrot;
            
            if (bShowDebugGraphics)
                DGDisplayOrientation(MoveDirection);
            
            parent.SetRotation(dr);   
        }
        else
        {
            dr=parent.Rotation;
            dr.Yaw=currot*degtounrrot;   
            parent.SetRotation(dr); 
        }
    }
    else if (LBSMPhysicsActor(parent)!=none)
    {
            
    }    
}

function PreserveRotation(float dt)
{
    local rotator dr;

    dr=parent.Rotation;
            
    dr.Yaw=currot*degtounrrot; 
 
    parent.SetRotation(dr);   
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
    //`log(mechname$":"$param$"<-"$value);
    super.SetParamBool(param,value,priority);
    
    if (param=='bEnableMovement')
        bEnableMovement=value;
    else if (param=='bEnableRotation')
        bEnableRotation=value;
    else if (param=='ResetMoveDirection')
    {
        if (value)
            MoveDirection=parent.Rotation;    
    }
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
    else
        return super.GetParamFloat(param);
}    
    
function SetParamFloat(name param, float value, optional int priority=0)
{
    //`log(param@"->"@value);
    
    super.SetParamFloat(param, value, priority);
    
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
    super.SetParamRotator(param, value, priority);
    
    if (param=='MoveDirection' || param=='MoveDir')
        MoveDirection=value;    
}

function SetParamVector(name param, vector value, optional int priority=0)
{    
    super.SetParamVector(param, value, priority);
    
    if (param=='MoveDirection' || param=='MoveDir')
    {
        MoveDirection=Rotator(value);        
    } 
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
    JumpHorizontalBoost=1.5
    
    JumpSpeed=250.0
    
    horAccelRate=15.0
    vertAccelRate=15.0
    
    kForwardSpeed=0.0
    kAngularSpeed=0.0
    kJumpSpeed=0.0
      
    AnimBlendTime=0.8
    RotationAnimThreshold=2.3
    RotationSkelControlMin=-35;
    RotationSkelControlMax=35;   

    MechanismParams.Add((ParamName="ForwardSpeed", ParamType=ParamType_Float, ParamInfo="Float. Read, write. Sets the forward speed."))
    MechanismParams.Add((ParamName="kForwardSpeed", ParamType=ParamType_Float, ParamInfo="Float. Read, write. Sets the @kforward speed."))
    MechanismParams.Add((ParamName="StrafeSpeed", ParamType=ParamType_Float, ParamInfo="Float. Read, write. Sets the @StrafeSpeed speed."))
    MechanismParams.Add((ParamName="kStrafeSpeed", ParamType=ParamType_Float, ParamInfo="Float. Read, write. Sets the @kStrafeSpeed speed."))
    MechanismParams.Add((ParamName="JumpSpeed", ParamType=ParamType_Float, ParamInfo="Float. Read, write. Sets the @JumpSpeed speed."))
    MechanismParams.Add((ParamName="kJumpSpeed", ParamType=ParamType_Float, ParamInfo="Float. Read, write. Sets the @kSJumpSpeed speed."))
    MechanismParams.Add((ParamName="MoveDirection", ParamType=ParamType_Rotator, ParamInfo="Rotator. Read, write. Sets the @MoveDirection value."))
    MechanismParams.Add((ParamName="MoveDirectionYaw", ParamType=ParamType_Float, ParamInfo="Float. Read, write. Sets the @MoveDirection Yaw component."))
    MechanismParams.Add((ParamName="MoveDirectionPitch", ParamType=ParamType_Float, ParamInfo="Float. Read, write. Sets the @MoveDirection Pitch component.")) 
    MechanismParams.Add((ParamName="MoveDirectionRoll", ParamType=ParamType_Float, ParamInfo="Float. Read, write. Sets the @MoveDirection Roll component.")) 
    MechanismParams.Add((ParamName="ResetMoveDirection", ParamType=ParamType_Boolean, ParamInfo="Boolean. Write. Set TRUE to reset @MoveDirection to @Rotation of parent."))
    
    ParamSource.Add((ParamName="ForwardSpeed"))
    ParamSource.Add((ParamName="kForwardSpeed"))
    ParamSource.Add((ParamName="StrafeSpeed"))
    ParamSource.Add((ParamName="kStrafeSpeed"))
    ParamSource.Add((ParamName="JumpSpeed"))
    ParamSource.Add((ParamName="kJumpSpeed"))
    ParamSource.Add((ParamName="MoveDirection"))
    ParamSource.Add((ParamName="MoveDirectionYaw"))
    ParamSource.Add((ParamName="MoveDirectionPitch"))
    ParamSource.Add((ParamName="MoveDirectionRoll"))
}
