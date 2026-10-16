extends Control


func _ready() -> void:
	_ready_background()
	$SliderMusic.value = Data.save_data.get("vol_mus", 100.0)
	$SliderSFX.value = Data.save_data.get("vol_sfx", 100.0)
	$CheckBrainFog.button_pressed = Data.save_data.get("brain_fog", false)
	$CheckVSync.button_pressed = Data.save_data.get("vsync", true)
	if $SliderMusic.value == 0.0:
		$SliderMusic/AngryCuptain.show()

func _process(delta: float) -> void:
	_process_background(delta)
	_process_lbd(delta)


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
	Music.set_filter(20500, 0.25)
	Data.save()
	Scenes.swap_scene("Main Menu")


# Settings
func _on_vol_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		Data.update_audio_settings($SliderMusic.value, $SliderSFX.value)
	if $SliderMusic.value == 0.0:
		$SliderMusic/AngryCuptain.show()
	else:
		$SliderMusic/AngryCuptain.hide()
	Music.set_filter(200, 1.5)

func _on_slider_music_drag_started() -> void:
	Music.set_filter()

func _on_slider_sfx_drag_ended(_value_changed: bool) -> void:
	$LabelSFX/AudioPlayer.play()

func _on_check_brain_fog_toggled(toggled_on: bool) -> void:
	Data.save_data.set("brain_fog", toggled_on)

func _on_check_v_sync_toggled(toggled_on: bool) -> void:
	Data.save_data.set("vsync", toggled_on)
	Data.update_vsync_settings()

func _on_discord_rpc_toggled(toggled_on: bool) -> void:
	Data.save_data.set("discord_rpc", toggled_on)
	if toggled_on:
		Data.create_discord_rpc()
	else:
		Data.destroy_discord_rpc()


# LBD
func _process_lbd(delta: float) -> void:
	label_btn_description.modulate.a = LerpHelper.lf(label_btn_description.modulate.a, lbd_hovered, 8.0, delta)

var lbd_hovered := false
@onready var label_btn_description: RichTextLabel = $LabelBtnDescription
func setting_hovered(control: Control) -> void:
	lbd_hovered = true
	if control == $LabelFullscreen:
		label_btn_description.text = "Exactly what it says."
	elif control == $SliderMusic:
		label_btn_description.text = "Change the volume of the game's music."
	elif control == $SliderSFX:
		label_btn_description.text = "Change the volume of the game's sound effects."
	elif control == $CheckBrainFog:
		label_btn_description.text = "Toggles brain fog on and off. Brain fog appears when repeatedly slamming into walls."
	elif control == $CheckVSync:
		label_btn_description.text = "Toggles V-Sync on and off."
	elif control == $DiscordRPC:
		label_btn_description.text = "Toggles Discord Rich Presence on and off."
	else:
		label_btn_description.text = "I don't know what this one does."

func setting_unhovered(_control: Control) -> void:
	lbd_hovered = false
