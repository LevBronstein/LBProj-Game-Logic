/**
 *  LBCrystController
 *
 *  Creation date: 03.05.2016 21:39
 *  Copyright 2016, Windows7
 */
class LBCrystController extends LBMechanism;

var(Cryst) bool bReflectsBeams; //Set to true if the beams should bounce off it's owner 
var(Cryst) float CrystLinearImpulse; //Set to some value to use with any movement mechanism
var(Cryst) float CrystAngularImpulse; //Set to some value to use with any movement mechanism  

function bool GetParamBool(name param)
{
    if (param=='bReflectsBeams')
        return bReflectsBeams;
    else
        return false;
}
    
function float GetParamFloat(name param)
{
    if (param=='CrystLinearImpulse')
        return CrystLinearImpulse;
    else if (param=='CrystAngularImpulse')
        return CrystAngularImpulse;
    else return 0;
} 

function SetParamFloat(name param, float value)
{
    if (param=='CrystLinearImpulse')
        CrystLinearImpulse=value;
    else if (param=='CrystAngularImpulse')
        CrystAngularImpulse=value;
}   

defaultproperties
{
    bReflectsBeams=true
    mechname="CRYST_CONTROL"
}
