/**
 *  LBGetObjectName
 *
 *  Creation date: 08.07.2017 23:20
 *  Copyright 2017, Win10
 */
class LBGetObjectName extends SequenceAction;

var Object obj;
var String strname;
var String strtag;

event Activated()
{
    if (obj!=none)
    {
        strname=string(obj.Name);
        if (Actor(obj)!=none)
            strtag=string(Actor(obj).Tag);
        else
            strtag="None";   
    }
    else
    {
        strname="None";
        strtag="None";
    }    
}


defaultproperties
{
    bCallHandler=false
    
    ObjName="Get Object Name And Tag"
    ObjCategory="LevBronstein Utils"
    
    VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Object",PropertyName=obj)
    VariableLinks(1)=(ExpectedType=class'SeqVar_String',LinkDesc="Object Name",bWriteable=true,PropertyName=strname)
    VariableLinks(2)=(ExpectedType=class'SeqVar_String',LinkDesc="Object Tag",bWriteable=true,PropertyName=strtag)
}