/**
 *  LBAddParamObjectListSeq
 *
 *  Creation date: 06.02.2017 22:05
 *  Copyright 2017, Windows7
 */
class LBAddParamObjectArraySeq extends SequenceAction;

var object targetactor;
var object value;

var() name mechname;
var() name paramname;

event Activated()
{
    local array<object> params;
    local array<object> objarr;
    local int i;
    
    if(LBActor(targetactor)!=none)
    {
        params=LBActor(targetactor).GetParams(mechname,paramname);
        
        for (i=0;i<params.Length;i++)
        {
            objarr.AddItem(params[i]);    
        }
        
        objarr.AddItem(value);
        
        LBActor(targetactor).SetParams(mechname,paramname,objarr);
        
        return;
    }
    if(LBPawn(targetactor)!=none)
    {
        params=LBPawn(targetactor).GetParams(mechname,paramname);
        
        for (i=0;i<params.Length;i++)
        {
            objarr.AddItem(params[i]);    
        }
        
        objarr.AddItem(value);
        
        LBPawn(targetactor).SetParams(mechname,paramname,objarr);
        return;
    }
}


defaultproperties
{
    bCallHandler=false
    
    ObjName="Add Actor Object Array Param"
    ObjCategory="LevBronstein"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target Actor",PropertyName=targetactor)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Object Value",PropertyName=value)
}