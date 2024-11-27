extends Node

signal clicked
@export var area : Area2D
@export var buttonText : String;


func _ready() -> void:
	area.input_event.connect( thisClicked );
	writeButtonText(buttonText);

func writeButtonText( val )->void:
	$ButtonText.text = val;

func thisClicked( viewport: Node, event: InputEvent, shape_idx: int )->void:
	#print("clicked!!", event )
	if (event is InputEventScreenTouch and event.is_pressed()):
		
		emit_signal("clicked")
