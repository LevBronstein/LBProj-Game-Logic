/**
 *  LBXenoWalkerController
 *
 *  Creation date: 08.07.2017 01:06
 *  Copyright 2017, Win10
 */
class LBXenoWalkerController extends LBBasicCharacaterController;

/* Action List
 * 100 -- Walk
 * .
 * .
 * 401 -- Touch
 * .
 * .
 * 500 -- Carry
 * 501 -- PickUp 
 * 502 -- PutDown
*/

//Get boolean value from thish source, indicating the abilty to interact with the potentally interactable object 
var(CharacterInteraction) LBConstTypedParamPtr GetbCanInteract;
//Set the needed interaction id in the interaction mechanism
var(CharacterInteraction) LBConstTypedParamPtr SetInteractionID; 
//The command sent to the interaction mechanism to perform the interaction
var(CharacterInteraction) LBConstTypedParamPtr SetPerformInteraction; 

//Id of the interaction TOUCH in interaction mechanism
var(CharacterInteraction) int TouchInteractionID;

//Set actor be added to inventory by inventory mechanism by this pointer
var(CharacterInventory) LBConstTypedParamPtr SetAddObjectToInventory; 
//Set boolean value by this pointer to an inventory mechanism to remove object from inventory
var(CharacterInventory) LBConstTypedParamPtr SetRemoveObjectFromInventory; 
//Get boolean value from thish source, indicating abilty to pick up 
var(CharacterInventory) LBConstTypedParamPtr GetbCanPickUp;
//Get boolean value from thish source, indicating abilty to put down 
var(CharacterInventory) LBConstTypedParamPtr GetbCanPutDown;

function bool CheckInteract(int interaction)
{
    local bool binteract;
    
    SetTargetParamInt(SetInteractionID.ParentActor,SetInteractionID.MechanismName,SetInteractionID.ParamName,interaction);
    binteract=GetTargetParamBool(GetbCanInteract.ParentActor,GetbCanInteract.MechanismName,GetbCanInteract.ParamName);  
    
    if (binteract)   
        LogInfo("We can interact");
    else
        LogInfo("We can not interact");
        
    return binteract;
}

function PerformInteraction(int interaction)
{
    SetTargetParamInt(SetInteractionID.ParentActor,SetInteractionID.MechanismName,SetInteractionID.ParamName,interaction);
    SetTargetParamBool(SetPerformInteraction.ParentActor,SetPerformInteraction.MechanismName,SetPerformInteraction.ParamName,true);
    
    LogInfo("We have performed interaction:" @interaction);    
}

function bool CheckPickUp()
{
    local bool bpickup;

    bpickup=GetTargetParamBool(GetbCanPickUp.ParentActor,GetbCanPickUp.MechanismName,GetbCanPickUp.ParamName);  
    
    if (bpickup)   
        LogInfo("We can pick up object");
    else
        LogInfo("We can not pick up object");
        
    return bpickup;
}

function bool CheckPutDown()
{
    local bool bputdown;

    bputdown=GetTargetParamBool(GetbCanPutDown.ParentActor,GetbCanPutDown.MechanismName,GetbCanPutDown.ParamName);  
    
    if (bputdown)   
        LogInfo("We can put down up object");
    else
        LogInfo("We can not put down object");
        
    return bputdown;   
}

function PickUpObject()
{
    SetTargetParamBool(SetAddObjectToInventory.ParentActor,SetAddObjectToInventory.MechanismName,SetAddObjectToInventory.ParamName,true);
    
    LogInfo("We have picked up object");
}

function PutDown()
{
    SetTargetParamBool(SetRemoveObjectFromInventory.ParentActor,SetRemoveObjectFromInventory.MechanismName,SetRemoveObjectFromInventory.ParamName,true);
    
    LogInfo("We have removed put down object");
}

function bool IsCustomConditionMet(int actionid)
{
    local int actioncode;
    
    actioncode=CharActionInfoByIndex(actionid).ActionCode;
    
    //Проверка возомжности выполнения действия (анимации) взаимодействия с объектом -- прикосновения
    if (actioncode ==  401)
    {
        return CheckInteract(TouchInteractionID);    
    } 
    //Проверка возомжности выполнения действия (анимации) поднятия объекта
    else if (actioncode ==  501)
    {
        return CheckPickUp();    
    } 
    //Проверка возможности выполения действия (анимации) выкладывания объекта
    else if (actioncode == 502)
    {
        return CheckPutDown();
    }  
    else
        return true;
}
   
function HandleAnimNotify(int actioncode, int actiondata, ActionNotifyTypes notifytype)
{
    //Взаимодейсивме -- прикосновение
    if (actioncode ==  401)
    {
        if (CheckInteract(TouchInteractionID))
        {
            PerformInteraction(TouchInteractionID);    
        } 
    }
    //Подбирание объекта в инвентарь
    else if (actioncode ==  501)
    {
        if (CheckPickUp())
        {
            PickUpObject();    
        } 
    }
    //Выкладывание объекта из инвентаря 
    if (actioncode ==  502)
    {
        if (CheckPutDown())
        {
            PutDown();    
        }    
    }
   // `log("actioncode:"@actioncode@"actiondata:"@actiondata@"notifytype:"@notifytype);
}
    
defaultproperties
{
    SetAddObjectToInventory=(ParamType=ParamType_Boolean, MechanismName="Inventory_Mechanism", ParamName="AddCheckingObject")
    SetRemoveObjectFromInventory=(ParamType=ParamType_Boolean, MechanismName="Inventory_Mechanism", ParamName="RemoveAllObjects")
    GetbCanPickUp=(ParamType=ParamType_Boolean, MechanismName="Inventory_Mechanism", ParamName="bCanAddToIvnentory")
    GetbCanPutDown=(ParamType=ParamType_Boolean, MechanismName="Inventory_Mechanism", ParamName="bCanRemoveFromIvnentory")
    
    GetbCanInteract=(ParamType=ParamType_Boolean, MechanismName="Simple_Interaction_Mechanism", ParamName="bCanInteract")
    SetInteractionID=(ParamType=ParamType_Integer, MechanismName="Simple_Interaction_Mechanism", ParamName="CurentInteraction")
    SetPerformInteraction=(ParamType=ParamType_Boolean, MechanismName="Simple_Interaction_Mechanism", ParamName="Interact")
    
    TouchInteractionID=1
}
