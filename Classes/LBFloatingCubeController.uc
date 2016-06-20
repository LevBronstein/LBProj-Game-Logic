/**
 *  LBFloatingCubeController
 *
 *  Creation date: 20.06.2016 00:49
 *  Copyright 2016, Windows7
 */
class LBFloatingCubeController extends LBActorInteractableController;

var() bool bGrouped;

var(ParamSource) LBParamSourcePointer TargetLocationSrc;
var() vector TargetLocation;
var(ParamSource) LBParamSourcePointer ForwardSpeedSrc;
var() float ForwardSpeed;

var() Actor leader;

function FirstTickInit()
{
    if (bfirsttick==false)
        return;
    
    if (bfirsttick==true)
        bfirsttick=false;   
}

event OwnerTick(float deltatime)
{
    super.OwnerTick(deltatime);
    
    if (benabled==false)
        return;       
} 
  
function PerformTick(float deltatime)
{
    
}
   
function ChangeGrouped(bool value)
{
    bGrouped=value;
} 

function ChangeLeader(object value)
{
    leader=actor(value); 
   
}  
  
function GetParameters()
{
    if (TargetLocationSrc.bUseSource)
    {
        if (leader!=none)
        {
            //заменяем TargetLocation.SourceActor на leader
            if (LBActor(leader)!=none  || LBPawn(leader)!=none || LBDynamicActor(leader)!=none)
            {
                TargetLocation=GetTargetParamVector(leader, TargetLocationSrc.SourceMechanismName, TargetLocationSrc.SourceParamName);
            }   
            else
            {
                if (leader!=none)
                    TargetLocation=leader.location;
            } 
        }
        else
        {
            TargetLocation=GetTargetParamVector(TargetLocationSrc.SourceActor, TargetLocationSrc.SourceMechanismName, TargetLocationSrc.SourceParamName);    
        }
    }
        
    if (ForwardSpeedSrc.bUseSource)
    {
        ForwardSpeed=GetTargetParamFloat(ForwardSpeedSrc.SourceActor, ForwardSpeedSrc.SourceMechanismName, ForwardSpeedSrc.SourceParamName);
    }
}
 
function SetParamBool(name param, bool value, optional int priority=0)
{
    if (param=='bGrouped')
        ChangeGrouped(value);
}   

function SetParam(name param, object value, optional int priority=0)
{
    if (param=='LeaderObject')
        ChangeLeader(value);
}   
  
function vector GetParamVector(name param)
{
    if (param=='TargetLocation')
        return TargetLocation;
}  

defaultproperties
{
    mechname="Floating_Cube_Controller"
    
    MechanismParams.Empty
    
    MechanismParams(0)=(ParamName="LeaderObject", ParamInfo="Object. Write. Set this to a certain object to override targetlocation source object.")
}
