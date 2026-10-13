extends Control


func _ready() -> void:
	_ready_background()
	$SliderMusic.value = Data.save_data.get("vol_mus", 100.0)
	$SliderSFX.value = Data.save_data.get("vol_sfx", 100.0)

func _process(delta: float) -> void:
	_process_background(delta)


var backgrounds: Array[Sprite2D]
func _ready_background() -> void:
	for child in $Background.get_children():
		if child is Sprite2D:
			backgrounds.append(child)
			child.modulate.r = randf_range(0.25, 1.0)
			child.modulate.g = randf_range(0.25, 1.0)
			child.modulate.b = randf_range(0.25, 1.0)

func _process_background(delta: float) -> void:
	for b in backgrounds:
		b.modulate.h += delta * 0.2


func _on_vol_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		Data.update_audio_settings($SliderMusic.value, $SliderSFX.value)


func _on_btn_main_menu_pressed() -> void:
	Scenes.swap_scene("Main Menu")
