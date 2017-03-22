/**
 *  LBRollingMovementMechanism
 *
 *  Creation date: 09.03.2017 00:49
 *  Copyright 2017, Windows7
 */
class LBRollingMovementMechanism extends LBDirectedMovementMechanism;

var(RollingMovement) float kAngSpeed;

function PerformRotation(float dt)
{
    local rotator r;
    
    r=parent.Rotation;
    
    r.Yaw=MoveDirection.Yaw;
    r.Pitch=r.Pitch+(-1)*ForwardSpeed*kForwardSpeed*kAngSpeed*DegToUnrRot;
    r.Roll=MoveDirection.Roll;
    
    parent.SetRotation(r);
}
defaultproperties
{
    mechname="Rolling_Movement_Mechanism"
    
    kAngSpeed=1.0f
}
