extends Node2D


signal pressed
func _on_button_interactable_interacted() -> void:
	$Sprite.animation = "pressed"
	pressed.emit()
	$EffectSprite.show()
	$EffectSprite.play("default")
	var tween := create_tween()
	tween.tween_property($EffectSprite, "modulate:a", 0.0, 0.35)
	tween.tween_callback($EffectSprite.hide)
	$SoundPlayer.pitch_scale = randf_range(0.9,1.1)
	$SoundPlayer.play()
