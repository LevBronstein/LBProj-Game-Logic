/**
 *  LBPhysicsModifier
 *
 *  Creation date: 01.11.2017 03:22
 *  Copyright 2017, Win10
 */
class LBPhysicsModifier extends LBMechanism;

var(PhysicsModifier) bool bEnablePhysics;
var(PhysicsModifierSystem) array<Name> PhysicsBones; //List of all bones, that should be toggled by this modifier
//var(PhysicsModifierSystem) SkeletalMeshComponent SkelMesh; //If none -- uses default

function InitMechanism()
{
    TogglePhyics(bEnablePhysics);
}

function TogglePhyics(bool b)
{
    if (b)
    {
        LBPawn(parent).Mesh.bEnableFullAnimWeightBodies=true;
        LBPawn(parent).Mesh.PhysicsAssetInstance.SetNamedBodiesFixed(false, PhysicsBones, LBPawn(parent).Mesh);
        LBPawn(parent).Mesh.WakeRigidBody();
    }
    else
    {
        LBPawn(parent).Mesh.bEnableFullAnimWeightBodies=false;
        LBPawn(parent).Mesh.PhysicsAssetInstance.SetNamedBodiesFixed(true, PhysicsBones, LBPawn(parent).Mesh);
        LBPawn(parent).Mesh.PutRigidBodyToSleep();
    }
}
       
function SetParamBool(name param, bool value, optional int priority=0)
{
    if (param=='bEnablePhysics')
    {
        bEnablePhysics=value;
        TogglePhyics(bEnablePhysics);
    }
}

function bool GetParamBool(name param)
{
    if (param=='bEnablePhysics')
        return bEnablePhysics;
} 


defaultproperties
{
}
