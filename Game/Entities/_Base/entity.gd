class_name Entity extends CharacterBody2D


@export var speed := 300.0
@export var max_dist_from_origin := 150


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	_process_movement(delta)


@onready var redirect_timer: Timer = $RedirectTimer
@onready var origin_point := global_position
var direction := Vector2.ZERO
func _process_movement(delta: float) -> void:
	if global_position.distance_to(origin_point) >= max_dist_from_origin:
		redirect_timer.start(randf_range(0.5, 1))
		direction = global_position.direction_to(origin_point)
	elif redirect_timer.is_stopped():
		redirect_timer.start(randf_range(0.5, 1))
		direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	
	var target_velocity := direction * speed * delta
	velocity = LerpHelper.lv2(velocity, target_velocity, 8.0, delta)
