extends CanvasLayer

func _ready() -> void:
	_fade_out()

const SCENES: Dictionary[String, PackedScene] = {
	"Main Menu":preload("uid://bd8qt04xi4h20"),
	"Level Select":preload("uid://behlas1qvvn6n"),
	"Level 0":preload("uid://co1sgdv2x4nyr"), # Base level!! Do not use outside of testing!!
	"Level 1":preload("uid://dhwaorb401jhg"),
	#"Level 2":preload(""),
}

func swap_scene(scene_name: String) -> void:
	if !SCENES.has(scene_name): 
		push_error("The scene " + scene_name + " does not exist in our scenes dictionary!!")
		return
	var scene: PackedScene = SCENES.get(scene_name)
	await _fade_in()
	faded.emit()
	get_tree().change_scene_to_packed(scene)
	await _fade_out()
	faded.emit()

@onready var fade: ColorRect = $Fade
signal faded
func _fade_in(time := 0.5) -> Signal:
	var tween := create_tween()
	fade.show()
	tween.tween_property(fade, "modulate:a", 1.0, time).from(0.0)
	return tween.finished

func _fade_out(time := 0.5) -> Signal:
	var tween := create_tween()
	tween.tween_property(fade, "modulate:a", 0.0, time).from(1.0)
	tween.tween_property(fade, "visible", false, 0.0)
	return tween.finished



var current_level := 1
func level_completed(level: int) -> void:
	if level >= current_level:
		current_level += 1
