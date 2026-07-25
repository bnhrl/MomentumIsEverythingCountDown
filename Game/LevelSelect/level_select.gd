class_name LevelSelect extends Control

func _ready() -> void:
	RenderingServer.global_shader_parameter_set("outline_color", Color("9babb2"))

func _on_btn_main_menu_pressed() -> void:
	Scenes.swap_scene("Main Menu")
