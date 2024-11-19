extends Control

const DOUBLETAP_DELAY : float = 0.15;
var doubleTapTime : float = DOUBLETAP_DELAY;
var lastKeyCode : int = 0;
var fingerDown : bool = false;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (doubleTapTime>0):
		doubleTapTime -= delta

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
		if (event is InputEventScreenTouch and event.is_pressed()):
			if ( !fingerDown ):
				fingerDown = true;
				doubleTapTime = DOUBLETAP_DELAY;
			
		if (event is InputEventScreenTouch and event.is_released()):
			fingerDown = false;
			if (doubleTapTime >= 0 ):
				randomColor();

func randomColor():
	$ColorRect.color = Color(randf(),randf(),randf());
