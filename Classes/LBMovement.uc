/**
 *  MyProjMovementBase
 *
 *  Creation date: 24.02.2016 23:12
 *  Copyright 2016, Windows7
 */
class LBMovement extends Object
editinlinenew;

struct MovementTransform
{
    var() vector location;
    var() rotator rotation;
    var() vector scale;    
};

enum CoordinateSystem
{
    WORLD,
    PARENT,
    PERSONAL
};

var vector curloc;
var rotator currot;
var vector curscale;

//Тут должна быть функция f(t), например sin(t), t - типа параметр
function MovementTransform CalcMovement(float t);

defaultproperties
{
}
