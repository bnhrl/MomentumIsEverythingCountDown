class_name PhageSmacker extends AnimatableBody2D


var momentum := Vector2.ZERO
@onready var _prev_position := global_position
func _physics_process(_delta: float) -> void:
	momentum = global_position - _prev_position
	_prev_position = global_position
