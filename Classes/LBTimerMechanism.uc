/**
 *  LBTimerMechanism
 *
 *  Creation date: 05.02.2017 01:17
 *  Copyright 2017, Windows7
 */
class LBTimerMechanism extends LBKismetInterfaceMechanism;

/*The timer stops or resets, when @CurrentTime reaches
this value. Set 0 to disable limit*/
var(TimerMechanism) int TimeLimit; 

/*Should we reset @CurrentTime to 0 
and start over again, when TimeLimit was reached*/ 
var(TimerMechanism) bool bResetOnLimitReached; 

/*Activated when @CurrentTime increases (every tick).
VERY EXPENSIVE!!!*/
var(EventActivation) name OnTimerTick; 

/*Activated when @CurrentTime reaches @TimeLimit.
Won't be called, if @TimeLimit is disabled (i.e. =<0)*/
var(EventActivation) name OnTimeLimitReached;


var int currenttime;

event OwnerTick(float deltatime)
{
    if(benabled==false)
        return;

    PerformTick();           
}

function PerformTick()
{
    LogInfo(""$currenttime);
    
    if (TimeLimit <=0 || currenttime < TimeLimit)
    {
        currenttime+=1; 
        TimerTick();  
        return; 
    }
    
    if (currenttime >= TimeLimit) 
    {
        currenttime=0;  
        TimeLimitReached();
    }   
}

function TimerTick()
{
    if (OnTimerTick!='')
        ActivateKismetEvent(OnTimerTick,parent.WorldInfo,parent);        
}

function TimeLimitReached()
{
    if (OnTimeLimitReached!='')
        ActivateKismetEvent(OnTimeLimitReached,parent.WorldInfo,parent);    
}
    
function int GetParamInt(name param)
{
    if (param=='CurrentTime')
    {
        return currenttime;
    } 
    else if (param=='TimeLimit')
    {
        return TimeLimit;
    }
}

function SetParamInt(name param, int value, optional int priority=0)
{
    if (param=='TimeLimit')
    {
        TimeLimit=value;
    }     
} 
    
defaultproperties
{
    mechname="Timer_Mechanism"
        
    bResetOnLimitReached=true
    TimeLimit=0
    
    MechanismParams(0)=(ParamName="CurrentTime", ParamInfo="Integer. Read. Returns current time @currenttime, accumulated by this timer.")
    MechanismParams(1)=(ParamName="TimeLimit", ParamInfo="Integer. Read, Write. Sets time limit @TimeLimit for this timer. Set to 0 to disable time limit.")

}
