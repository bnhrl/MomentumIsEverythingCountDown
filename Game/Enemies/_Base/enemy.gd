class_name Enemy extends CharacterBody2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent

@export var speed := 3000.0
@export var momentum_to_kill := 333.0
@export var direction_smoothed := true
@export var idle_movement := true
@export var max_dist_from_origin := 150

var target: Node2D

func _physics_process(delta: float) -> void:
	_process_movement(delta)
	_process_detection()
	_process_passing()
	_process_visuals(delta)


# Movement
@onready var origin_point := global_position
func _process_movement(delta: float) -> void:
	if dead: return
	
	if target:
		navigation_agent.target_position = target.global_position
		if direction_smoothed:
			_process_direction_smoothed_movement(delta)
		else:
			velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * speed * delta
	else:
		if idle_movement:
			_process_idle_movement(delta)
		else:
			velocity = Vector2.ZERO
	
	move_and_slide()

var direction := Vector2.ZERO
func _process_direction_smoothed_movement(delta: float) -> void:
	var target_direction := global_position.direction_to(navigation_agent.get_next_path_position())
	direction = LerpHelper.lv2(direction, target_direction, 8.0, delta)
	var target_velocity := direction * speed * delta
	velocity = LerpHelper.lv2(velocity, target_velocity, 8.0, delta)

@onready var idle_timer: Timer = $IdleTimer
func _process_idle_movement(delta: float) -> void:
	if global_position.distance_to(origin_point) >= max_dist_from_origin:
		idle_timer.start(randf_range(0.5, 1))
		direction = global_position.direction_to(origin_point)
	elif idle_timer.is_stopped():
		idle_timer.start(randf_range(0.5, 1))
		direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	
	var target_velocity := direction * speed * delta
	velocity = LerpHelper.lv2(velocity, target_velocity, 8.0, delta)




# Detection
@onready var detection_area: Area2D = $DetectionArea
@onready var detection_ray: RayCast2D = $DetectionArea/DetectionRay
func _process_detection() -> void:
	if target or dead: return
	
	for b in detection_area.get_overlapping_bodies():
		if b is Player:
			detection_ray.look_at(b.global_position)
			await get_tree().physics_frame
			if can_see_object(b):
				target = b
				break


func can_see_object(object: Node2D) -> bool:
	if detection_ray.is_colliding() and detection_ray.get_collider() == object: return true
	return false



# Passing
func _process_passing() -> void:
	if dead: return
	
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		if collision:
			var collider := collision.get_collider()
			if collider is Player:
				if collider.get_momentum() >= momentum_to_kill:
					die()
					collider.passed_grapple_object()
					collider.play_kill_audio()
				else: 
					collider.die()
				break


# Death
var dead := false
func die() -> void:
	if dead: return
	
	GameTime.set_temp_scale(0.01)
	Effects.brighten(.75)
	Camera.add_shake()
	$Collision.queue_free()
	var tween := create_tween()
	tween.tween_property($Model, "scale:y", 0.001, 0.33).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property($Model, "scale:x", 0.001, 0.5).set_trans(Tween.TRANS_EXPO)
	tween.tween_callback(queue_free)

# Visuals
@onready var model: CanvasGroup = $Model
func _process_visuals(_delta: float) -> void:
	model.rotation = velocity.angle()
