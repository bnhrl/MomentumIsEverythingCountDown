class_name LevelSelect extends Control

func _ready() -> void:
	RenderingServer.global_shader_parameter_set("outline_color", Color("9babb2"))
	var level_buttons := $LevelButtons.get_children()
	for i in range(level_buttons.size()):
		if level_buttons[i] is LevelButton:
			if level_buttons[i].level > Scenes.current_level:
				level_buttons[i].hide()

func _on_btn_main_menu_pressed() -> void:
	Scenes.swap_scene("Main Menu")

func _on_btn_show_level_buttons_pressed() -> void:
	for child in $LevelButtons.get_children():
		child.show()
