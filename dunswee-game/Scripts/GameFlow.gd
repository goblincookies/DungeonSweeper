extends Node

var scenes = [	"res://Scenes/01-title.tscn",
				"res://Scenes/02-tutorial.tscn",
				"res://Scenes/03-play.tscn",
				"res://Scenes/04-gameEnd.tscn"]

var currentIndex : int = 0
var currentPage : int = 0
var nextScene : Node
var currentScene : Node
var oldScene : Node

var level : int = 0


func resetLevels()->void:
	level = 0;

func nextLevel()->void:
	level += 1;

func preLoadScene( scene:String )->void:
	print("preloading", scene)
	nextScene = load( scene ).instantiate()

func addScene( scene:Node ) ->void:
	get_tree().root.add_child.call_deferred( scene )
	scene.initiateSceneChange.connect(_on_initiateSceneChange)
	#scene.ready.connect(_on_ready());

func _on_tree_entered() -> void:
	print("entered")
	preLoadScene( scenes[currentIndex] )

func _on_ready() -> void:
	print("ready")
	addScene( nextScene )
	currentIndex = (currentIndex+1)%scenes.size()
	currentScene = nextScene
	preLoadScene( scenes[currentIndex] )

func	 _on_initiateSceneChange( id ) ->void:
	print("I want to change scenes!")
	if (id != currentIndex):
		currentIndex = id;
		preLoadScene( scenes[currentIndex] );
		oldScene = currentScene;
		get_tree().root.remove_child(currentScene)
		oldScene.queue_free();
		addScene( nextScene )
		currentIndex = (currentIndex+1)%scenes.size()
		currentScene = nextScene
		preLoadScene( scenes[currentIndex] )
	else:
		oldScene = currentScene;
		get_tree().root.remove_child(currentScene)
		oldScene.queue_free();
		addScene(nextScene)
		currentIndex = (currentIndex+1)%scenes.size()
		currentScene = nextScene
		preLoadScene( scenes[currentIndex] )
