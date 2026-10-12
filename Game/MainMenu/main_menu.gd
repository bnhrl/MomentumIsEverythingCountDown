extends Control


func _ready() -> void:
	$LabelBtnDescription.modulate.a = 0.0
	RenderingServer.global_shader_parameter_set("outline_color", Color("9babb2"))
	prepare_opening()
	get_window().files_dropped.connect(_on_files_dropped)
	
	if OS.get_name() == "Web":
		$BtnExport.show()
		if not Data.save_data.get("warning_accepted", false):
			$WebWarning.show()
			await %BtnWebWarning.pressed
			Data.save_data.set("warning_accepted", true)
			Data.save()
	$WebWarning.queue_free()
	play_opening()
	await Delays.wait(3.33)
	var tween := create_tween()
	tween.tween_property($FullscreenLabel, "modulate:a", 0.0, 1.5).set_trans(Tween.TRANS_EXPO)

func _process(delta: float) -> void:
	_process_lbd(delta)


# Opening
func prepare_opening() -> void:
	%Logo.hide()
	$BtnStart.hide()
	$BtnCredits.hide()
	$BtnQuit.hide()

func play_opening() -> void:
	await Delays.wait(0.25)
	%Logo.show()
	$BtnStart.show()
	$BtnCredits.show()
	$BtnQuit.show()
	var tween := create_tween()
	tween.tween_property(%Logo, "scale:x", 1.0, 1.25).set_trans(Tween.TRANS_ELASTIC).from(0.001).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(%Logo, "scale:y", 1.0, 1.5).set_trans(Tween.TRANS_ELASTIC).from(0.001).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property($BtnStart, "position:y", $BtnStart.position.y, 1.25).set_trans(Tween.TRANS_EXPO).from($BtnStart.position.y + 400)
	tween.parallel().tween_property($BtnCredits, "position:y", $BtnCredits.position.y, 1.5).set_trans(Tween.TRANS_EXPO).from($BtnCredits.position.y + 400)
	tween.parallel().tween_property($BtnQuit, "position:y", $BtnQuit.position.y, 1.5).set_trans(Tween.TRANS_EXPO).from($BtnQuit.position.y + 400)


# Buttons
func _on_btn_start_pressed() -> void:
	Scenes.swap_scene("Level Select")

var credits: Control
func _on_btn_credits_pressed() -> void:
	if credits: return
	credits = preload("uid://og05ddis16cd").instantiate()
	add_child(credits)

func _on_btn_quit_pressed() -> void:
	Effects.obscure()
	Music.play("Clair de Lune", 0.2, 0.2)
	await Music.current_music_player.finished
	get_tree().quit()


# LBD
func _process_lbd(delta: float) -> void:
	label_btn_description.modulate.a = LerpHelper.lf(label_btn_description.modulate.a, lbd_hovered, 8.0, delta)

@onready var label_btn_description: RichTextLabel = $LabelBtnDescription
var lbd_hovered := false
func button_hovered(button: UIButton) -> void:
	lbd_hovered = true
	if button == $BtnStart:
		label_btn_description.text = "[wave]Start playing the game."
	elif button == $BtnCredits:
		label_btn_description.text = "[wave]View the credits for the game."
	elif button == $BtnQuit:
		label_btn_description.text = "[wave]Close the game and exit to desktop."
	elif button == $BtnExport:
		label_btn_description.text = "[wave]Export your save data. Drag and drop the file onto the game to load it."

func button_unhovered(_button: UIButton) -> void:
	lbd_hovered = false


# Reset & Export
var warnings_till_reset := 4
func _on_btn_reset_pressed() -> void:
	warnings_till_reset -= 1
	match warnings_till_reset:
		3: $BtnReset.text = "you sure?"
		2: $BtnReset.text = "really sure?"
		1: $BtnReset.text = "last chance..."
		0: 
			$BtnReset.text = "save deleted"
			Data.reset_save()

func _on_btn_export_pressed() -> void:
	Data.save()
	var buffer := FileAccess.get_file_as_bytes(Data.SAVE_DATA_PATH)
	JavaScriptBridge.download_buffer(buffer, "save.excitoxicity")

func _on_files_dropped(files: PackedStringArray) -> void:
	for file in files:
		if file.right(13) == ".excitoxicity":
			Data.load_save(file)
			print("Succesfully loaded " + file + " as a save!")
			return
