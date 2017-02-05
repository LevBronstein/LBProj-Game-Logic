/**
 *  LBSequenceEvent
 *
 *  Creation date: 20.05.2016 23:10
 *  Copyright 2016, Windows7
 */
class LBSequenceEvent extends SequenceEvent;

var() name EventName;

defaultproperties
{
    ObjName="Named Remote-Triggered Event"
    ObjCategory="LevBronstein"

    bPlayerOnly=false
    MaxTriggerCount=0
}
