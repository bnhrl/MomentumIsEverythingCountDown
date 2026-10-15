extends Control


func _ready() -> void:
	_ready_background()
	$SliderMusic.value = Data.save_data.get("vol_mus", 100.0)
	$SliderSFX.value = Data.save_data.get("vol_sfx", 100.0)
	$CheckBrainFog.button_pressed = Data.save_data.get("brain_fog", true)
	$CheckVSync.button_pressed = Data.save_data.get("vsync", true)

func _process(delta: float) -> void:
	_process_background(delta)


# Backgrounds
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


# Back To Menu
func _on_btn_main_menu_pressed() -> void:
	Data.save()
	Scenes.swap_scene("Main Menu")


# Settings
func _on_vol_slider_drag_ended(value_changed: bool) -> void:
	$LabelSFX/AudioPlayer.play()
	if value_changed:
		Data.update_audio_settings($SliderMusic.value, $SliderSFX.value)
	if $SliderMusic.value == 0.0:
		$SliderMusic/AngryCuptain.show()
	else:
		$SliderMusic/AngryCuptain.hide()

func _on_check_brain_fog_toggled(toggled_on: bool) -> void:
	Data.save_data.set("brain_fog", toggled_on)

func _on_check_v_sync_toggled(toggled_on: bool) -> void:
	Data.save_data.set("vsync", toggled_on)
	Data.update_vsync_settings()
