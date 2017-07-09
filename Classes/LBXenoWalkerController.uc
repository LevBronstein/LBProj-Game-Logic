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
 * .
 * .
 * 500 -- Carry
 * 501 -- PickUp 
 * 502 -- PutDown
*/

//Get any potentally pickable object by this pointer from any source, i.e. @AreaCheckingMechanism.NearestObject
var(CharacterInventory) LBConstTypedParamPtr GetPotentallyPickableActor;
//Set @GetPotentallyPickableActor to an inventory mechanism by this pointer to check for pickup
var(CharacterInventory) LBConstTypedParamPtr SetCheckingActor;
//Set actor be added to inventory by inventory mechanism by this pointer
var(CharacterInventory) LBConstTypedParamPtr SetAddObjectToInventory; 
//Set boolean value by this pointer to an inventory mechanism to remove object from inventory
var(CharacterInventory) LBConstTypedParamPtr SetRemoveObjectFromInventory; 
//Get any held object from an inventory mechanism
var(CharacterInventory) LBConstTypedParamPtr GetHeldObject;
//Get boolean value from thish source, indicating abilty to pick up 
var(CharacterInventory) LBConstTypedParamPtr GetbCanPickUp;
//Get boolean value from thish source, indicating abilty to put down 
var(CharacterInventory) LBConstTypedParamPtr GetbCanPutDown;

function bool CheckPickUp()
{
    local bool bpickup;
    local actor pickup;
    
    pickup=Actor(GetTargetParam(GetPotentallyPickableActor.ParentActor,GetPotentallyPickableActor.MechanismName,GetPotentallyPickableActor.ParamName)); 
    SetTargetParam(SetCheckingActor.ParentActor,SetCheckingActor.MechanismName,SetCheckingActor.ParamName,pickup);
    bpickup=GetTargetParamBool(GetbCanPickUp.ParentActor,GetbCanPickUp.MechanismName,GetbCanPickUp.ParamName);  
    
    if (bpickup)   
        LogInfo("We can pick up object"@pickup);
    else
        LogInfo("We can not pick up object"@pickup);
        
    return bpickup;
}

function bool CheckPutDown()
{
    local bool bputdown;

    bputdown=GetTargetParamBool(GetbCanPutDown.ParentActor,GetbCanPutDown.MechanismName,GetbCanPutDown.ParamName);  
    
    if (bputdown)   
        LogInfo("We can put down up object"@bputdown);
    else
        LogInfo("We can not put down object"@bputdown);
        
    return bputdown;   
}

function PickUpObject()
{
    local bool bpickup;
    local actor pickup;   
   
    pickup=Actor(GetTargetParam(GetPotentallyPickableActor.ParentActor,GetPotentallyPickableActor.MechanismName,GetPotentallyPickableActor.ParamName));
    SetTargetParam(SetAddObjectToInventory.ParentActor,SetAddObjectToInventory.MechanismName,SetAddObjectToInventory.ParamName,pickup);
    
    LogInfo("We have picked up object"@pickup);
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
    
    //Проверка возомжности выполнения действия (анимации) поднятия объекта
    if (actioncode ==  501)
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
   
function HandleActionStop(int stoppedaction)
{
    local int actioncode;
    
    actioncode=CharActionInfoByIndex(stoppedaction).ActionCode;
    
    //Добавление предмета в инвентарь
    //if (actioncode ==  501)
    //{
    //    if (CheckPickUp())
    //    {
    //        PickUpObject();    
    //    } 
    //}
    ////Выкладывание объекта из инвентаря 
    //if (actioncode ==  502)
    //{
    //    if (CheckPutDown())
    //    {
    //        PutDown();    
    //    }    
    //}  
    //else
    //    return;    
}

function HandleAnimNotify(int actioncode, int actiondata, ActionNotifyTypes notifytype)
{
    if (actioncode ==  501)
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
    GetPotentallyPickableActor=(ParamType=ParamType_Object)
    SetCheckingActor=(ParamType=ParamType_Object, ParamName="CheckingObject")
    SetAddObjectToInventory=(ParamType=ParamType_Object, ParamName="AddObject")
    GetbCanPickUp=(ParamType=ParamType_Boolean)
    GetbCanPutDown=(ParamType=ParamType_Boolean)
}
