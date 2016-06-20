/**
 *  LBInfoMechanism
 *
 *  Creation date: 12.06.2016 21:10
 *  Copyright 2016, Windows7
 */
class LBInfoMechanism extends LBMechanism;

function vector GetParamVector(name param)
{
    if (param=='Location')
        return parent.Location;
}

function rotator GetParamRotator(name param)
{
    if (param=='Rotation')
        return parent.Rotation;
}
    
defaultproperties
{
    mechname="Actor_Info"
    
    MechanismParams(0)=(ParamName="Location", ParamInfo="Vector. Read. Returns location of the parent.")
    MechanismParams(1)=(ParamName="Rotation", ParamInfo="Rotator. Read. Returns rotation of the parent.")
}
