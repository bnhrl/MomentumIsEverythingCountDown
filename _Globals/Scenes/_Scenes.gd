extends CanvasLayer

var scenes: Dictionary[String, PackedScene] = {
	"Main Menu":preload("uid://bd8qt04xi4h20"),
	"Level Select":preload("uid://behlas1qvvn6n"),
	"Level 0":preload("uid://co1sgdv2x4nyr"), # Base level!! Do not use outside of testing!!
	#"Level 1":preload(""),
}

func swap_scene(scene_name: String) -> void:
	if !scenes.has(scene_name): 
		push_error("The scene " + scene_name + " does not exist in our scenes dictionary!!")
		return
	var scene: PackedScene = scenes.get(scene_name)
	get_tree().change_scene_to_packed(scene)
