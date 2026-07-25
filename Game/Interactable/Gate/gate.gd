extends Polygon2D


func _ready() -> void:
	$StaticBody/Collision.polygon = polygon
	color.h += randf_range(-100, 100)

func _process(delta: float) -> void:
	color.h += delta*0.05

func disable() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.333).set_trans(Tween.TRANS_EXPO)
	tween.tween_callback(queue_free)
