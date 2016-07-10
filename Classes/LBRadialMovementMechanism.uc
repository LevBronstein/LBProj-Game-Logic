/**
 *  LBRadialMovementMechanism
 *
 *  Creation date: 04.07.2016 22:52
 *  Copyright 2016, Windows7
 */
class LBRadialMovementMechanism extends LBInteractableMechanism;

var(RadialMovement) vector CenterPoint; //A point which is used as a center for rotation
var(RadialMovement) float CenterDistance; //A value which is used to calculate an offset from the center point
var(RadialMovement) rotator AngSpeed; //Angular speed turns right or left if <0
var(RadialMovement) float kAngSpeed; //Coefficient that modifies the AngSpeed: k*AngSpeed
var(RadialMovement) float FwdSpeed; //Forward speed, moves forward or backward if <0
var(RadialMovement) float kFwdSpeed; //Coefficient that modifies the FwdSpeed: k*FwdSpeed

var(MechanismDebug) bool bShowDebugLines;

var(MovementClamps) float DistanceToStop;
var(MovementClamps) bool bEnableMovement; //set to true to enable movement
var(MovementClamps) bool bEnableRotation; //set to true to enable rotation

var(ParamSource) LBParamSourcePointer bEnableMovementSrc;
var(ParamSource) LBParamSourcePointer bEnableRotationSrc;

var rotator currot;
var float curspeed;
var vector curtrajpoint;

function FirstTickInit()
{
    if (bfirsttick==false)
        return;
    
    if (bfirsttick==true)
        bfirsttick=false;   
}

event OwnerTick(float deltatime)
{
     FirstTickInit();
    
    if(benabled==false)
        return;
        
    if (bUseParamSource)
        GetParameters();
       
    UpdateTrajectory(); //строим идеальную траекторию
    
    PerformMovement(deltatime);  //производим непосредственное движение 
}

function UpdateTrajectory()
{
    local vector v;
    
    v=vect(1,0,0)*CenterDistance;
    v=v<<currot;
    curtrajpoint=v+CenterPoint; //точка на идеальной траектории 
    currot=currot+AngSpeed*DegToUnrRot*kAngSpeed;
    
    if (bShowDebugLines)
    {
        parent.DrawDebugSphere(curtrajpoint, 64, 16, 255, 0, 0);
        parent.DrawDebugLine(parent.location+vect(0,0,32), curtrajpoint, 255, 0, 0);
    }
}

function PerformMovement(float deltatime)
{
    local vector v;
    local vector offset;
    
    if (!bEnableMovement)
        return;
    
    v=curtrajpoint-parent.location;
    
    if (VSize(v) >= DistanceToStop)
    {
        offset=(normal(v)*FwdSpeed*kFwdSpeed);
        
        parent.MoveSmooth(offset);
    }
}

function GetParameters()
{
    if (bEnableMovementSrc.bUseSource)
    {
        bEnableMovement=GetTargetParamBool(bEnableMovementSrc.SourceActor, bEnableMovementSrc.SourceMechanismName, bEnableMovementSrc.SourceParamName);
    }
    
    if (bEnableRotationSrc.bUseSource)
    {
        bEnableRotation=GetTargetParamBool(bEnableRotationSrc.SourceActor, bEnableRotationSrc.SourceMechanismName, bEnableRotationSrc.SourceParamName);
    }
}

function SetParamBool(name param, bool value, optional int priority=0) 
{
    if (param=='bEnabled')
        benabled=value;
}

defaultproperties
{
    mechname="Radial_Movement_Mechanism"
    
    kFwdSpeed=1.0;
    kAngSpeed=1.0;
    
    DistanceToStop=4.0
    
    bEnableMovement=true
    bEnableRotation=true
}
