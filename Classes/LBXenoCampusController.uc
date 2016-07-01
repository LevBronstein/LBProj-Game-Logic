/**
 *  LBXenoCampusController
 *
 *  Creation date: 27.06.2016 22:29
 *  Copyright 2016, Windows7
 */
class LBXenoCampusController extends LBPawnInteractableController;

var(MechanismInfo) editconst string InteractionInfo[3];

var(System) name InfoMechanism;
var(System) name OtherActorsMechanism;

var int curinteraction;

function PerformTick()
{
    //super.PerformTick();
}

function ActivateInteraction(int value)
{
    local vector v;
    local object o;
       
    if (value==1)
    {
        //activate interaction: Call
        
        //set targetobject.LBFloatingCubeController.TargetLocation<-parent.location
        v=GetTargetParamVector(parent, InfoMechanism, 'Location');
        o=GetTargetParam(parent, TargetingMechanism, 'TargetedObject');
        
        if (actor(o)==none)
        {
            LogError("proc: ActivateInteraction(), targeted object is not an actor or none:"@o); 
            return;
        }
        //`log(o@"->"@v);
        SetTargetParamVector(actor(o), OtherActorsMechanism, 'TargetLocation', v);
        SetTargetParamBool(actor(o), OtherActorsMechanism, 'bEnableMovement', true);
        
        //set speed (get default positive speed)
        //set action
        //play animation
        //play sound
        curinteraction=1;
    }
    
    //local actor a;
    //local object o;
    //
    //ActivateInteractionId=value;
    //DeactivateInteractionId=-1;
    //
    //o=GetTargetParam(parent, InteractingMechanism, 'TargetedObject');
    //
    //if (actor(o)==none)
    //{
    //    LogError("proc: ActivateInteraction(), targeted object is not an actor or none:"@o); 
    //    return;
    //}
    //
    //a=actor(o);
    //
    //if (bgroup)
    //    SetTargetParam(parent, GroupingMechanism, 'AddSelectedObject', a);
    //else
    //    SetTargetParam(parent, GroupingMechanism, 'RemoveSelectedObject', a);  
}

function DeactivateInteraction(int value)
{
    //DeactivateInteractionId=value;
    //ActivateInteractionId=-1;
}

function SetParamInt(name param, int value, optional int priority=0)
{
    super.SetParamInt(param, value);
    if (param=='ActivateInteraction')
    ActivateInteraction(value);
} 

defaultproperties
{
    InfoMechanism="Actor_Info"
    OtherActorsMechanism="Actor_Controller"
    
    InteractionInfo(0)="No interaction"
    InteractionInfo(1)="Call"
    
    curinteraction=0
}
