/**
 *  LBBlendByAction
 *
 *  Creation date: 12.05.2016 23:03
 *  Copyright 2016, Windows7
 */
class LBBlendByAction extends AnimNodeBlendList;

var() bool bRUseReserveNode; //Use any animatoin input node as a reserve variant -- in case no mathcing nodes (actions) were found, Default is the reserve node by default, lol
var() name ReserveNode;
  
defaultproperties
{
    Children(0)=(Name="Default")
    
    ReserveNode="Default"
    
    CategoryDesc="LevBronstein"
}
