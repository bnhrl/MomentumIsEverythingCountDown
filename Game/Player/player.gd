extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var momentum := Vector2.ZERO

func _ready() -> void:
	_ready_tail()

func _physics_process(delta: float) -> void:
	_process_movement(delta)
	_process_tail(delta)


# Movement
func _process_movement(delta: float) -> void:
	var input_direction := Input.get_vector("left", "right", "up", "down")
	
	velocity = input_direction * SPEED + momentum
	momentum = momentum.move_toward(Vector2.ZERO, delta)
	
	move_and_slide()


# Tail
@onready var tail: Line2D = $Model/Tail
var tail_points: Array[Vector2]

func _ready_tail() -> void:
	tail_points.assign(tail.points)

func _process_tail(delta: float) -> void:
	tail_points[0] = global_position
	tail_points[1] = global_position + global_position.direction_to(get_global_mouse_position()) * 8.0
	tail.points = tail_points
