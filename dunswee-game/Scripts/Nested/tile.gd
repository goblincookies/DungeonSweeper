extends Control

signal tileClicked;
@export var debugVisually : bool = true;

enum tileTypes {EMPTY, MARKED, ENEMY, KEY};
var thisTileType: tileTypes = tileTypes.EMPTY;

const DOUBLETAP_DELAY : float = 0.25;
var doubleTapTime : float = DOUBLETAP_DELAY;
var fingerDown : bool = false;
var covered : bool = true;
var id : int = 0;
var lowerBounds : int = 0;

var colors : Array = [
	Color( 0,0,0), #black
	Color( 1,0,0),#red
	Color(0,1,0)
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$Enemy.visible = false;
	$Empty.visible = false;
	$Key.visible = false;
	
	$Split.visible = false;
	$EnemyCount.visible = false;
	$KeyCount.visible = false;
	pass # Replace with function body.

func setId( val:int ):
	id = val;
	$id.text = str(id);
func setLowerBounds( val:int ): lowerBounds = val;

func getId()->int: return id;
func getTileType()->tileTypes: return thisTileType;
func isCovered()->bool:return covered;
#00 == blank
#01-08 == enemy count
#10-80 == key count
#
#100 == enemy
#200 == key
func flip():
	covered = false;
	$TitleRevealed.visible = !covered;
	$TitleCovered.visible = covered;
	
func setValue( id ):
	match(id):
		0:
			thisTileType = tileTypes.EMPTY;
			#if (debugVisually): $Empty.visible = true;
		100:
			thisTileType = tileTypes.ENEMY;
			if (debugVisually): $Enemy.visible = true;
		200:
			thisTileType = tileTypes.KEY;
			if (debugVisually): $Key.visible = true;
		_:
			thisTileType = tileTypes.MARKED;
			
			if (id%10 > 0 and id/10 > 0):
#				split
				$Split.visible = true;
				$EnemyCount.visible = false;
				$KeyCount.visible = false;
				$Split/countEnemy.text = str(id%10);
				$Split/countKey.text = str(floor(id/10));
				pass
			elif (id%10 > 0):
				$Split.visible = false;
				$EnemyCount.visible = true;
				$KeyCount.visible = false;
				$EnemyCount/countEnemy.text = str(id%10);
			else:
				$Split.visible = false;
				$EnemyCount.visible = false;
				$KeyCount.visible = true;
				$KeyCount/countKey.text = str(floor(id/10));
				
			#$countEnemy.visible = true;
			#$Count2.visible = true;
			#$countKey.visible = true;
			#$countEnemy.text = str(id%10);
			#$countKey.text = str(floor(id/10));
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (doubleTapTime>0):
		doubleTapTime -= delta

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	#print("input time!", event)
	if( event is InputEventScreenTouch and event.position.y < lowerBounds):
		if (event.is_pressed()):
			if ( !fingerDown ):
				fingerDown = true;
				doubleTapTime = DOUBLETAP_DELAY;
			
		if (event.is_released()):
			fingerDown = false;
			if (doubleTapTime >= 0 ):
				if (covered):
					emit_signal("tileClicked", self);
					#covered = false;
					#$TitleCovered.visible = false;
					#$TitleRevealed.visible = true;

func randomColor():
	$ColorRect.color = Color(randf(),randf(),randf());
