extends Control

signal initiateSceneChange( sceneIndex:int );


func _on_bttn_start_clicked() -> void:
	emit_signal("initiateSceneChange",0);
