extends Node

signal clicked
@export var area : Area2D



func _ready() -> void:
	area.input_event.connect( thisClicked );

func thisClicked( viewport: Node, event: InputEvent, shape_idx: int )->void:
	#print("clicked!!", event )
	if (event is InputEventScreenTouch and event.is_pressed()):
		
		emit_signal("clicked")
