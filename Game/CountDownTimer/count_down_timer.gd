class_name CountDownTimer extends CanvasLayer

@onready var label: RichTextLabel = $Label
@onready var beat_timer: Timer = $BeatTimer

@export var time := 30.0
@onready var max_time := time

func _process(delta: float) -> void:
	_process_background()
	if has_expired: return
	
	_process_counting(delta)
	_process_expiration()


# Counting
func _process_counting(delta: float) -> void:
	time -= delta
	label.text = str(snappedf(time, 0.1))
	label.modulate = LerpHelper.l(label.modulate, Color.WHITE, 16.0, delta)
	label.offset_transform_scale = LerpHelper.lv2(label.offset_transform_scale, Vector2(1,1), 16.0, delta)
	
	if time <= max_time*0.5 and beat_timer.is_stopped():
		beat()
		beat_timer.start(clampf(time*0.1, 0.25, 5.0))


# Beating
func _on_beat_timer_timeout() -> void:
	beat()

func beat() -> void:
	label.modulate = Color.RED
	label.offset_transform_scale = Vector2(1.25, 1.25)
	beat_sound()

@onready var sound_player: AudioStreamPlayer = $SoundPlayer
const BEAT_SOUNDS := [preload("uid://bw2v7g84dqasy"),preload("uid://bnciwk4cpicw7"),preload("uid://cqldb2pvo4yil")]
func beat_sound() -> void:
	sound_player.stream = BEAT_SOUNDS[randi_range(0,2)]
	sound_player.pitch_scale = clampf(randf_range(0.9, 1.1) + (max_time*0.5/time)-0.2, 0.9, 2.0)
	sound_player.play()


# Expiration
signal expired

func _process_expiration() -> void:
	if time <= 0.0 and !has_expired:
		expire()
		time = 0.0
		label.text = "0.0"

var has_expired := false
func expire() -> void:
	has_expired = true
	expired.emit()
	await Delays.wait(0.25)
	var tween := create_tween()
	tween.parallel().tween_property(label, "position:y", 800, 1.0+randf_range(-0.2,0.2)).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property(label, "rotation_degrees", randf_range(-30, 30), 1.0+randf_range(-0.2,0.2))
	for b: Node2D in backgrounds:
		tween.parallel().tween_property(b, "position:y", 800, 1.0+randf_range(-0.2,0.2)).set_trans(Tween.TRANS_EXPO)
		tween.parallel().tween_property(b, "rotation_degrees", randf_range(-30, 30), 1.0+randf_range(-0.2,0.2))

# Backgrounds
@onready var backgrounds := [$Background0, $Background1]
func _process_background() -> void:
	if time > max_time*0.5 or has_expired: 
		return
	
	for b: Node2D in backgrounds:
		var rand_x := clampf(randf_range(-max_time*0.5/time, max_time/time)+0.01, -8.0, 8.0)*0.2
		var rand_y := clampf(randf_range(-max_time*0.5/time, max_time/time)+0.01, -8.0, 8.0)*0.2
		b.offset = Vector2(rand_x, rand_y)
	
