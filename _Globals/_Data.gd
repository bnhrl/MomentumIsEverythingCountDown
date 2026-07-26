extends Node


var save_data: Dictionary = {
	"fullscreen":false,
	"easy_mode":false,
	"current_level":1,
}

func _ready() -> void:
	load_save()

func load_save() -> void:
	var save_file := FileAccess.open("user://save.exitoxicity", FileAccess.READ)
	if !save_file: 
		save()
		return
	var json_string := save_file.get_line()
	var data: Variant = JSON.parse_string(json_string)
	if data is not Dictionary:
		return
	save_data = data
	save_file.close()
	Scenes.current_level = save_data.get("current_level", 1)
	if save_data.get("fullscreen"): DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	PlayerManager.easy_mode = save_data.get("easy_mode")

func save() -> void:
	var fullscreen := false
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN: fullscreen = true
	save_data.set("fullscreen", fullscreen)
	save_data.set("easy_mode", PlayerManager.easy_mode)
	save_data.set("current_level", Scenes.current_level)
	var save_file := FileAccess.open("user://save.exitoxicity", FileAccess.WRITE)
	var json_string := JSON.stringify(save_data)
	save_file.store_line(json_string)
	save_file.close()
	
