extends Node

signal clicked
@export var area : Area2D


enum ActionTypes {BASIC, ENEMY, KEY, ESCAPE};
@export var buttonType: ActionTypes;


func getButtonAction()->ActionTypes:return buttonType;

func _ready() -> void:
	area.input_event.connect( thisClicked );
	$BaseIcon.visible = false;
	$EnemyIcon.visible = false;
	$KeyIcon.visible = false;
	match buttonType:
		ActionTypes.BASIC:
			$BaseIcon.visible = true;
		ActionTypes.ENEMY:
			$EnemyIcon.visible = true;
		ActionTypes.KEY:
			$KeyIcon.visible = true;
		ActionTypes.ESCAPE:
			pass

func setActive( val ):
	$A.visible = val;
	$B.visible = !val;


func thisClicked( viewport: Node, event: InputEvent, shape_idx: int )->void:
	#print("clicked!!", event )
	if (event is InputEventScreenTouch and event.is_pressed()):
		emit_signal("clicked", self);
