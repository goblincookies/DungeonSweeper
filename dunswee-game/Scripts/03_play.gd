extends Control

signal initiateSceneChange( sceneIndex:int );

@export var topBanners : Control
@export var enemyCount : int
@export var keyCount : int
@export var healthCount : int
@export var startingFlagsEnemy : int
@export var startingFlagsKey : int

var flagsRemainingEnemy:int = 0;
var flagsRemainingKey:int = 0;

enum FlagTypes {UNMARKED, ENEMY, KEY};
enum ActionTypes {BASIC, FLAGENEMY, FLAGKEY, ESCAPE};
enum TileTypes {EMPTY, MARKED, ENEMY, KEY, HEALTH};
var currentAction : ActionTypes = ActionTypes.BASIC;


func _ready() -> void:
	flagsRemainingEnemy = startingFlagsEnemy;
	flagsRemainingKey = startingFlagsKey;
	print("setting up buttons")
	currentAction = ActionTypes.BASIC;
	
	for bttn in $Buttons.get_children():
	
		if (bttn.getButtonAction()==currentAction):
			bttn.setActive(true);
		else:
			bttn.setActive(false);

func getCount( type:int )->int:
	match type:
		TileTypes.ENEMY:
			return enemyCount;
		TileTypes.KEY:
			return keyCount;
		TileTypes.HEALTH:
			return healthCount;
	return 0;

func getStartingFlags(type:FlagTypes)->int:
	match type:
		FlagTypes.ENEMY:
			return startingFlagsEnemy;
		FlagTypes.KEY:
			return startingFlagsKey;
	return 0;

func hasFlagsRemaining(type:FlagTypes)->bool:
	match type:
		FlagTypes.ENEMY:
			return flagsRemainingEnemy > 0;
		FlagTypes.KEY:
			return flagsRemainingKey > 0;
	return false;

func getCurrentAction()->ActionTypes: return currentAction;

func _on_bttn_start_clicked() -> void:
	emit_signal("initiateSceneChange",0);




func _on_bttn_base_game_clicked( clickedButton: Control ) -> void:
	currentAction = clickedButton.getButtonAction();
	for bttn in $Buttons.get_children():
		bttn.setActive(false);

	clickedButton.setActive(true);


func _on_field_flagged(type: FlagTypes) -> void:
#	DECREASE FLAGS
	match type:
		FlagTypes.ENEMY:
			flagsRemainingEnemy -=1;
		FlagTypes.KEY:
			flagsRemainingKey -=1;
	$Top/Banners.usedFlag( type )


func _on_field_hit(type: TileTypes) -> void:
	pass # Replace with function body.


func _on_field_unflagged(type: FlagTypes) -> void:
	match type:
		FlagTypes.ENEMY:
			flagsRemainingEnemy +=1;
		FlagTypes.KEY:
			flagsRemainingKey +=1;
	$Top/Banners.returnedFlag( type )
