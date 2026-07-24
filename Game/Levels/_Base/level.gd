class_name Level extends Node2D


func _ready() -> void:
	Camera.set_bounds($Bounds.position, $Bounds.size + $Bounds.position)
