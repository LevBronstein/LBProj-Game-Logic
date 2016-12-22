/**
 *  LBGenericPickupController
 *
 *  Creation date: 22.12.2016 20:02
 *  Copyright 2016, Windows7
 */
class LBGenericPickupController extends LBInteractableMechanism;

var(GenericPickupControllerGameplay) bool bCanBePickedUp;

var(GenericPickupControllerSystem) name DefaultMovementMechanism; //The default movement mechanism, which is used primarily
var(GenericPickupControllerSystem) array<name> MovementMechanisms; //Other movement mechanism, each can be activated by ActivateMovement
var(GenericPickupControllerSystem) name AttachMechanism; 

var bool currattachstatus;

function FirstTickInit()
{
    super.FirstTickInit();
    
    ActivateDefaultMovMech();   
}

function ToggleMovment()
{
    local bool b;
    
    b=CheckAttachState();
    
    LogInfo("Previous state was"@currattachstatus@"new state is"@b);
    
    //Если состояние не изменилось - то выходим
    if (b == currattachstatus)
        return;
   
    if (b)
    {
        //Если прикреплён - значит нужно прекратить собсвтенные движения
        LogInfo("The object was attached, disabling movement by"@DefaultMovementMechanism);
        //LBActor(parent).SetParamBool(DefaultMovementMechanism, 'bEnabled', false);      
        DeactivateAllMovMechs();
    }
    else
    {
        //Если откреплён - значит нужно возобновить собсвтенные движения
        LogInfo("The object was detached, enabling movement by"@DefaultMovementMechanism);
        //LBActor(parent).SetParamBool(DefaultMovementMechanism, 'bEnabled', true); 
        ActivateDefaultMovMech();        
    }    
}

//function ChangeDefaultMovMech(name newmech)
//{
//    //Сначала отключаем старый
//    LBActor(parent).SetParamBool(DefaultMovementMechanism, 'bEnabled', false);
//    DefaultMovementMechanism=newmech;    
//}

//Активируем из массива MovementMechanisms
function ActivateMovMech(int id)
{
    local int i;
    local bool b;
    //Если id неверные - активируем DefaultMovementMechanism   
    
    LogInfo("Trying to activate"@id@"movement mechanism");
    
    //Нельзя просто так активировать - надо проверить, не взят ли наш объект
    if (CheckAttachState() || id<-1 || id>MovementMechanisms.Length-1)
        return;
    
    //При -1 активируем механизм по умолчанию
    if (id==-1)
    {
        ActivateDefaultMovMech();
        return;
    }
        
    b=false;
    //Отключаем все другие механизмы и включаем наш
    for (i=0;i<MovementMechanisms.Length;i++)
    {
        if (i==id)
        {
            LBActor(parent).SetParamBool(MovementMechanisms[i], 'bEnabled', true);              
            b=true;
            LogInfo("Activating movement mechanism:"@MovementMechanisms[i]);
        }
        else
            LBActor(parent).SetParamBool(MovementMechanisms[i], 'bEnabled', false);              
    }
    
    //Также отключаем и механизм по умолчанию, если был активирован другой
    if (b)
        LBActor(parent).SetParamBool(DefaultMovementMechanism, 'bEnabled', false);          
}

function ActivateDefaultMovMech()
{
    local int i;
    
    if (CheckAttachState())
        return;
    
    for (i=0;i<MovementMechanisms.Length;i++)
    {
        LBActor(parent).SetParamBool(MovementMechanisms[i], 'bEnabled', false);              
    }
    
    LBActor(parent).SetParamBool(DefaultMovementMechanism, 'bEnabled', true); 
    LogInfo("Activating a default movement mechanism");    
}

function DeactivateAllMovMechs()
{
    local int i;
    
    for (i=0;i<MovementMechanisms.Length;i++)
    {
        LBActor(parent).SetParamBool(MovementMechanisms[i], 'bEnabled', false);         
    }  
  
    LBActor(parent).SetParamBool(DefaultMovementMechanism, 'bEnabled', false);            
    LogInfo("Deactivating all movement mechanisms");
}

function Attach()
{   
    if (!bCanBePickedUp)
        return;
    currattachstatus=CheckAttachState();
    LBActor(parent).SetParamBool(AttachMechanism, 'Attach', true);    
    ToggleMovment();
}

function Detach()
{
    currattachstatus=CheckAttachState();
    LBActor(parent).SetParamBool(AttachMechanism, 'Detach', true);    
    ToggleMovment();    
}

function bool CheckAttachState()
{
    local bool b;
    
    b=LBActor(parent).GetParamBool(AttachMechanism, 'IsAttached');    
    
    return b;
}

//Как бы некоторый шлюз

function bool GetParamBool(name param)
{
    if (param=='IsAttached' || param=='IsPickedUp')
        return LBActor(parent).GetParamBool(AttachMechanism, 'IsAttached');
    else if (param== 'bCanBeAttached' || param=='bCanBePickedUp')
        return bCanBePickedUp;
}
    
function name GetParamName(name param)
{
    if (param=='DefaultMovementMechanism' || param=='DefaultMovement')
        return DefaultMovementMechanism;    
}

function SetParam(name param, object value, optional int priority=0)
{
    if (param=='AttachPawn')
        LBActor(parent).SetParam(AttachMechanism, 'AttachPawn', value);
} 
    
function SetParamInt(name param, int value, optional int priority=0)
{
    if (param=='ActivateMovement' || param=='ActivateMovementMechanism')
        ActivateMovMech(value);    
} 

function SetParamName(name param, name value, optional int priority=0)
{
    if (param=='AttachSocket')
        LBActor(parent).SetParamName(AttachMechanism, 'AttachSocket', value);
    //else if (param=='DefaultMovementMechanism' || param=='DefaultMovement')
    //    ChangeDefaultMovMech(value);
} 
    
function SetParamBool(name param, bool value, optional int priority=0)
{
    if (param=='IsPickedUp' || param=='IsAttached')
    {
        if (value)
            Attach();
        else
            Detach();    
    }
    else if (param=='Attach' || param=='PickUp')
    {
        Attach();
    } 
    else if (param=='Detach' || param=='PutDown')
    {
        Detach();
    }   
    else if (param== 'bCanBeAttached' || param=='bCanBePickedUp')
    {
        bCanBePickedUp=value;
    } 
}

defaultproperties
{
    currattachstatus=false
    
    bCanBePickedUp=true
    
    DefaultMovementMechanism=""
    AttachMechanism="Attach_Mechanism"
}
