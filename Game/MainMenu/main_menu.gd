extends Control


func _ready() -> void:
	$LabelBtnDescription.modulate.a = 0.0
	RenderingServer.global_shader_parameter_set("outline_color", Color("9babb2"))
	play_opening()
	await Delays.wait(3.33)
	var tween := create_tween()
	tween.tween_property($FullscreenLabel, "modulate:a", 0.0, 1.5).set_trans(Tween.TRANS_EXPO)

func _process(delta: float) -> void:
	_process_lbd(delta)


# Opening
func play_opening() -> void:
	%Logo.hide()
	$BtnStart.hide()
	$BtnCredits.hide()
	$BtnQuit.hide()
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
	$BtnQuit/CanvasLayer/Clair.play()
	await $BtnQuit/CanvasLayer/Clair.finished
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

func button_unhovered(_button: UIButton) -> void:
	lbd_hovered = false
