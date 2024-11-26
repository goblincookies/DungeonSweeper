extends Node

#enum for explore, flag enemy, flag key

var level : int = 0
var wonGame:bool = true;
var health:int = 0;
var continuing : bool = false;

func resetLevels()->void:
	level = 0;

func nextLevel()->void:
	level += 1;

func setContinue( val:bool )->void:
	continuing = val;

func isContinuing()->bool:
	return continuing;
	
#func setWinStatus( val:bool )->void:
	#wonGame = val;
func getHealth()->int:
	return health;
	
func setHealth( val:int)->void:
	health = val;

func wonLastGame()->bool:
	return health > 0;
