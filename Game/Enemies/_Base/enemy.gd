extends CharacterBody2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent

@export var speed := 3000.0

var target: Node2D

func _physics_process(delta: float) -> void:
	_process_movement(delta)
	_process_detection()


# Movement
func _process_movement(delta: float) -> void:
	# TODO more complex movement:
		# Maybe they slide if they miss you? Idk I'm not reading the document as I'm 
		# typing this so maybe that has the enemy movement stuff
	if target:
		navigation_agent.target_position = target.global_position
		velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * speed * delta
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()


# Detection
@onready var detection_area: Area2D = $DetectionArea
@onready var detection_ray: RayCast2D = $DetectionArea/DetectionRay
func _process_detection() -> void:
	if target: return
	
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
