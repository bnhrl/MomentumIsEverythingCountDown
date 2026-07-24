extends Camera2D

func _ready() -> void:
	_ready_shake()


func _process(delta: float) -> void:
	_process_following()
	_process_zoom(delta)
	_process_shake(delta)


# Following
var target: Node2D
@onready var target_position := get_viewport_rect().size/2.0

func _process_following() -> void:
	if target:
		target_position = target.global_position + camera_shake
	else:
		target_position = get_viewport_rect().size/2.0
	global_position = target_position


# Zoom
func _process_zoom(delta: float) -> void:
	var z := 1.0 + (1.0-GameTime.time_scale)*0.1
	var target_zoom := Vector2(z,z)
	zoom = LerpHelper.lv2(zoom, target_zoom, 16.0, delta)


# Camera Shake
@onready var noise_x := FastNoiseLite.new()
@onready var noise_y := FastNoiseLite.new()
var shake := 0.0
var camera_shake := Vector2.ZERO
func _ready_shake() -> void:
	var setup_noise := func(noise: FastNoiseLite) -> void:
		noise.noise_type = FastNoiseLite.TYPE_PERLIN
		noise.seed = randi()
		noise.frequency = 0.05
		noise.fractal_octaves = 4
	
	setup_noise.call(noise_x)
	setup_noise.call(noise_y)

func _process_shake(delta: float) -> void:
	if shake <= 0.067:
		shake = 0.0
	
	shake = LerpHelper.lf(shake, 0.0, 8.0, delta)
	camera_shake.x = noise_x.get_noise_1d(shake*25)*25
	camera_shake.y = noise_y.get_noise_1d(shake*25)*25

func add_shake(s := 5.0) -> void:
	shake += s


# Bounds
func set_bounds(left_top: Vector2i, right_bottom: Vector2i) -> void:
	limit_left = left_top.x
	limit_top = left_top.y
	limit_right = right_bottom.x
	limit_bottom = right_bottom.y
