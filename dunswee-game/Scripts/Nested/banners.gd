extends Control

@export var playNode : Control
enum TileTypes {EMPTY, MARKED, ENEMY, KEY, HEALTH};
enum FlagTypes {UNMARKED, ENEMY, KEY};

func setupBanners():
	$bannerHealth.setValue( playNode.getCount(TileTypes.HEALTH));
	$bannerEnemy.setValue( playNode.getStartingFlags(FlagTypes.ENEMY));
	$bannerKey.setValue( playNode.getStartingFlags(FlagTypes.KEY));
	$Keys.text= "Keys: %0d" % playNode.getCount(TileTypes.KEY);
	$Enemies.text= "Enemies: %0d" % playNode.getCount(TileTypes.ENEMY);
	$Level.text= "Level: %0d" % GlobalGame.getLevel();

func startTimer()->void: $bannerTimer.startTimer();
func saveTime()->void: $bannerTimer.saveTime();
func stopTimer()->void: $bannerTimer.stopTimer();

func usedFlag( type:FlagTypes )->void: adjustBanner(type, -1);

func returnedFlag( type:FlagTypes )->void: adjustBanner(type, 1);

func adjustBanner( type:FlagTypes, amount:int )->void:
	match type:
		FlagTypes.ENEMY:
			$bannerEnemy.adjustVal(amount);
		FlagTypes.KEY:
			$bannerKey.adjustVal(amount);

func updateHealth( totalHealthRemaining: int )->void:
	$bannerHealth.setValue( totalHealthRemaining );
