/**
 *  LBGeomActorCheckingMechanism
 *
 *  Creation date: 18.07.2017 02:03
 *  Copyright 2017, Win10
 */
class LBGeomActorCheckingMechanism extends LBActorCheckingMechanism
abstract;

enum CoordinateTypes
{
    /*The default coordinate type, when the point location is calculated
    in global coordinates*/
    CoordinateType_World,
    /*Local coordinates, it means that the base actor's location is
    added to the point location*/
    CoordinateType_Local,
    /*Local oriented coordinates, it means that the point location
    is projected into base actor's local coordinate system with
    certain orientation (GetAxes is used)*/
    CoordinateType_LocalOriented,
};

enum AreaTypes
{
    AreaTypes_Sphere,
    AreaTypes_Box,    
};


function vector TransformCoords(vector p, CoordinateTypes coords)
{
    local vector v;
    local vector X, Y, Z;
    
    if (coords==CoordinateType_World) 
    {
        return p;
    }   
    else if (coords==CoordinateType_Local)
    {
        return p+parent.Location;
    }
    else if (coords==CoordinateType_LocalOriented)
    {
        GetAxes(parent.Rotation,X,Y,Z);
        v=parent.Location+X*p.X+Y*p.Y+Z*p.Z;
        return v;        
    }
}

defaultproperties
{
}
