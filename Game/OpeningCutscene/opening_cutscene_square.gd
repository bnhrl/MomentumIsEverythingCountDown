extends CanvasGroup


func activate(delay := 0.0, time := 1.25) -> void:
	modulate.a = 0.67
	await Delays.wait(delay)
	show()
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "scale", Vector2(100, 100), time).set_trans(Tween.TRANS_EXPO).from(Vector2(0.001, 0.001))
	tween.tween_property(self, "rotation", 90.0, time).set_trans(Tween.TRANS_EXPO)
