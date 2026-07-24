extends Camera2D

func _ready() -> void:
	global_position = get_viewport_rect().size/2.0

var target: Node2D

func _process(_delta: float) -> void:
	if target:
		global_position = target.global_position
	else:
		global_position = get_viewport_rect().size/2.0
	#_process_zoom(delta)

func _process_zoom(delta: float) -> void:
	var z := 1.0 + (GameTime.time_scale-1.0)*0.25
	var target_zoom := Vector2(z,z)
	zoom = LerpHelper.lv2(zoom, target_zoom, 8.0, delta)

func set_bounds(left_top: Vector2i, right_bottom: Vector2i) -> void:
	limit_left = left_top.x
	limit_top = left_top.y
	limit_right = right_bottom.x
	limit_bottom = right_bottom.y
