extends Control


func _ready() -> void:
	_ready_background()

func _process(delta: float) -> void:
	_process_background(delta)


var backgrounds: Array[Sprite2D]
func _ready_background() -> void:
	for child in $Background.get_children():
		if child is Sprite2D:
			backgrounds.append(child)
			child.modulate.r = randf_range(0.25, 1.0)
			child.modulate.g = randf_range(0.25, 1.0)
			child.modulate.b = randf_range(0.25, 1.0)

func _process_background(delta: float) -> void:
	for b in backgrounds:
		b.modulate.h += delta * 0.2
