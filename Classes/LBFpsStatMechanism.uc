/**
 *  LBFpsStatMechanism
 *
 *  Creation date: 29.06.2017 17:02
 *  Copyright 2017, Win10
 */
class LBFpsStatMechanism extends LBMechanism;

function PerfromTick(float dt)
{
    `log("Current time:"@dt@"current FPS"@1/dt);    
}

defaultproperties
{
}
