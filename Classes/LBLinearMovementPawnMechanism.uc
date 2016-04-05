/**
 *  LBLinearMovementPawnMechanism
 *
 *  Creation date: 05.04.2016 21:08
 *  Copyright 2016, Windows7
 */
class LBLinearMovementPawnMechanism extends LBLinearMovementMechanism;

var(Animation) bool bAnimateMovement; //Should we animate movement via animtree
var(Animation) name BlendByMoveSpdNode; //Which node to use for animating movement 
var(Animation) bool bAnimateRotation; //Should we animate rotation via animtree
var(Animation) name BlendByAngSpdNode; //Which node to use for animating rotation 

//var TPBlendByMovementState blendbymovespd; //Animnode blending by move in the animtree
var LBBlendByAngSpeed blendbyangspd; //Animnode blending by angspeed in the animtree

event OwnerTick(float deltatime)
{
    super.OwnerTick(deltatime);
    
    if(benabled==false)
        return;
    
    UpdateAnimNodes();
}

function FirstTickInit()
{
    if (bfirsttick==false)
        return;
    
    if (bfirsttick==true)
        bfirsttick=false;
        
    //blendbymovespd=TPBlendByMovementState(parent.Mesh.FindAnimNode(BlendByMoveSpd));
    blendbyangspd=LBBlendByAngSpeed(LBPawn(parent).Mesh.FindAnimNode(BlendByAngSpdNode));
    `log(mechname@": BlendByMoveSpdNode= <not used>"@"BlendByAngSpdNode="@blendbyangspd);
}

function UpdateAnimNodes()
{
    //if (blendbymovespd != none)
    //blendbymovespd.UpdateCurrentMoveState(PawnMovementState);
    
    if (blendbyangspd != none)    
        blendbyangspd.UpdateAngSpeed(AngSpeed);
}

defaultproperties
{
}
