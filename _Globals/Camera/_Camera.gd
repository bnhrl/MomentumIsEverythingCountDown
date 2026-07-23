extends Camera2D


var target: Node2D

func _process(_delta: float) -> void:
	global_position = target.global_position
