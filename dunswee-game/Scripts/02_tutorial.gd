extends Control

signal initiateSceneChange( sceneIndex:int );

var pageCount : int  = 0;
var pageIndex : int = 0;

func _ready() -> void:
	pageCount = $Pages.get_child_count()
	for page in $Pages.get_children():
		page.visible = false;
	$BttnStart.writeButtonText("Next");
	$Pages.get_child(pageIndex).visible = true;
	
	
func _on_bttn_start_clicked() -> void:
	print("clicked");
	#emit_signal("initiateSceneChange",  1 )
	$Pages.get_child(pageIndex).visible = false;
	pageIndex += 1;
	if (pageIndex >= pageCount):
		print("changing scenes")
		emit_signal("initiateSceneChange",2)
	else:
		$Pages.get_child(pageIndex).visible = true;
		if (pageIndex+1 >= pageCount):
			$BttnStart.writeButtonText("Play");
