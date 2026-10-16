extends Node


var save_data: Dictionary = {
	"fullscreen":false,
	"easy_mode":true,
	"current_level":1,
	"best_times": {},
	"vol_mus":100.0,
	"vol_sfx":100.0,
	"brain_fog":true,
	"vsync":1,
}


var presence: DiscordRichPresence
func _ready() -> void:
	load_save()
	presence = DiscordRichPresence.new()
	presence.app_id = "1530988478408691713"
	add_child(presence)
	presence.set_activity({"details": "Main Menu", "state": "Considering what to do."})


# Actual Save Stuff
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
	update_audio_settings()
	update_vsync_settings()

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


# Settings
func update_audio_settings(vol_mus: float = save_data.get("vol_mus", 100.0), vol_sfx: float = save_data.get("vol_sfx", 100.0)) -> void:
	save_data.set("vol_mus", vol_mus)
	save_data.set("vol_sfx", vol_sfx)
	AudioServer.set_bus_volume_linear(1, vol_sfx * 0.01)
	AudioServer.set_bus_volume_linear(2, vol_mus * 0.01)

func update_vsync_settings() -> void:
	DisplayServer.window_set_vsync_mode(save_data.get("vsync", 1) as DisplayServer.VSyncMode)

# Best Times
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
