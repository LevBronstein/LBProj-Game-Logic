/**
 *  LBFloatingMovementMechanism
 *
 *  Creation date: 22.12.2016 21:01
 *  Copyright 2016, Windows7
 */
class LBFloatingMovementMechanism extends LBTransposeMechanism;

var(FloatingMovement) float FloatAttidtudeZ; //A desired height
var(FloatingMovement) float LinearSpeed;
var(FloatingMovement) float kLinearSpeed;

function PerformMovement(float dt)
{
    local vector v;
    local vector targetloc;
      
    v=vect(0,0,0); 
    targetloc=parent.Location;
    targetloc.Z=FloatAttidtudeZ;

    v=targetloc-parent.location;
    
    if (vsize(v)>=kLinearSpeed*LinearSpeed) //дистаниця нулевая - не работает (дергается)!!!
    {
        v=normal(v);
        
        parent.MoveSmooth(normal(v)*LinearSpeed*kLinearSpeed);
        //paertn.Velocity=normal(v)*ForwardSpeed*kForwardSpeed; 
    }  
    
    if (bShowDebugGraphics)
    {
        parent.DrawDebugSphere(targetloc, 64, 16, 255, 0, 0);
        parent.DrawDebugLine(parent.location + vect(0,0,32), targetloc, 255, 0, 0);
    }
}

    

defaultproperties
{
    FloatAttidtudeZ=0
    
    mechname="Floating_Movement"
}
