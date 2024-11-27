extends Control

signal tileClicked;
@export var debugVisually : bool = true;

#enum ActionTypes {EMPTY, MARKED, ENEMY, KEY};
#enum TileTypes {ENEMY, KEY, HEALTH};
enum FlagTypes {UNMARKED, ENEMY, KEY};
enum ActionTypes {BASIC, FLAGENEMY, FLAGKEY, ESCAPE};
enum TileTypes {EMPTY, MARKED, ENEMY, KEY, HEALTH};

var thisTileType: TileTypes = TileTypes.EMPTY;
var flag: FlagTypes = FlagTypes.UNMARKED;
var flagColorKey : Color = Color("#ffff00");
var flagColorEnemy : Color = Color("#ff0000");
var flagColorUnmarked : Color = Color("#ffffff");

var animations : Array = [
	"res://Assets/Animations/alien.tres",
	"res://Assets/Animations/bats.tres",
	"res://Assets/Animations/boar.tres"
]

const DOUBLETAP_DELAY : float = 0.35;
var doubleTapTime : float = DOUBLETAP_DELAY;
var fingerDown : bool = false;
var covered : bool = true;
var marked : bool = false;
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

func isFlaggedCorrectly()->bool:
	if (!covered):return true;
	if (thisTileType == TileTypes.ENEMY):
		return (flag == FlagTypes.ENEMY)
	if (thisTileType == TileTypes.KEY):
		return (flag == FlagTypes.KEY)
	return false;

func getId()->int: return id;
func getTileType()->TileTypes: return thisTileType;
func isCovered()->bool:return covered;
func isMarked()->bool:return marked;
func getFlag()->FlagTypes:return flag;
#00 == blank
#01-08 == enemy count
#10-80 == key count
#
#100 == enemy
#200 == key
func flip():
	#flagTile(0);
	covered = false;
	$TitleRevealed.visible = !covered;
	$TitleCovered.visible = covered;

func flagTile( type:int ):
	#if (flag != type):
	if (type == FlagTypes.UNMARKED):
		self.modulate = flagColorUnmarked;
		marked = false;
		#flag = FlagTypes.UNMARKED;
	elif (type == flag):
		marked = !marked;
	else:
		marked = true;
	
	if (marked):
		flag = type;
		match type:
			FlagTypes.ENEMY:
				self.modulate = flagColorEnemy;
			FlagTypes.KEY:
				self.modulate = flagColorKey;
	else:
		flag = FlagTypes.UNMARKED;
		self.modulate = flagColorUnmarked;


func setValue( id ):
	match(id):
		0:
			thisTileType = TileTypes.EMPTY;
			#if (debugVisually): $Empty.visible = true;
		100:
			thisTileType = TileTypes.ENEMY;
			if (debugVisually): $Enemy.visible = true;
		200:
			thisTileType = TileTypes.KEY;
			if (debugVisually): $Key.visible = true;
		_:
			thisTileType = TileTypes.MARKED;
			
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
