extends Node


@onready var sfx_pitch: AudioEffectPitchShift = AudioServer.get_bus_effect(AudioServer.get_bus_index("SoundEffects"), 0)

func _process(delta: float) -> void:
	time_scale = LerpHelper.lf(time_scale, _target_time_scale, 32.0, delta)
	Engine.time_scale = time_scale
	sfx_pitch.pitch_scale = time_scale

var _target_time_scale := 1.0
var time_scale := 1.0

func set_time_scale(ts := 1.0) -> void:
	_target_time_scale = ts

func set_temp_scale(ts := 0.5) -> void:
	time_scale = ts
