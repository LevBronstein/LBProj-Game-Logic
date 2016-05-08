/**
 *  LBCrystController
 *
 *  Creation date: 03.05.2016 21:39
 *  Copyright 2016, Windows7
 */
class LBCrystController extends LBMechanism;

var(CrystSystem) MaterialInstanceConstant ChargeMaterialInst; //Which material to use to indicate charge status
var(CrystSystem) name ChargeMaterialParamName; //What is the name of the parameter, which we want to set
var(CrystSystem) int ChargeMaterialInstIdx; //The index in the material array in the parent's mesh
var(CrystSystem) Light ChargeLight; //A light to toggle on full charge
var(CrystGameplay) bool bReflectsBeams; //Set to true if the beams should bounce off it's owner 
var(CrystGameplay) float CrystCharge; //0 is not charged, 1 is fully charged
var(CrystGameplay) float CrystChargeFading; //How fast will the charge fade
var(CrystGameplay) float CrystLinearImpulse; //Set to some value to use with any movement mechanism
var(CrystGameplay) float CrystAngularImpulse; //Set to some value to use with any movement mechanism  

var MaterialInstanceConstant ChargeMatInst; 
var float ChargeLightBrightness;


function FirstTickInit()
{
    if (bfirsttick==false)
        return;
    
    if (bfirsttick==true)
        bfirsttick=false;   
     
     Init();   
}

event OwnerTick(float deltatime)
{
    super.OwnerTick(deltatime);
    
    if (benabled==false)
        return;
   
    UpdateCharge();        
}   

function Init()
{
    if (ChargeMaterialInst!=none)
    {
        ChargeMatInst=new class 'MaterialInstanceConstant' (ChargeMaterialInst);
        if (ChargeMatInst!=none)
            LBActor(parent).Mesh.SetMaterial(ChargeMaterialInstIdx, ChargeMatInst);
        //LogError("ChargeMatInst="@ChargeMatInst);
        if (ChargeLight!=none)
        {
            ChargeLightBrightness=ChargeLight.LightComponent.Brightness;
        }   
    }
    else
        LogError("ChargeMaterialInst is none! Set a propper material instance.");
}
    
function UpdateCharge()
{
    if (CrystCharge>0)
    {
        CrystCharge=fclamp(CrystCharge-CrystChargeFading, 0, 1);
        if (ChargeMatInst!=none)
            ChargeMatInst.SetScalarParameterValue(ChargeMaterialParamName, CrystCharge);
    }
        
    if (ChargeLight!=none)
    {
        ChargeLight.LightComponent.SetLightProperties(CrystCharge*ChargeLightBrightness);
    }        
    //LogError("CrystCharge="@CrystCharge);
}

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
    else if (param=='CrystCharge')
        return CrystCharge;    
    else return 0;
} 

function SetParamFloat(name param, float value)
{
    if (param=='CrystLinearImpulse')
        CrystLinearImpulse=value;
    else if (param=='CrystAngularImpulse')
        CrystAngularImpulse=value;
    else if (param=='CrystCharge')
        CrystCharge=fclamp(value, 0, 1);
}   

defaultproperties
{
    bReflectsBeams=true
    mechname="CRYST_CONTROL"
    ChargeMaterialParamName="ChargeValue"
    ChargeMaterialInstIdx=3
    
    CrystCharge=0
    CrystChargeFading=0.025
}
