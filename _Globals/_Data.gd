extends Node


var save_data: Dictionary = {
	"fullscreen":false,
	"easy_mode":true,
	"current_level":1,
	"best_times": {}
}


func _ready() -> void:
	load_save()


const SAVE_DATA_PATH := "user://save.excitoxicity"
func load_save(path := SAVE_DATA_PATH) -> void:
	var save_file := FileAccess.open(path, FileAccess.READ)
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
	var save_file := FileAccess.open("user://save.excitoxicity", FileAccess.WRITE)
	var json_string := JSON.stringify(save_data)
	save_file.store_line(json_string)
	save_file.close()

func reset_save() -> void:
	Scenes.current_level = 1
	save()


func add_best_time(level: int, time: float) -> void:
	time = snappedf(time, 0.01)
	var l := str(level)
	if PlayerManager.easy_mode: l += "_easy"
	else: l += "_hard"
	
	if time < save_data.get_or_add("best_times", {}).get(l, 9999) and time < 9999:
		save_data.get("best_times").set(l, time)

func get_best_time(level: int) -> float:
	var l := str(level)
	if PlayerManager.easy_mode: l += "_easy"
	else: l += "_hard"
	
	var time: Variant = save_data.get_or_add("best_times", {}).get(l)
	if time and time > 0.0:
		return time
	return -1.0
