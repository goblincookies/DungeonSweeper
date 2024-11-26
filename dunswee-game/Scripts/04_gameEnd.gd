extends Control

signal initiateSceneChange( sceneIndex:int );



func _ready() -> void:
	if (GlobalGame.wonLastGame()):
		$Pages/Won.visible = true;
		$Pages/Lost.visible= false;
	else:
		$Pages/Won.visible = false;
		$Pages/Lost.visible= true;
#
	#pageCount = $Pages.get_child_count()
	#for page in $Pages.get_children():
		#page.visible = false;
	#$Pages.get_child(pageIndex).visible = true;

#func _on_bttn_start_clicked() -> void:
	#print("clicked")
	##emit_signal("initiateSceneChange",  1 )
	#$Pages.get_child(pageIndex).visible = false;
	#pageIndex += 1;
	#if (pageIndex >= pageCount):
		#print("changing scenes")
		#emit_signal("initiateSceneChange",2)
	#else:
		#$Pages.get_child(pageIndex).visible = true;

func _on_bttn_again_clicked() -> void:
	GlobalGame.resetLevels()
	GlobalGame.setContinue(false);
	emit_signal("initiateSceneChange",2)


func _on_bttn_quit_clicked() -> void:
	GlobalGame.resetLevels()
	emit_signal("initiateSceneChange",0)


func _on_bttn_next_clicked() -> void:
	GlobalGame.nextLevel()
	GlobalGame.setContinue(true);
	emit_signal("initiateSceneChange",2)
