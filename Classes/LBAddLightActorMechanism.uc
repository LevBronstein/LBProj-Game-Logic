/**
 *  LBAddLightActorMechanism
 *
 *  Creation date: 24.12.2016 22:03
 *  Copyright 2016, Windows7
 */
class LBAddLightActorMechanism extends LBAttachActorMechanism;

function FirstTickInit()
{
    if (bfirsttick==false)
        return;
    
    if (bfirsttick==true)
        bfirsttick=false;   
     
    CreateLight();   
}
 
function CreateLight()
{
    local vector v;
    local rotator r;
    
    v=parent.Location+LocOffset;
    r=parent.Rotation+RotOffset;
    
    AttachedActor=parent.Spawn(class'LBLight',,,v,r);
    Light(AttachedActor).LightComponent.SetLightProperties(1);
    Attach();    
}

defaultproperties
{
    mechname="Add_Actor_Mechanism"
}
