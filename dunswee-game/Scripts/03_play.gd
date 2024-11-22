extends Control

signal initiateSceneChange( sceneIndex:int );

enum ActionTypes {BASIC, ENEMY, KEY, ESCAPE};
var currentAction : ActionTypes = ActionTypes.BASIC;


func getCurrentAction()->ActionTypes: return currentAction;

func _on_bttn_start_clicked() -> void:
	emit_signal("initiateSceneChange",0);

func _ready() -> void:
	print("setting up buttons")
	currentAction = ActionTypes.BASIC;
	
	for bttn in $Buttons.get_children():
	
		if (bttn.getButtonAction()==currentAction):
			bttn.setActive(true);
		else:
			bttn.setActive(false);


func _on_bttn_base_game_clicked( clickedButton: Control ) -> void:
	currentAction = clickedButton.getButtonAction();
	for bttn in $Buttons.get_children():
		bttn.setActive(false);
	
	clickedButton.setActive(true);
