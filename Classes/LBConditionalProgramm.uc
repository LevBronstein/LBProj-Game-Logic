/**
 *  LBConditionalAction
 *
 *  Creation date: 20.05.2016 21:55
 *  Copyright 2016, Windows7
 */
 
 /******************************Utility******************************/

class LBConditionalProgramm extends LBInteractableMechanism;

enum LBConditionTypes
{
    LBCondition_Equals,
    LBCondition_Less,
    LBCondition_LessOrEquals,
    LBCondition_Greater,
    LBCondition_GreaterOrEquals,
    LBCondition_Between,
    LBCondition_Outside,
};

enum LBLogicGateTypes
{
    LBLogicGate_And,
    LBLogicGate_Or,
};

struct LBCondition
{
    var() actor TargetActor; //LBActor or LBPawn
    var() name TargetMechanism;
    var() name TargetParam; //A value to compare
    var() LBConditionTypes Condition;
    var() float ConditionalValueA; //A value to check
    var() float ConditionalValueB; //A value to check
};

struct LBAction
{
    var() actor TargetActor; //LBActor or LBPawn
    var() name TargetMechanism;
    var() name TargetParam;
    var() float Value; //A value to check
};

struct LBProgramm
{
    var() array<LBCondition> Conditions;
    var() array<LBLogicGateTypes> LogicGates;
    var() array<LBAction> Actions;
};
    
defaultproperties
{
}
