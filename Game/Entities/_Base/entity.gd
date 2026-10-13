class_name Entity extends CharacterBody2D


@export var speed := 300.0
@export var max_dist_from_origin := 150
@export var killable := false
@export var blood_color := Color("e83b3b")


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	_process_movement(delta)
	_process_dying()
	_process_visuals(delta)
	move_and_slide()


# Movement
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


# Collisions
func _process_dying() -> void:
	if dead or not killable: return
	
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		if collision:
			var collider := collision.get_collider()
			if collider is Enemy:
				$NotBloodParticles.look_at(collider.global_position)
				$NotBloodParticles.rotation += PI
				die()


# Visuals
@onready var model: CanvasGroup = $Model
func _process_visuals(_delta: float) -> void:
	pass


# Death
var dead := false
func die() -> void:
	if dead: return
	dead = true
	
	for child in get_children():
		if child is GrapplePoint: child.queue_free()
	
	Effects.brighten(0.1)
	$Collision.queue_free()
	var tween := create_tween()
	tween.tween_property($Model, "scale:y", 0.001, 0.33).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property($Model, "scale:x", 0.001, 0.5).set_trans(Tween.TRANS_EXPO)
	$DeathSound.play()
	$NotBloodParticles.modulate = blood_color
	$NotBloodParticles.dp_restart()
	await $NotBloodParticles.dp_finished
	queue_free()
