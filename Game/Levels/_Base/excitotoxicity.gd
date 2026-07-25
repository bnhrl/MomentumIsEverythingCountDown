extends CanvasLayer


func _ready() -> void:
	$Title.offset_transform_scale = Vector2(0.001, 0.001)
	$Subtitle.offset_transform_scale = Vector2(0.001, 0.001)
	await Delays.wait(1.0)
	var tween := create_tween()
	tween.tween_property($Title, "offset_transform_scale:x", 1.0, 0.5).set_trans(Tween.TRANS_ELASTIC).from(0.0)
	tween.parallel().tween_property($Title, "offset_transform_scale:y", 1.0, 0.5).set_trans(Tween.TRANS_EXPO).from(0.0)
	tween.tween_property($Subtitle, "offset_transform_scale:x", 1.0, 0.5).set_trans(Tween.TRANS_EXPO).from(0.0)
	tween.parallel().tween_property($Subtitle, "offset_transform_scale:y", 1.0, 0.5).set_trans(Tween.TRANS_ELASTIC).from(0.0)
	tween.tween_property($Title, "modulate", Color("e83b3b"), 0.5).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property($Subtitle, "modulate", Color("e83b3b"), 0.7).set_trans(Tween.TRANS_EXPO)
