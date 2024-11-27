extends Control

@export var playNode : Control
enum TileTypes {EMPTY, MARKED, ENEMY, KEY, HEALTH};
enum FlagTypes {UNMARKED, ENEMY, KEY};

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#
	#
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setupBanners():
	$bannerHealth.setValue( playNode.getCount(TileTypes.HEALTH));
	$bannerEnemy.setValue( playNode.getStartingFlags(FlagTypes.ENEMY));
	$bannerKey.setValue( playNode.getStartingFlags(FlagTypes.KEY));

func usedFlag( type:FlagTypes )->void:
	adjustBanner(type, -1);

func returnedFlag( type:FlagTypes )->void:
	adjustBanner(type, 1);

func adjustBanner( type:FlagTypes, amount:int )->void:
	match type:
		FlagTypes.ENEMY:
			$bannerEnemy.adjustVal(amount);
		FlagTypes.KEY:
			$bannerKey.adjustVal(amount);

func updateHealth( totalHealthRemaining: int )->void:
	$bannerHealth.setValue( totalHealthRemaining );
