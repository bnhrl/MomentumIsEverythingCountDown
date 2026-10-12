class_name MusicClass extends Node


func _ready() -> void:
	_load_tracks()
	process_mode = Node.PROCESS_MODE_ALWAYS


const TRACKS_PATH := "res://Assets/Music/"
var tracks: Dictionary[String, AudioStream] = {}
func _load_tracks() -> void:
	for file in ResourceLoader.list_directory(TRACKS_PATH):
		var resource := load(TRACKS_PATH + file)
		if resource is not AudioStream: continue
		tracks.set(file.get_file().get_basename(), resource)


var current_music_player: AudioStreamPlayer
var previous_music_players: Array[AudioStreamPlayer]

func play(track: String, track_fadein: float = 1.0, previous_track_fadeout := 1.0) -> void:
	var stream: AudioStream = tracks.get(track)
	if current_music_player and stream == current_music_player.stream: return
	
	stop(previous_track_fadeout)
	
	current_music_player = AudioStreamPlayer.new()
	add_child(current_music_player)
	current_music_player.bus = &"Music"
	current_music_player.name = "CurrentMusicPlayer"
	current_music_player.stream = stream
	current_music_player.play()
	var tween := create_tween()
	tween.set_ignore_time_scale()
	tween.tween_property(current_music_player, "volume_linear", 1.0, track_fadein).from(0.0)

func stop(fadeout: float = 1.0) -> void:
	var prev := current_music_player
	if not prev: return
	
	previous_music_players.append(prev)
	prev.name = "PreviousMusicPlayer0"
	if prev:
		var tween := prev.create_tween()
		tween.set_ignore_time_scale()
		tween.tween_property(prev, "volume_linear", 0.0, fadeout)
		tween.tween_callback(prev.queue_free)

@onready var music_pitch: AudioEffectPitchShift = AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"), 0)
var pitch_tween: Tween
func set_pitch(pitch := 1.0, time := 0.25) -> void:
	if !music_pitch: return
	
	if pitch_tween: pitch_tween.kill()
	pitch_tween = create_tween()
	pitch_tween.set_ignore_time_scale()
	pitch_tween.tween_property(music_pitch, "pitch_scale", pitch, time)

@onready var music_filter: AudioEffectFilter = AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"), 1)
var filter_tween: Tween
func set_filter(cutoff_hz := 20500, time := 0.1) -> void:
	if !music_filter: return
	
	if filter_tween: filter_tween.kill()
	filter_tween = create_tween()
	filter_tween.set_ignore_time_scale()
	filter_tween.tween_property(music_filter, "cutoff_hz", cutoff_hz, time)
