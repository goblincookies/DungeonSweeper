extends Control


enum BannerTypes {TIMER, HEALTH, ENEMY, KEY};
@export var bannerType: BannerTypes;

var bannerVal : int = 0;
var time : float = 0;
var sec : int = 0;
var min : int = 0;
var begin : bool = false;

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
			time = GlobalGame.getSavedTime();
			$Seconds.visible = true;
			$Minutes.visible = true;
			$Spacer.visible = true;
			writeTime();

func _process(delta: float) -> void:
	if(begin and bannerType == BannerTypes.TIMER):
		time += (delta);
		writeTime();

		

func writeTime()->void:
	sec = fmod(time, 60);
	min = fmod(time,3600)/60;
	$Seconds.text = "%02d" % sec;
	$Minutes.text = "%02d" % min;

func startTimer()->void: begin = true;
func stopTimer()->void: begin = false;

func setValue( val:int )->void:
	bannerVal = val;
	$Val.text = str(bannerVal);

func adjustVal( amount:int )->void:
	bannerVal += amount;
	$Val.text = str(bannerVal);
#func getSavedTime()->void:
	#time = GlobalGame.getSavedTime();
func saveTime()->void:
	GlobalGame.saveTime( time );
