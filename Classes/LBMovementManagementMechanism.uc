/**
 *  LBMovementManager
 *
 *  Creation date: 01.02.2017 00:13
 *  Copyright 2017, Windows7
 */
class LBMovementManagementMechanism extends LBMechanism;

var(MovementManager) name DefaultMovementMechanism; //The default movement mechanism, which is used primarily
var(MovementManager) array<name> MovementMechanisms; //Other movement mechanism, each can be activated by ActivateMovement

function FirstTickInit()
{
    if (bfirsttick==false)
        return;
    
    if (bfirsttick==true)
        bfirsttick=false;
    
    ActivateDefaultMovMech();   
}

//Активируем из массива MovementMechanisms
function ActivateMovMech(int id)
{
    local int i;
    local bool b;
    
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
    else
        LBActor(parent).SetParamBool(DefaultMovementMechanism, 'bEnabled', true);        
}

function ActivateDefaultMovMech()
{
    local int i;
        
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

function SetParamInt(name param, int value, optional int priority=0)
{
    if (param=='ActivateMovement' || param=='ActivateMovementMechanism')
        ActivateMovMech(value);    
} 

defaultproperties
{
    mechname="Movement_Manager"
}
