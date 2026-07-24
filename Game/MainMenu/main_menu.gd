extends Control


func _on_btn_start_pressed() -> void:
	Scenes.swap_scene("Level Select")

func _on_btn_credits_pressed() -> void:
	pass # TODO make credits screen. Presumably a little drop down into the main menu instead of a different scene?

func _on_btn_quit_pressed() -> void:
	$BtnQuit/CanvasLayer/Clair.play()
	$BtnQuit/CanvasLayer/Obscur.show()
	var tween := create_tween()
	tween.tween_property($BtnQuit/CanvasLayer/Obscur, "modulate:a", 1.0, 0.2).from(0.0)
	await $BtnQuit/CanvasLayer/Clair.finished
	get_tree().quit()
