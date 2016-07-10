/**
 *  LBFollowMovementMechanism
 *
 *  Creation date: 07.07.2016 19:23
 *  Copyright 2016, Windows7
 */
class LBFollowMovementMechanism extends LBTargetedMovementMechanism;

var(ParamSource) LBParamSourcePointer TargetLocationActorSrc;
var(FollowMovement) actor TargetLocationActor;
var(FollowMovement) bool bOverrideActor; //When set to true the @TargetLocationActor value is used instead of TargetLocationActorSrc.SourceActor

function GetParameters()
{
    super.GetParameters(); 
    
    if (TargetLocationActorSrc.bUseSource)
    { 
        //a=actor(GetTargetParam(TargetLocationActorSrc.SourceActor, TargetLocationActorSrc.SourceMechanismName, TargetLocationActorSrc.SourceParamName));
        if (bOverrideActor)
        {
            if (TargetLocationActor!=none)
            TargetLocation=GetTargetParamVector(TargetLocationActor, TargetLocationSrc.SourceMechanismName, TargetLocationSrc.SourceParamName);
        }
        else
        {
            TargetLocation=GetTargetParamVector(TargetLocationActorSrc.SourceActor, TargetLocationSrc.SourceMechanismName, TargetLocationSrc.SourceParamName);
        }  
    }
}

function SetParamVector(name param, vector value, optional int priority=0)
{
}

defaultproperties
{
}
