/**
 *  LBDynamicMovementMechanism
 *
 *  Creation date: 31.05.2016 21:31
 *  Copyright 2016, Windows7
 */
class LBDynamicMovementMechanism extends LBMovementMechanism;

function PerformMovement()
{
    local vector v;
    
    v.X=SpeedX;
    v.Y=SpeedY;
    v.Z=SpeedZ;

    parent.Velocity=v;
}


defaultproperties
{
}
