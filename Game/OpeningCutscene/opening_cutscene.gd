extends Node2D


func _ready() -> void:
	Camera.limit_enabled = false
	Camera.target = $CameraAnchor
	
	$Start.show()
	$End.hide()
	
	await Delays.wait(2.5)
	
	$Start.hide()
	$End.show()
	
	await Delays.wait(2.5)
	
	for i in range($Squares.get_children().size()):
		$Squares.get_child(i).activate(i * 0.2, 1.5)
	Data.save_data.set("opening_cutscene_watched", true)
	await Delays.wait(1.5 + $Squares.get_children().size() * 0.15)
	Scenes.swap_scene("Level Select")
