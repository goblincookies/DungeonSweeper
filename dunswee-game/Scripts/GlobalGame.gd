extends Node

#enum for explore, flag enemy, flag key

var level : int = 1
var wonGame:bool = true;
var health:int = 0;
var continuing : bool = false;
var time : float = 0.0;

func resetLevels()->void:level = 0;
func resetTimer()->void:time = 0;
func nextLevel()->void:level += 1;
func getLevel()->int:return level;
func setContinue( val:bool )->void:continuing = val;
func isContinuing()->bool:return continuing;
func getSavedTime()->float:return time;
func saveTime( val:float )->void:time = val;
func getHealth()->int:return health;
func setHealth( val:int)->void:health = val;
func wonLastGame()->bool:return health > 0;
