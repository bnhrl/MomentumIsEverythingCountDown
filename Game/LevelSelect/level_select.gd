class_name LevelSelect extends Control

func _ready() -> void:
	RenderingServer.global_shader_parameter_set("outline_color", Color("9babb2"))
	var level_buttons := $LevelButtons.get_children()
	for i in range(level_buttons.size()):
		if level_buttons[i] is LevelButton:
			if level_buttons[i].level > Scenes.current_level:
				level_buttons[i].hide()
	if Scenes.current_level >= 11:
		$Brain/Brain.texture = preload("uid://b6pf0e8m7bidm")
	elif Scenes.current_level >= 9:
		$Brain/Brain.texture = preload("uid://dhsdoswq62d2")
	elif Scenes.current_level >= 4:
		$Brain/Brain.texture = preload("uid://66tu2soentk")
	
	if PlayerManager.easy_mode:
		$BtnMode.text = "Swap to Normal Mode"

func _on_btn_main_menu_pressed() -> void:
	Scenes.swap_scene("Main Menu")

func _on_btn_show_level_buttons_pressed() -> void:
	for child in $LevelButtons.get_children():
		child.show()


func _on_btn_mode_pressed() -> void:
	if PlayerManager.easy_mode:
		PlayerManager.easy_mode = false
		$BtnMode.text = "Swap to easy mode"
	else:
		PlayerManager.easy_mode = true
		$BtnMode.text = "Swap to Normal Mode"
