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
var(FloatingMovement) rotator FloatRotation;
var(FloatingMovement) float kFloatRotation;

var(MechanismDebug) bool bShowDebugLines;

//event OwnerTick(float deltatime)
//{
//    super.OwnerTick(deltatime);
//    
//    if(benabled==false)
//        return;
//    
//    if (bUseParamSource)
//        GetParameters();
//          
//    PerformMovement(deltatime);  
//}

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
    
    if (bShowDebugLines)
    {
        parent.DrawDebugSphere(targetloc, 64, 16, 255, 0, 0);
        parent.DrawDebugLine(parent.location + vect(0,0,32), targetloc, 255, 0, 0);
    }
}

function PerformRotation(float dt)
{
    parent.SetRotation(parent.Rotation+FloatRotation*kFloatRotation);    
}

function SetParamBool(name param, bool value, optional int priority=0)
{
    if (param=='bEnabled')
        bEnabled=value;
}
    

defaultproperties
{
    FloatAttidtudeZ=0
    LinearSpeed=0.15
    kLinearSpeed=1.0
    kFloatRotation=1
    
    mechname="Floating_Movement"
}
