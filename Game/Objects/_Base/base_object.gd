class_name BouncyObject extends StaticBody2D


@export var ricochet_speed_mult := 1.5 ## Ricocheting, by default, is a mult of 0.8

func bounced_off_of() -> void:
	var effect := $Sprite2D.duplicate()
	add_child(effect)
	effect.transform = $Sprite2D.transform
	var tween := effect.create_tween()
	tween.set_parallel()
	tween.tween_property(effect, "scale", effect.scale * 2.0, 0.45)
	tween.tween_property(effect, "modulate:a", 0.0, 0.333)
	tween.set_parallel(false)
	tween.tween_callback(effect.queue_free)
	
