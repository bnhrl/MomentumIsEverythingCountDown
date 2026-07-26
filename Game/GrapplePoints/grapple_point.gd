class_name GrapplePoint extends Area2D


func _ready() -> void:
	$Sprite.frame = randi_range(0,1)
	$Sprite.frame_progress = randf_range(0.0, 1.0)

func _process(_delta: float) -> void:
	_process_passing()


signal grappled
signal released

func grapple() -> void:
	grappled.emit()

func release() -> void:
	released.emit()

signal passed
func _process_passing() -> void:
	for body in get_overlapping_bodies():
		if body is Player and body.grappled_object == self: 
			body.passed_grapple_object()
			passed.emit()
