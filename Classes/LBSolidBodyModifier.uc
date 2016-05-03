/**
 *  LBSolidBodyModifier
 *
 *  Creation date: 03.05.2016 23:21
 *  Copyright 2016, Windows7
 */
class LBSolidBodyModifier extends LBMechanism;

var (LBSolidBodyModifier) bool bCollideActors;
var (LBSolidBodyModifier) bool bCollideWorld;
var (LBSolidBodyModifier) bool bBlockActors;
var (LBSolidBodyModifier) bool bBlockPlayers;

function FirstTickInit()
{
    if (bfirsttick==false)
        return;
    
    if (bfirsttick==true)
        bfirsttick=false;   
     
     LBActor(parent).SetCollision(bCollideActors, bBlockActors, bBlockPlayers);
}

function SetParamBool(name param, bool value)
{
    if (param=='bCollideActors')
        bCollideActors=value;
    else if (param=='bCollideWorld')
        bCollideWorld=value;
    else if (param=='bBlockActors')
        bBlockActors=value;  
     else if (param=='bBlockPlayers')
        bBlockPlayers=value;     
        
    LBActor(parent).SetCollision(bCollideActors, bBlockActors, bBlockPlayers); 
} 
 
function bool GetParamBool(name param)
{
    if (param=='bCollideActors')
        return bCollideActors;
    else if (param=='bCollideWorld')
        return bCollideWorld;
    else if (param=='bBlockActors')
        return bBlockActors; 
    else if (param=='bBlockPlayers')
        return bCollideWorld;      
    else return false;
}     
    
defaultproperties
{
    bCollideActors=true
    bCollideWorld=true
    bBlockActors=true
    bBlockPlayers=true
}
