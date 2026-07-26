extends Control


func _ready() -> void:
	RenderingServer.global_shader_parameter_set("outline_color", Color("9babb2"))
	await Delays.wait(3.33)
	var tween := create_tween()
	tween.tween_property($FullscreenLabel, "modulate:a", 0.0, 1.5).set_trans(Tween.TRANS_EXPO)

func _on_btn_start_pressed() -> void:
	Scenes.swap_scene("Level Select")

var credits: Control
func _on_btn_credits_pressed() -> void:
	if credits: return
	credits = preload("uid://og05ddis16cd").instantiate()
	add_child(credits)

func _on_btn_quit_pressed() -> void:
	Effects.obscure()
	$BtnQuit/CanvasLayer/Clair.play()
	await $BtnQuit/CanvasLayer/Clair.finished
	get_tree().quit()
