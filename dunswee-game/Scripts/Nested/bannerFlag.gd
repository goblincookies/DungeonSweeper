extends Control


enum BannerTypes {TIMER, HEALTH, ENEMY, KEY};
@export var bannerType: BannerTypes;

var bannerVal : int = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$IconHealth.visible = false;
	$IconKey.visible = false;
	$IconSkull.visible = false;
	match bannerType:
		BannerTypes.HEALTH:
			$IconHealth.visible = true;
		BannerTypes.ENEMY:
			$IconSkull.visible = true;
		BannerTypes.KEY:
			$IconKey.visible = true;
		BannerTypes.TIMER:
			pass


func setValue( val:int )->void:
	bannerVal = val;
	$Val.text = str(bannerVal);

func adjustVal( amount:int )->void:
	bannerVal += amount;
	$Val.text = str(bannerVal);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
