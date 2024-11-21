extends Node

signal clicked
@export var area : Area2D


enum ActionTypes {BASIC, ENEMY, KEY}
@export var buttonType: ActionTypes



func _ready() -> void:
	area.input_event.connect( thisClicked );

func setActive( val ):
	$A.visible = val;
	$B.visible = !val;

func getButtonAction()->ActionTypes:return buttonType;

func thisClicked( viewport: Node, event: InputEvent, shape_idx: int )->void:
	#print("clicked!!", event )
	if (event is InputEventScreenTouch and event.is_pressed()):
		emit_signal("clicked", self);
