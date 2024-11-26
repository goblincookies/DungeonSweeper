extends Node

#enum for explore, flag enemy, flag key

var level : int = 0

func resetLevels()->void:
	level = 0;

func nextLevel()->void:
	level += 1;
