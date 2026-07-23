class_name Player extends CharacterBody2D


const SPEED = 250.0

var momentum := Vector2.ZERO

func _ready() -> void:
	_ready_tail()

func _physics_process(delta: float) -> void:
	_process_movement(delta)
	_process_tail(delta)
	_process_visuals(delta)
	_process_grabber()


# Movement
func _process_movement(delta: float) -> void:
	var input_direction := Input.get_vector("left", "right", "up", "down")
	
	velocity = input_direction * SPEED + momentum
	momentum = momentum.move_toward(Vector2.ZERO, delta)
	
	move_and_slide()


# Tail
const TAIL_DIST := 8.0
@onready var tail: Line2D = $Model/Tail
var tail_points: Array[Vector2]

func _ready_tail() -> void:
	tail_points.assign(tail.points)
	for i in range(tail_points.size()-2):
		tail_points[i+2] = Vector2.ZERO

func _process_tail(delta: float) -> void:
	var direction := global_position.direction_to(get_global_mouse_position())
	
	tail_points[1] = direction * TAIL_DIST
	
	for i in range(tail_points.size()-2):
		var point := tail_points[i+2]
		var target := direction * i*TAIL_DIST
		point = LerpHelper.lv2(point, target, TAIL_DIST*7-i*TAIL_DIST, delta)
		tail_points[i+2] = point
	
	tail.points = tail_points

# Visuals
@onready var visual_0: Polygon2D = $Model/Visual0
@onready var visual_1: Polygon2D = $Model/Visual1
@onready var visual_2: Polygon2D = $Model/Visual2
@onready var visual_3: Polygon2D = $Model/Visual3
func _process_visuals(delta: float) -> void:
	var angle := get_angle_to(get_global_mouse_position())
	visual_0.rotation = LerpHelper.la(visual_0.rotation, angle, 16.0, delta)
	visual_1.rotation = LerpHelper.la(visual_0.rotation, angle, 24.0, delta)
	visual_2.rotation += delta*2.0
	visual_3.rotation -= delta*1.5

# Grabber
@onready var grabber: Area2D = $Model/Grabber
func _process_grabber() -> void:
	var last_point := tail_points[tail_points.size()-1]
	grabber.position = last_point
	grabber.rotation = last_point.angle()
