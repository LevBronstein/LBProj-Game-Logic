/**
 *  LBGenericProterController
 *
 *  Creation date: 08.02.2017 00:37
 *  Copyright 2017, Windows7
 */
class LBGenericPorterController extends LBActorManagmentMechanism;

/*A mechanism, which is used in interacted objects.
By default: the name of LBGenericPickupController in every interactable object*/
var(PorterControllerSystem) name OtherObjectMechanism;
/*If set to true, the property @bCanBePickedUp in @OtherObjectMechanism
is ignored*/
var(PorterControllerGameplay) bool bIgnoreCanBePickedUp;
//var(InventoryMechanismSystem) name OtherObjectMechanismCheckingParam; 
//var(InventoryMechanismSystem) bool bInvertCheckingParam; 

//var(ParamSource) 

function bool AddActor(actor a)
{
    if (a==none && LBActor(a)==none && LBPawn(a)==none)
    {
        LogError("proc: AttachActor(), actor"@a@"is not valid");
        return false;
    }  
    
    if (!TargetHasMechanism(a,OtherObjectMechanism))
    {
        LogError("proc: AttachActor(), actor doesn't have a"@OtherObjectMechanism@"mechanism"); 
        return false;     
    }
    
    if (GetTargetParamBool(a,OtherObjectMechanism,'IsAttached'))
    {
        LogError("proc: AttachActor(), actor's mechanism"@OtherObjectMechanism@"has trigger state @TRUE (is attached)"); 
        return false;
    }
    
    if (!bIgnoreCanBePickedUp && !GetTargetParamBool(a,OtherObjectMechanism,'bCanBeAttached'))
    {
        LogError("proc: AttachActor(), actor's mechanism"@OtherObjectMechanism@"has bCanBeAttached @FALSE (cannot be attached)"); 
        return false;
    }
    
    if (super.AddActor(a))
    {
        SetTargetParam(a,OtherObjectMechanism,'AttachTo', parent);
        LogInfo("actor"@a@"was attached");
        return true;
    }
    else
    {
        LogInfo("actor"@a@"was not attached");  
        return false;
    }
}

function bool RemoveActor(actor a)
{
    if (a==none && LBActor(a)==none && LBPawn(a)==none)
    {
        LogError("proc: DetachActor(), actor is not valid");
        return false;
    }  
   
    if (!TargetHasMechanism(a,OtherObjectMechanism))
    {
        LogError("proc: DetachActor(), actor doesn't have a"@OtherObjectMechanism@"mechanism"); 
        return false;     
    } 
    
    if (!GetTargetParamBool(a,OtherObjectMechanism,'IsAttached'))
    {
        LogError("proc: DetachActor(), actor's mechanism"@OtherObjectMechanism@"has trigger state @FALSE (is not attached)"); 
        return false;
    }   
   
    if (super.RemoveActor(a)) 
    {
        SetTargetParamBool(a,OtherObjectMechanism,'Detach', true);
        LogInfo("actor"@a@"was detached");  
        return true;
    }
    else
    {
        LogInfo("actor"@a@"was not detached");  
        return false;
    }    
}

function bool RemoveActorByID(int id)
{
    local actor a;
    
    if (id<0 || id>=ContainedActors.Length)
    {
        LogError("proc: DetachActor(), given id"@id@"is not valid");
        return false;   
    }
    
    a=ContainedActors[id];
    
    return RemoveActor(a);   
}

defaultproperties
{
    mechname="Generic_Porter_Controller"
    
    OtherObjectMechanism="Generic_Pickup_Controller"
    OtherObjectMechanismCheckingParam="IsAttached"    
}
