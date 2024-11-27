extends Control

signal initiateSceneChange( sceneIndex:int );


@export var topBanners : Control
@export var field : Control

@export var enemyCount : int
@export var keyCount : int
@export var healthCount : int
@export var startingFlagsEnemy : int
@export var startingFlagsKey : int
@export var gridContainer : GridContainer;

var flagsRemainingEnemy:int = 0;
var flagsRemainingKey:int = 0;
var remainingHealth : int = 0;

var remainingEnemyTiles : Array = [];
var remainingKeyTiles : Array = [];

enum FlagTypes {UNMARKED, ENEMY, KEY};
enum ActionTypes {BASIC, FLAGENEMY, FLAGKEY, ESCAPE};
enum TileTypes {EMPTY, MARKED, ENEMY, KEY, HEALTH};
enum BannerTypes {TIMER, HEALTH, ENEMY, KEY};
var currentAction : ActionTypes = ActionTypes.BASIC;


func _ready() -> void:
	
	if GlobalGame.isContinuing():
		healthCount = GlobalGame.getHealth();

	flagsRemainingEnemy = startingFlagsEnemy;
	flagsRemainingKey = startingFlagsKey;
	remainingHealth = healthCount;
	print("setting up buttons")
	currentAction = ActionTypes.BASIC;
	
	for bttn in $Buttons.get_children():
	
		if (bttn.getButtonAction()==currentAction):
			bttn.setActive(true);
		else:
			bttn.setActive(false);
	
	topBanners.setupBanners();
	
	var tweenScroll : Tween = get_tree().create_tween();
	tweenScroll.tween_property($Game/Field/ScrollContainer, "scroll_horizontal", 200, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT);
	tweenScroll.set_parallel();
	tweenScroll.tween_property($Game/Field/ScrollContainer, "scroll_vertical", 200, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT);


func isAlive()->bool:
	return (remainingHealth>0)

func getCount( type:int )->int:
	match type:
		TileTypes.ENEMY:
			return enemyCount;
		TileTypes.KEY:
			return keyCount;
		TileTypes.HEALTH:
			return healthCount;
	return 0;

func getStartingFlags(type:FlagTypes)->int:
	match type:
		FlagTypes.ENEMY:
			return startingFlagsEnemy;
		FlagTypes.KEY:
			return startingFlagsKey;
	return 0;

func hasFlagsRemaining(type:FlagTypes)->bool:
	match type:
		FlagTypes.ENEMY:
			return flagsRemainingEnemy > 0;
		FlagTypes.KEY:
			return flagsRemainingKey > 0;
	return false;

func getCurrentAction()->ActionTypes: return currentAction;


func _on_bttn_start_clicked() -> void:
	emit_signal("initiateSceneChange",0);

func checkForWin()->void:
	#if (field.keysNotCleared()):
	remainingEnemyTiles = field.getRemainingEnemies();
	remainingKeyTiles = field.getRemainingKeys();
	
	#var scrollPos : Vector2 = Vector2($Game/Field/ScrollContainer.scroll_horizontal, $Game/Field/ScrollContainer.scroll_vertical);

	if remainingEnemyTiles.size()>0:
		print(remainingEnemyTiles[0].position);
		#scrollPos = remainingEnemyTiles[0].position;
	elif remainingKeyTiles.size()>0:
		print(remainingKeyTiles[0].position);
		
		#scrollPos = remainingKeyTiles[0].position;

	#var tweenScroll : Tween = get_tree().create_tween();
	#tweenScroll.tween_property($Game/Field/ScrollContainer, "scroll_horizontal", scrollPos.x, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT);
	#tweenScroll.set_parallel();
	#tweenScroll.tween_property($Game/Field/ScrollContainer, "scroll_vertical", scrollPos.y, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT);
	
	$EscapeTimer.start();



func _on_bttn_base_game_clicked( clickedButton: Control ) -> void:
	if(currentAction != ActionTypes.ESCAPE):
		currentAction = clickedButton.getButtonAction();
		for bttn in $Buttons.get_children():
			bttn.setActive(false);

		clickedButton.setActive(true);

	if (currentAction == ActionTypes.ESCAPE): checkForWin();



func _on_field_flagged(type: FlagTypes) -> void:
#	DECREASE FLAGS
	match type:
		FlagTypes.ENEMY:
			flagsRemainingEnemy -=1;
		FlagTypes.KEY:
			flagsRemainingKey -=1;
	topBanners.usedFlag( type )


func _on_field_hit(type: TileTypes) -> void:
	print("hiT!! :(")
	
	if (remainingHealth >0 ):
		remainingHealth -= 1;
		#$Top/Banners.updateHealth( remainingHealth );
		topBanners.updateHealth( remainingHealth );
	
	if (remainingHealth <= 0):
		print("dead")
		$GameEndTimer.start();
	pass # Replace with function body.


func _on_field_unflagged(type: TileTypes) -> void:
	match type:
		FlagTypes.ENEMY:
			flagsRemainingEnemy +=1;
		FlagTypes.KEY:
			flagsRemainingKey +=1;
	topBanners.returnedFlag( type )


func _on_game_end_timer_timeout() -> void:
	#GlobalGame.setWinStatus( remainingHealth>0)
	GlobalGame.setHealth(remainingHealth);
	print("switching scenes");
	emit_signal("initiateSceneChange",3);


func _on_escape_timer_timeout() -> void:
	print(remainingEnemyTiles.size())
	print(remainingKeyTiles.size())
	var scrollPos : Vector2;

	if (remainingEnemyTiles.size() > 0):
		var tile : Control = remainingEnemyTiles.pop_front();
		tile.flip();
		_on_field_hit(TileTypes.ENEMY);
		scrollPos = tile.position;
		var tweenScroll : Tween = get_tree().create_tween();
		
		tweenScroll.tween_property($Game/Field/ScrollContainer, "scroll_horizontal", scrollPos.x/2, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT);
		tweenScroll.set_parallel();
		tweenScroll.tween_property($Game/Field/ScrollContainer, "scroll_vertical", scrollPos.y/2, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT);

		$EscapeTimer.start();

	elif (remainingKeyTiles.size() > 0 ):
		var tile : Control = remainingKeyTiles.pop_front();
		tile.flip();
		_on_field_hit(TileTypes.KEY);
		scrollPos = tile.position;
		var tweenScroll : Tween = get_tree().create_tween();
		
		tweenScroll.tween_property($Game/Field/ScrollContainer, "scroll_horizontal", scrollPos.x/2, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT);
		tweenScroll.set_parallel();
		tweenScroll.tween_property($Game/Field/ScrollContainer, "scroll_vertical", scrollPos.y/2, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT);

		$EscapeTimer.start();

	else:
		$GameEndTimer.start();
		#if (remainingHealth <= 0):
			#print("dead")
