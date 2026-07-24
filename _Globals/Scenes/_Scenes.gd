extends CanvasLayer

var scenes: Dictionary[String, PackedScene] = {
	#"Main Menu":preload(""),
	"Level Select":preload(""),
	"Base Level":preload("uid://co1sgdv2x4nyr"),
}

func swap_scene(scene_name: String) -> void:
	var scene: PackedScene = scenes.get(scene_name)
	get_tree().change_scene_to_packed(scene)
